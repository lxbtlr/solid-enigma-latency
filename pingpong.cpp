#include <math.h>
#include <pthread.h> // pthread api
#include <sched.h>   // for processor affinity
#include <stdint.h>
#include <stdio.h>
#include <string.h>
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

void* ping(void* input)
{

  long t_id = (long)input;
  cpu_set_t set;
  CPU_ZERO(&set);
  CPU_SET(t_id, &set);
  if (sched_setaffinity(0, sizeof(set), &set) < 0) {
    perror("Can't setaffinity");
    exit(-1);
  }

  // Sender Thread

  uint64_t start, end;
  // should start the clock and write to data in memory
  rdtscll(start);

  shared_mem = 1; // write to memory
  while (shared_mem == 1) {

    // sit and wait
  }
  rdtscll(end);
  void* time = (void*)(end - start);
#if VERBOSE
  fprintf(stderr, "[INFO] Exiting thread %lu\n", t_id);
#endif
  pthread_exit(time);
}

void* pong(void* input)
{
  // Receiver Thread
  long t_id = (long)input;
  cpu_set_t set;
  CPU_ZERO(&set);
  CPU_SET(t_id, &set);
  if (sched_setaffinity(0, sizeof(set), &set) < 0) {
    perror("Can't setaffinity");
    exit(-1);
  }
  // should observe the change in memory,
  while (shared_mem != 1) {
    // sit and wait
  }
  shared_mem = 2;
  // then overwrite (restore) the value

#if VERBOSE
  fprintf(stderr, "[INFO] Exiting thread %lu\n", t_id);
#endif
  // then exit
  pthread_exit(NULL);
}

long set_pingpong(long thread1, long thread2) //, int num_procs)
{
  void* time;
  // Set up the threads
  long start_condition;
#if VERBOSE
  printf("Start threads\n");
#endif
  start_condition = pthread_create(&(tid[thread1]),
      NULL,
      pong,
      (void*)thread1);

  if (start_condition == 0) {
#if VERBOSE
    printf("[INFO] PONG started correct\n");
#endif
  }

  start_condition = pthread_create(&(tid[thread2]),
      NULL,
      ping,
      (void*)thread2);

  if (start_condition == 0) {
#if VERBOSE
    printf("[INFO] PING started correct\n");
#endif
  }
  // rejoin threads
  pthread_join(tid[thread1], NULL);
  pthread_join(tid[thread2], &time);

  shared_mem = 0; // reset mem

  return (long)time;
}

stats pair(const long thread1, const long thread2)
{

  int i;
  uint64_t lmin = INT_MAX;
  uint64_t lmax = INT_MIN;
  uint64_t aavg;

  pair_data = (long*)malloc(sizeof(long) * NUM_ITERS);

  for (i = 0; i < NUM_ITERS; i++) {
    long current = (long)set_pingpong(thread1, thread2);
    lmin = MIN(lmin, current);
    lmax = MAX(lmax, current);
    pair_data[i] = current;
#if VERBOSE
    printf("iter: %i complete\n", i);
#endif
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

stats tournament(const long prima, const int beg, const int last)
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

  // NOTE: sweep from first thread to last thread, excluding primary thread
  for (int i = beg; i <= last; i++) {
    if (i == prima) {
      // TODO:[x] catch case where we are playing ping pong with our self
    } else {
      pdata = (long*)malloc(sizeof(long) * NUM_ITERS);

      uint64_t lmin = INT_MAX;
      uint64_t lmax = INT_MIN;
      uint64_t aavg;

      for (int j = 0; j < NUM_ITERS; j++) {
        long current = (long)set_pingpong(prima, i);
        lmin = MIN(lmin, current);
        lmax = MAX(lmax, current);
        pdata[j] = current;
#if VERBOSE
        printf("iter: %i complete\n", i);
#endif
      }
      SUM(aavg, pdata);

      fprintf(f, "l,%lu,%i,%lu,%lu,%lu,\n", prima, i, lmin, lmax, aavg);

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
  // fflush(stdout);
  if (argc != 5) {
    // TODO: bake modes into this (thread pairs vs thread sweeps)
    printf("usage: pingpong thread_1 thread_2 Avoid_HT Mode\n");
    exit(-1);
  }
  t1 = atoi(argv[1]);       // thread 1
  t2 = atoi(argv[2]);       // thread 2
  AVOID_HT = atoi(argv[3]); // avoid hyperthreading?
  mode = atoi(argv[4]);     // op mode

  tid = (pthread_t*)malloc(sizeof(pthread_t) * (t2 - t1) /*num threads */);
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
    // NOTE: THIS ONE
    // fprintf(f, "stat,t1,t2,min,max,aavg,\n");

    // FIXME:
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
  // fclose(f);
}
