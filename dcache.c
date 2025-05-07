#define _GNU_SOURCE
#include <pthread.h> // pthread api
#include <sched.h>   // for processor affinity
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
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

#define NUM_TRIALS 10000
uint64_t ntrials = NUM_TRIALS;

#define INT_MAX_TEMP 0x7fffffff
#define INT_MIN_TEMP 0

#define NUM_THREADS 2

#define DBG "[INFO] "
#define COLOR_BOLD_YELLOW "\e[1;33m"
#define COLOR_BOLD_RED "\e[1;31m"
#define COLOR_RESET "\e[0m"
#define ALERT(str) COLOR_BOLD_RED str COLOR_RESET

#define FNAME "dcache_out.file"

#define uchar_t uint8_t
// Timer mechanism using rdtsc (?)
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

pthread_barrier_t barrier;

typedef struct { // thank you kevin for the more cogent solution to this
  // pthread_t tid;
  uint64_t cpu;
  uint64_t* read_addr;
  uint64_t* write_addr;
} sharedm;

typedef struct {
  // min, max, aavg, gavg
  uint64_t min;
  uint64_t max;
  uint64_t aavg;
} stats;

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
// TODO: take in two cpus  and shared mem

typedef struct {
  uint64_t player1;
  uint64_t player2;
  volatile uint64_t* first;
  volatile uint64_t* second;
} passes;

// NOTE: FIX ALL THE UNNECESSARY IO
void* ping2(void* _g)
{
  passes* g = _g;
  long myid = (long)(g->player1);

  uint64_t* rec_times = malloc(sizeof(uint64_t) * ntrials);

  cpu_set_t set;
  CPU_ZERO(&set);
  // printf("ping:\t%lu\n", d->cpu);
  CPU_SET(myid, &set);
  if (sched_setaffinity(0, sizeof(set), &set) < 0) {
    perror("Can't setaffinity");
    exit(-1);
  }
#if VERBOSE
  fprintf(stderr, DBG "ping: Set Affinity\n");
#endif
  uint64_t start;
  uint64_t stop;
  // should start the clock and write to data in memory

  for (uint64_t trial = 0; trial < ntrials; trial++) {

#if VERBOSE
    fprintf(stderr, DBG "ping: trial %lu\n", trial);
#endif
    rdtscll(start);

    *g->first = 1;
    //*g->first = 1;            // serve ball
    while (*g->second == 0) { // wait for return
      // sit and wait
    }
    rdtscll(stop);
    // printf("%lu,%lu,%lu,%i\n", g->player1, g->player2, trial, time);
    *g->first = 0; // Reset
#if VERBOSE
    fprintf(stderr, DBG "ping: finished\n");
#endif
    rec_times[trial] = (uint64_t)stop - start;
    pthread_barrier_wait(&barrier);
  }

  pthread_exit(rec_times);
}
void* pong2(void* _g)
{
  passes* g = _g;
  long myid = (long)(g->player2);
  cpu_set_t set;
  CPU_ZERO(&set);
  CPU_SET(myid, &set);
  if (sched_setaffinity(0, sizeof(set), &set) < 0) {
    perror("Can't setaffinity");
    exit(-1);
  }
#if VERBOSE
  fprintf(stderr, DBG "pong: Set Affinity\n");
#endif
  for (uint64_t trial = 0; trial < ntrials; trial++) {
    // should observe the change in memory,
    while (*g->first == 0) {
      // sit and wait
    }
    *g->second = 1;
    //*g->second = 1;

#if VERBOSE
    fprintf(stderr, "[INFO] Exiting thread %lu\n", g->player2);
#endif

    while (*g->first != 0) { }
    *g->second = 0; // Reset

#if VERBOSE
    fprintf(stderr, DBG "pong: finished\n");
#endif
    pthread_barrier_wait(&barrier);
  }

  pthread_exit(NULL);
}

