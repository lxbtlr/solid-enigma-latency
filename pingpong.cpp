#include <climits>
#include <cstdint>
#include <math.h>
#include <pthread.h> // pthread api
#include <sched.h>   // for processor affinity
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <vector>
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

FILE* f = fopen("test.out", "w");

struct sharedm { // thank you kevin for the more cogent solution to this
  // pthread_t tid;
  uint64_t cpu;
  uint64_t* read_addr;
  uint64_t* write_addr;
};

struct stats {
  // min, max, aavg, gavg
  uint64_t min;
  uint64_t max;
  uint64_t aavg;
};

int NUM_THREADS;
int AVOID_HT;

// stats* heatmap;
std::vector<stats> heatmap;
// pthread_t* tid;
// std::vector<pthread_t> tid(2);
// long* pdata;
std::vector<long> pdata(NUM_ITERS);
// long* pair_data;
// std::vector<long> pair_data[NUM_ITERS];
// need volatile to prevent compiler interfering

void v_avg(uint64_t* output, std::vector<long> input_vec)
{

  uint64_t total = 0;
  uint64_t length = input_vec.size();
  for (uint64_t i = 0; i < length; i++) {
    total += input_vec[i];
  }
  *output = total;
}

void memrst(sharedm* data)
{
  memset(data->write_addr, 0, 0x1000);
  memset(data->read_addr, 0, 0x1000);
}

void mk_sharedms(sharedm* t1, sharedm* t2, const uint64_t thread1, const uint64_t thread2)
{
  void* serve = mmap(NULL, 0x1000,
      PROT_READ | PROT_WRITE,
      MAP_SHARED | MAP_ANONYMOUS,
      0, 0);

  memset(serve, 0, 0x1000);

  void* volley = mmap(NULL, 0x1000,
      PROT_READ | PROT_WRITE,
      MAP_SHARED | MAP_ANONYMOUS,
      0, 0);
  memset(volley, 0, 0x1000);

  // t1->tid = tid[thread1];
  t1->cpu = thread1;
  t1->read_addr = (uint64_t*)volley;
  t1->write_addr = (uint64_t*)serve;

  // t2->tid = tid[thread2];
  t2->cpu = thread2;
  t2->read_addr = (uint64_t*)serve;
  t2->write_addr = (uint64_t*)volley;
}

static void* ping(void* input)
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

  // printf("[INFO] PING af set\n");
  uint64_t start, end;
  // should start the clock and write to data in memory
  rdtscll(start);

  *d->write_addr = 1; // serve ball
  // printf("[INFO] PING writes\n");
  while (*d->read_addr == 0) { // wait for return
    // sit and wait
    // printf("[INFO] PING waiting\n");
  }
  rdtscll(end);
  // printf("[INFO] PING reads\n");
  //   NOTE: RESET VAL

  void* time = (void*)(end - start);

  //  Sender Thread

#if VERBOSE
  fprintf(stderr, "[INFO] Exiting thread %lu\n", d->cpu);
#endif
  pthread_exit((void*)time);
}

static void* pong(void* input)
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
  // printf("[INFO] PONG af set\n");

  // should observe the change in memory,
  while (*d->read_addr == 0) {
    // sit and wait
    // printf("[INFO] PONG waiting\n");
  }
  // printf("[INFO] PONG reads\n");
  *d->write_addr = 1;
  // printf("[INFO] PONG write\n");

#if VERBOSE
  fprintf(stderr, "[INFO] Exiting thread %lu\n", d->cpu);
#endif
  // then exit
  pthread_exit(NULL);
}
// TODO: take in two cpus  and shared mem

struct passes {
  uint64_t player1;
  uint64_t player2;
  uint64_t* first;
  uint64_t* second;
};

void* ping2(void* _g)
{
  struct passes* g = (passes*)_g;
  // long t_id = (long)input;
  cpu_set_t set;
  CPU_ZERO(&set);
  // printf("ping:\t%lu\n", d->cpu);
  CPU_SET(g->player1, &set);
  if (sched_setaffinity(0, sizeof(set), &set) < 0) {
    perror("Can't setaffinity");
    exit(-1);
  }

  uint64_t start, end;
  // should start the clock and write to data in memory
  rdtscll(start);

  *g->first = 1;            // serve ball
  while (*g->second == 0) { // wait for return
    // sit and wait
    // printf("ping wait\n");
  }
  rdtscll(end);
  *g->first = 0; // serve ball

  void* time = (void*)(end - start);

  pthread_exit((void*)time);
}
void* pong2(void* _g)
{
  struct passes* g = (passes*)_g;
  cpu_set_t set;
  CPU_ZERO(&set);
  CPU_SET(g->player2, &set);
  if (sched_setaffinity(0, sizeof(set), &set) < 0) {
    perror("Can't setaffinity");
    exit(-1);
  }
  // should observe the change in memory,
  while (*g->first == 0) {
    // sit and wait
    // printf("pong wait\n");
  }
  *g->second = 1;

#if VERBOSE
  fprintf(stderr, "[INFO] Exiting thread %lu\n", g->player2);
#endif

  while (*g->first != 0) { }
  *g->second = 0; // serve ball
  pthread_exit(NULL);
}

