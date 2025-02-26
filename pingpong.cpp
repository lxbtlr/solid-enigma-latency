#include <cstdint>
#include <math.h>
#include <pthread.h> // pthread api
#include <sched.h>   // for processor affinity
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
/*
 * thread to thread latency test.
 * Times collected should be the combination of trip to thread, write to data,
 * and flight back to original thread
 * 1. do this first using c constructs (types etc)
 * 2. do this again using inline assembly
 */
#define VERBOSE 0
#define NUM_ITERS 1000
#define INT_MAX 0x7fffffff
#define INT_MIN 0

#define uchar_t uint8_t
// Tim64_ter mechanism using rdtsc (?)
#define rdtscll(val)                          \
  do {                                        \
    uint64_t tsc;                             \
    uint32_t a, d;                            \
    asm volatile("rdtsc" : "=a"(a), "=d"(d)); \
    *(uint32_t*)&(tsc) = a;                   \
    *(uint32_t*)(((uchar_t*)&tsc) + 4) = d;   \
    val = tsc;                                \
  } while (0)

#define MIN(x, y) (((uint64_t)x) < ((uint64_t)y) ? ((uint64_t)x) : ((uint64_t)y))
#define MAX(x, y) (((uint64_t)x) > ((uint64_t)y) ? ((uint64_t)x) : ((uint64_t)y))

#define SUM(val, _data)                                          \
  do {                                                           \
    uint64_t sum = 0;                                            \
    for (int j = 0; j < (sizeof(_data) / sizeof(*_data)); j++) { \
      sum += _data[j];                                           \
    }                                                            \
    val = sum;                                                   \
  } while (0)

FILE* f = fopen("test.out", "w");

struct sharedm { // thank you kevin for the more cogent solution to this
  uint64_t tid;
  uint64_t cpu;
  uint64_t* read_addr; // TODO: double check if we need volatile flags here
  uint64_t* write_addr;
};

#define mk_shared_data(thread1, thread2) \
  void* serve = mmap(NULL, 0x1000,       \
      PROT_READ | PROT_WRITE,            \
      MAP_SHARED | MAP_ANONYMOUS,        \
      0, 0);                             \
                                         \
  memset(serve, 0, 0x1000);              \
                                         \
  void* volley = mmap(NULL, 0x1000,      \
      PROT_READ | PROT_WRITE,            \
      MAP_SHARED | MAP_ANONYMOUS,        \
      0, 0);                             \
  memset(volley, 0, 0x1000);             \
  struct sharedm t1 {                    \
    .tid = tid[thread1],                 \
    .cpu = thread1,                      \
    .read_addr = (uint64_t*)volley,      \
    .write_addr = (uint64_t*)serve,      \
  };                                     \
  struct sharedm t2 {                    \
    .tid = tid[thread2],                 \
    .cpu = thread2,                      \
    .read_addr = (uint64_t*)serve,       \
    .write_addr = (uint64_t*)volley,     \
  };

struct stats {
  // min, max, aavg, gavg
  uint64_t min;
  uint64_t max;
  uint64_t aavg;
};

int NUM_THREADS;
int AVOID_HT;

stats* heatmap;
pthread_t* tid;
long* pdata;
long* pair_data;
// need volatile to prevent compiler interfering
volatile int shared_mem = 0;

void memrst(sharedm data)
{
  memset(data.write_addr, 0, 0x1000);
  memset(data.read_addr, 0, 0x1000);
}

void* ping(void* input)
{

  struct sharedm* d = (sharedm*)input;
  // long t_id = (long)input;
  cpu_set_t set;
  CPU_ZERO(&set);
  // printf("ping:\t%lu\n", d->cpu);
  CPU_SET(d->cpu, &set);
  if (sched_setaffinity(0, sizeof(set), &set) < 0) {
    perror("Can't setaffinity");
    exit(-1);
  }

  uint64_t start, end;
  // should start the clock and write to data in memory
  rdtscll(start);

  *d->write_addr = 1;          // serve ball
  while (*d->read_addr == 0) { // wait for return
    // sit and wait
  }
  rdtscll(end);
  //  NOTE: RESET VAL

  void* time = (void*)(end - start);

  //  Sender Thread

#if VERBOSE
  fprintf(stderr, "[INFO] Exiting thread %lu\n", d->cpu);
#endif
  pthread_exit((void*)time);
}

void* pong(void* input)
{
  // Receiver Thread
  struct sharedm* d = (sharedm*)input;
  // old system:
  cpu_set_t set;
  CPU_ZERO(&set);
  CPU_SET(d->cpu, &set);
  if (sched_setaffinity(0, sizeof(set), &set) < 0) {
    perror("Can't setaffinity");
    exit(-1);
  }

  // should observe the change in memory,
  while (*d->read_addr == 0) {
    // sit and wait
  }
  *d->write_addr = 1;

#if VERBOSE
  fprintf(stderr, "[INFO] Exiting thread %lu\n", d->cpu);
#endif
  // then exit
  pthread_exit(NULL);
}

long set_pingpong(sharedm thread1, sharedm thread2) //, int num_procs)
{
  void* time;
  // Set up the threads
  long start_condition;
#if VERBOSE
  printf("Start threads\n");
#endif
  start_condition = pthread_create(&(thread1.tid),
      NULL,
      pong,
      (void*)&thread1);

#if VERBOSE
  if (start_condition == 0) {
    printf("[INFO] PONG started correct\n");
  }
#endif

  start_condition = pthread_create(&(thread2.tid),
      NULL,
      ping,
      (void*)&thread2);

#if VERBOSE
  if (start_condition == 0) {
    printf("[INFO] PING started correct\n");
  }
#endif
  // rejoin threads
  pthread_join(thread2.tid, &time);
#if VERBOSE
  printf("[INFO] PING joined correct\n");
#endif

  memrst(thread1);
  return (long)time;
}