void pingpong(uint64_t thread1, uint64_t thread2, FILE* fd)
{

  uint64_t beginning = thread1;
  uint64_t ending = thread2;

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

  // passes game = {
  //   .player1 = thread1,
  //   .player2 = thread2,
  //   .first = (uint64_t*)serve,
  //   .second = (uint64_t*)volley,
  // };

  pthread_t* tid;
  tid = (pthread_t*)malloc(sizeof(pthread_t) * 2); // magic number justified,
  // NOTE: Beginning of first loop (through all threads)
  long start_condition;

  uint64_t cthread_1;
  uint64_t cthread_2;

  passes game = {
    .player1 = cthread_1,
    .player2 = cthread_2,
    .first = (uint64_t*)serve,
    .second = (uint64_t*)volley,
  };
  for (cthread_2 = beginning; cthread_2 <= ending; cthread_2++) {

    for (cthread_1 = beginning; cthread_1 <= ending; cthread_1++) {
      if (cthread_1 == cthread_2)
        continue;
      game.player1 = cthread_1;
      game.player2 = cthread_2;
#if VERBOSE
      fprintf(stderr, "starting thread1\n");
#endif
      start_condition = pthread_create(&tid[0],
          NULL,
          pong2,
          (void*)&game);
      if (start_condition != 0) {
        printf("[INFO] PONG Did not start correct\n");
      }

      // player 2
      start_condition = pthread_create(&tid[1],
          NULL,
          ping2,
          (void*)&game);

      if (start_condition != 0) {
        printf("[INFO] PING Did not start correct\n");
      }
      void* result_ptr;

      pthread_join(tid[0], NULL);
      pthread_join(tid[1], &result_ptr);

      uint64_t* results = (uint64_t*)result_ptr;
      for (uint64_t j = 0; j < ntrials; j++) {
        fprintf(fd, "%lu,%lu,%lu,%lu\n", cthread_1, cthread_2, j, results[j]);
      }
      free(results);
    }
    // pthread_barrier_destroy(&barrier);
  }

  //*game.first = 0;
  //*game.second = 0;
  munmap(serve, 0x1000);
  munmap(volley, 0x1000);
  return;
}

void pair(uint64_t cpu1, uint64_t cpu2)
{

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

  passes game = {
    .player1 = cpu1,
    .player2 = cpu2,
    .first = (uint64_t*)serve,
    .second = (uint64_t*)volley,
  };

  tid = (pthread_t*)malloc(sizeof(pthread_t) * 2); // magic number justified,
                                                   // only ever two threads spinning
  // TODO: MAKE THIS THE TOURNAMENT

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

  if (start_condition != 0) {
    printf("[INFO] PONG started incorrect\n");
  }

  // player 2
  start_condition = pthread_create(&tid[1],
      NULL,
      ping2,
      (void*)&game);

  if (start_condition != 0) {
    printf("[INFO] PING started incorrect\n");
  }
  pthread_join(tid[0], NULL);
  pthread_join(tid[1], NULL);
  //*game.first = 0;
  //*game.second = 0;
  munmap(serve, 0x1000);
  munmap(volley, 0x1000);
  return;
}

int main(int argc, char* argv[])
{
  // long t1, t2;

  if (argc != 4) {
    // TODO: bake modes into this (thread pairs vs thread sweeps)
    printf("usage: pingpong thread_1 thread_2 Mode\n");
    exit(-1);
  }
  long t1 = (uint64_t)atol(argv[1]);   // thread 1
  long t2 = (uint64_t)atol(argv[2]);   // thread 2
  long mode = (uint64_t)atol(argv[3]); // mode
  // AVOID_HT = atoi(argv[3]); // avoid hyperthreading?

  FILE* f = fopen(FNAME, "w");
  // mk barrier
  if (pthread_barrier_init(&barrier, NULL, NUM_THREADS)) {
    perror("Could not create a barrier");
    return EXIT_FAILURE;
  }

  // pthread_t tid[t2];
  //  malloc the data array
#if VERBOSE
  printf("Start Tests\n");
#endif
  fprintf(f, "thread_1,thread_2,iter,time\n");
  switch (mode) {
  case 0: {
#if VERBOSE
    printf("pair mode\n");
#endif

    fprintf(stderr, DBG "starting pair\n");
    pair(t1, t2);
    break;
  }
  case 1: {
#if VERBOSE
    fprintf(stderr, DBG "starting pingpong\n");
#endif
    // FIXME: HERE
    fprintf(stderr, DBG "starting pingpong\n");
    pingpong(t1, t2, f);
    break;
  }
  default: {
    fprintf(stderr, "usage: pingpong thread_1 thread_2 Avoid_HT Mode\n");
    fprintf(stderr, "\t\t\t\t\t^^Mode not Mapped\n");
  }
  }
}