long second_option(uint64_t cpu1, uint64_t cpu2)
{

  void* time;
  pthread_t* tid;

  void* serve = mmap(NULL, 0x1000,
      PROT_READ | PROT_WRITE,
      MAP_SHARED | MAP_ANONYMOUS,
      0, 0);

  memset(serve, 0, 0x1000);

  void* volley = mmap(NULL, 0x1000,
      PROT_READ | PROT_WRITE,
      MAP_SHARED | MAP_ANONYMOUS,
      0, 0);
  memset(volley, 0, 0x1000);

  struct passes game {
    .player1 = cpu1,
    .player2 = cpu2,
    .first = (uint64_t*)serve,
    .second = (uint64_t*)volley,
  };

  tid = (pthread_t*)malloc(sizeof(pthread_t) * 2);

  // Set up the threads
  long start_condition;
#if VERBOSE
  printf("Start threads\n");
#endif
  // player 1
  start_condition = pthread_create(&tid[0],
      NULL,
      pong2,
      (void*)&game);

#if VERBOSE
  if (start_condition == 0) {
    printf("[INFO] PONG started correct\n");
  }
#endif

  // player 2
  start_condition = pthread_create(&tid[1],
      NULL,
      ping2,
      (void*)&game);

#if VERBOSE
  if (start_condition == 0) {
    printf("[INFO] PING started correct\n");
  }
#endif
  pthread_join(tid[0], NULL);
  pthread_join(tid[1], &time);

  //*game.first = 0;
  //*game.second = 0;
  munmap(serve,0x1000);
  munmap(volley,0x1000);
  return (long)time;
}

long set_pingpong(sharedm thread1, sharedm thread2) //, int num_procs)
{
  void* time;
  pthread_t* tid;

  tid = (pthread_t*)malloc(sizeof(pthread_t) * 2);

  // Set up the threads
  long start_condition;
#if VERBOSE
  printf("Start threads\n");
#endif
  start_condition = pthread_create(&tid[0],
      NULL,
      pong,
      (void*)&thread1);

#if VERBOSE
  if (start_condition == 0) {
    printf("[INFO] PONG started correct\n");
  }
#endif

  start_condition = pthread_create(&tid[1],
      NULL,
      ping,
      (void*)&thread2);

#if VERBOSE
  if (start_condition == 0) {
    printf("[INFO] PING started correct\n");
  }
#endif
  // rejoin threads
  // pthread_join(tid[0], NULL);
  // printf("[INFO] PONG joined correct\n");
  // pthread_join(tid[0], NULL);
  pthread_join(tid[1], &time);
#if VERBOSE
  printf("[INFO] PING joined correct\n");
#endif

  memrst(&thread1);
  return (long)time;
}

stats pair(const uint64_t thread1, const uint64_t thread2)
{

  int i;
  uint64_t lmin = INT_MAX;
  uint64_t lmax = INT_MIN;
  uint64_t aavg;
  struct sharedm t1, t2;

  // std::vector<pthread_t> tid(2);

  // tid = (pthread_t*)malloc(sizeof(pthread_t) * (2) /*num threads */);

  mk_sharedms(&t1, &t2, thread1, thread2);

  // pair_data = (long*)malloc(sizeof(long) * NUM_ITERS);

  for (i = 0; i < NUM_ITERS; i++) {
    // long current = (long)set_pingpong(t1, t2);
    printf("%lu\n", i);
    long current = (long)second_option(thread1, thread2);
    lmin = MIN(lmin, current);
    lmax = MAX(lmax, current);
    pdata.at(i) = current;
#if VERBOSE
    printf("iter: %li complete\n", i);
#endif
    // memrst(t1);
  }
#if VERBOSE
  printf("Calc stats\n");
#endif
  v_avg(&aavg, pdata);
  stats single = {
    .min = lmin,
    .max = lmax,
    .aavg = aavg,
  };

  // printf("latency:\t %lu clk cycles\n", (long)set_pingpong(t1, t2));
  printf("min: %lu\nmax: %lu\naavg: %lu\n", single.min, single.max, single.aavg);

  return single;
}

stats tournament(const uint64_t prima, const uint64_t beg, const uint64_t last)
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

  struct sharedm t1, t2;
  mk_sharedms(&t1, &t2, prima, prima);
  // std::vector<pthread_t> tid(last - beg);
  //   NOTE: sweep from first thread to last thread, excluding primary thread
  std::vector<long> tour(NUM_ITERS,0);
  for (uint64_t i = beg; i <= last; i++) {
    if (i == prima) {
      // TODO:[x] catch case where we are playing ping pong with our self
      std::fill(tour.begin(), tour.end(), 0);
    } else {
      // pdata = (long*)malloc(sizeof(long) * NUM_ITERS);
      printf("now testing i:%lu\n", i);
      t2.cpu = i;
      //printf("mksharedms complete\n");

      printf("mkshared, %lu\n", t2.cpu);
      uint64_t lmin = INT_MAX;
      uint64_t lmax = INT_MIN;
      uint64_t aavg;

      for (int j = 0; j < NUM_ITERS; j++) {
        // long current
        tour[j] = second_option(prima, i);
        lmin = MIN(lmin, tour[j]);
        lmax = MAX(lmax, tour[j]);
        // tour[j] = current;

#if VERBOSE
        printf("iter: %lu complete\n", i);
#endif
      }
      v_avg(&aavg, tour);
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
  // long t1, t2;

  if (argc != 4) {
    // TODO: bake modes into this (thread pairs vs thread sweeps)
    printf("usage: pingpong thread_1 thread_2 Mode\n");
    exit(-1);
  }
  long t1 = (uint64_t)atol(argv[1]); // thread 1
  long t2 = (uint64_t)atol(argv[2]); // thread 2
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
    // heatmap = (stats*)malloc(sizeof(stats) * (t2 - t1) /*num threads */);

    // std::vector<pthread_t> tid(t2 - t1);
    for (uint64_t thread_num = t1; thread_num <= t2; thread_num++) {
      printf("now testing p:%lu\n", thread_num);
      heatmap.push_back(tournament(thread_num, t1, t2));
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