stats pair(const uint64_t thread1, const uint64_t thread2)
{

  int i;
  uint64_t lmin = INT_MAX;
  uint64_t lmax = INT_MIN;
  uint64_t aavg;

  tid = (pthread_t*)malloc(sizeof(pthread_t) * (2) /*num threads */);

  mk_shared_data(thread1, thread2);

  pair_data = (long*)malloc(sizeof(long) * NUM_ITERS);

  for (i = 0; i < NUM_ITERS; i++) {
    long current = (long)set_pingpong(t1, t2);
    lmin = MIN(lmin, current);
    lmax = MAX(lmax, current);
    pair_data[i] = current;
#if VERBOSE
    printf("iter: %li complete\n", i);
#endif
    // memrst(t1);
  }
#if VERBOSE
  printf("Calc stats\n");
#endif
  SUM(aavg, pair_data);
  stats single = {
    .min = lmin,
    .max = lmax,
    .aavg = aavg,
  };

  // printf("latency:\t %lu clk cycles\n", (long)set_pingpong(t1, t2));
  printf("min: %lu\nmax: %lu\naavg: %lu\n", single.min, single.max, single.aavg);

  return single;
}

stats tournament(const uint64_t prima, const int beg, const int last)
{
  // Ping Pong Thread Tournament,
  // Generate the min and avg scores from ping pong test of one thread to all
  //
  // @param tid - thread id (this may need to be the tid array)
  // @param beg - beginning thread to sweep
  // @param end - last thread to sweep
  //
  // @return vals - stats from the sweep, including min & aavg

  // FIXME: there will be a hole in the data array for the thread to itself pair,
  // be careful when generating stats for thread to all
  uint64_t gmin = INT_MAX;
  uint64_t gmax = INT_MIN;
  uint64_t gaavg = 0;

  tid = (pthread_t*)malloc(sizeof(pthread_t) * (last - beg) /*num threads */);
  // NOTE: sweep from first thread to last thread, excluding primary thread
  for (uint64_t i = beg; i <= last; i++) {
    if (i == prima) {
      // TODO:[x] catch case where we are playing ping pong with our self
    } else {
      pdata = (long*)malloc(sizeof(long) * NUM_ITERS);

      mk_shared_data(prima, i);
      uint64_t lmin = INT_MAX;
      uint64_t lmax = INT_MIN;
      uint64_t aavg;

      for (int j = 0; j < NUM_ITERS; j++) {
        long current = (long)set_pingpong(t1, t2);
        lmin = MIN(lmin, current);
        lmax = MAX(lmax, current);
        pdata[j] = current;
#if VERBOSE
        printf("iter: %i complete\n", i);
#endif
      }
      SUM(aavg, pdata);

      fprintf(f, "l,%lu,%li,%lu,%lu,%lu,\n", prima, i, lmin, lmax, aavg);

      gmin = MIN(gmin, lmin);
      gmax = MAX(gmax, lmax);
      gaavg = (gaavg + aavg) / 2;
    }
  }

  stats gstats = {
    .min = gmin,
    .max = gmax,
    .aavg = gaavg,
  };
#if VERBOSE
  printf("%lu, %lu, %lu, %lu, %i\n", prima, gstats.min, gstats.max, gstats.aavg, NUM_ITERS);
#endif
  fprintf(f, "g,%lu,%lu,%lu,%lu,%i\n", prima, gstats.min, gstats.max, gstats.aavg, NUM_ITERS);
  return gstats;
}

int main(int argc, char* argv[])
{
  int mode;
  long t1, t2;

  if (argc != 4) {
    // TODO: bake modes into this (thread pairs vs thread sweeps)
    printf("usage: pingpong thread_1 thread_2 Mode\n");
    exit(-1);
  }
  t1 = atoi(argv[1]); // thread 1
  t2 = atoi(argv[2]); // thread 2
  // AVOID_HT = atoi(argv[3]); // avoid hyperthreading?
  mode = atoi(argv[3]); // op mode

  // pthread_t tid[t2];
  //  malloc the data array
#if VERBOSE
  printf("Start Tests\n");
#endif
  switch (mode) {
  case 0: {
#if VERBOSE
    printf("pair mode\n");
#endif
    printf("tid,min,max,aavg,NUM_ITERS,\n");

    stats pair_mode = pair(t1, t2);
    break;
  }
  case 1: {
#if VERBOSE
    printf("Tournament mode\n");
#endif
    fprintf(f, "stat,t1,t2,min,max,aavg,\n");
    heatmap = (stats*)malloc(sizeof(stats) * (t2 - t1) /*num threads */);
    for (int thread_num = t1; thread_num <= t2; thread_num++) {
      heatmap[thread_num] = tournament(thread_num, t1, t2);
    }
    break;
  }
  default: {
    fprintf(stderr, "usage: pingpong thread_1 thread_2 Avoid_HT Mode\n");
    fprintf(stderr, "\t\t\t\t\t^^Mode not Mapped\n");
  }
  }
  // mlockall(MCL_CURRENT | MCL_FUTURE);
}
