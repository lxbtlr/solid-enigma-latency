#include <atomic>
#include <bitset>
#include <iostream>
#include <limits>
#include <math.h>
#include <pthread.h> // pthread api
#include <sched.h>   // for processor affinity
#include <stdint.h>
#include <stdio.h>
#include <string.h>
/*
 * thread to thread latency test.
 * Times collected should be the combination of trip to thread, write to data,
 * and flight back to original thread
 * 1. do this first using c constructs (types etc)
 * 2. do this again using inline assembly
 */

pthread_t* tid;
long* data;
// need volatile to prevent compiler interfering
volatile int shared_mem = 0;

struct stats {
  // min, max, aavg, gavg
  uint64_t min;
  uint64_t max;
  uint64_t aavg;
  uint64_t gavg;
};

#define NUM_ITERS 100
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

#define MIN(x, y) ((x) < (y) ? (x) : (y))
#define MAX(x, y) ((x) > (y) ? (x) : (y))

#define SUM(val, _data)                                          \
  do {                                                           \
    uint64_t sum = 0;                                            \
    for (int j = 0; j < (sizeof(_data) / sizeof(*_data)); j++) { \
      sum += _data[j];                                           \
    }                                                            \
    val = sum;                                                   \
  } while (0)

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
  fprintf(stderr, "[INFO] Exiting thread %lu\n", t_id);
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

  fprintf(stderr, "[INFO] Exiting thread %lu\n", t_id);
  // then exit
  pthread_exit(NULL);
}

long set_pingpong(long thread1, long thread2) //, int num_procs)
{
  void* time;
  // Set up the threads
  long start_condition;
  printf("Start threads\n");
  start_condition = pthread_create(&(tid[thread1]),
      NULL,
      pong,
      (void*)thread1);

  if (start_condition == 0) {
    printf("[INFO] PONG started correct\n");
  }

  start_condition = pthread_create(&(tid[thread2]),
      NULL,
      ping,
      (void*)thread2);

  if (start_condition == 0) {
    printf("[INFO] PING started correct\n");
  }
  // rejoin threads
  pthread_join(tid[thread1], NULL);
  pthread_join(tid[thread2], &time);

  shared_mem = 0; // reset mem

  return (long)time;
}

int main(int argc, char* argv[])
{
  int i;
  long t1, t2;
  long pingpong_time;

  if (argc != 3) {
    fprintf(stderr, "usage: pingpong thread_1 thread_2\n");
    exit(-1);
  }
  t1 = atoi(argv[1]); // thread 1
  t2 = atoi(argv[2]); // thread 2

  tid = (pthread_t*)malloc(sizeof(pthread_t) * 2 /*num threads */);

  printf("Start PingPong\n");

  // malloc the data array
  data = (long*)malloc(sizeof(long) * NUM_ITERS);

  uint64_t lmin = INT_MAX;
  uint64_t lmax = INT_MIN;
  uint64_t aavg, gavg;

  printf("Start Tests\n");
  for (i = 0; i < NUM_ITERS; i++) {
    long current = (long)set_pingpong(t1, t2);
    lmin = MIN(lmin, current);
    lmax = MAX(lmax, current);
    data[i] = current;
    printf("iter: %i complete\n", i);
  }
  printf("Calc stats\n");
  SUM(aavg, data);
  stats single = { .min = lmin, .max = lmax, .aavg = aavg, .gavg = gavg };

  // printf("latency:\t %lu clk cycles\n", (long)set_pingpong(t1, t2));
  printf("min: %lu\nmax: %lu\naavg: %lu\ngavg: %lu\n", single.min, single.max, single.aavg, single.gavg);
}
