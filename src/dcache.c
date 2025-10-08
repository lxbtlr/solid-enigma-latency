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
 * TODO:
 * - select correct latency test based on the architecture code is compiled for
 * -
 */

#define VERBOSE 0
#define PAGE_SIZE 0x1000
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

#define test_t uint8_t
#define uchar_t uint8_t
// Timer mechanism using rdtsc (?)

uint64_t alaska_timestamp()
{
  struct timespec spec;
  clock_gettime(1, &spec);
  return spec.tv_sec * (1000 * 1000 * 1000) + spec.tv_nsec;
}

#ifdef __x86_64__

#define FORCE_SERIAL                            \
  __asm__ __volatile__("lfence; rdtscp; lfence" \
      :                                         \
      :                                         \
      : "rax", "rdx", "rcx", "memory")

#define rdtscll(val)                          \
  do {                                        \
    uint64_t tsc;                             \
    uint32_t a, d;                            \
    asm volatile("rdtsc" : "=a"(a), "=d"(d)); \
    *(uint32_t*)&(tsc) = a;                   \
    *(uint32_t*)(((uchar_t*)&tsc) + 4) = d;   \
    val = tsc;                                \
  } while (0)
#else

#define AMORTIZED_RUNS 100
#define rdtscll(val) val = alaska_timestamp()
#endif

#define MIN(x, y) \
  (((uint64_t)x) < ((uint64_t)y) ? ((uint64_t)x) : ((uint64_t)y))
#define MAX(x, y) \
  (((uint64_t)x) > ((uint64_t)y) ? ((uint64_t)x) : ((uint64_t)y))

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
  memset(data->write_addr, 0, PAGE_SIZE);
  memset(data->read_addr, 0, PAGE_SIZE);
}

void mk_sharedms(sharedm* t1, sharedm* t2, const uint64_t thread1,
    const uint64_t thread2)
{
  void* serve = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE,
      MAP_SHARED | MAP_ANONYMOUS, 0, 0);

  memset(serve, 0, PAGE_SIZE);

  void* volley = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE,
      MAP_SHARED | MAP_ANONYMOUS, 0, 0);
  memset(volley, 0, PAGE_SIZE);

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
  uint64_t* first;
  uint64_t* second;
  FILE* F;
} __attribute__((packed)) __attribute__((aligned(PAGE_SIZE))) passes;

// NOTE: FIX ALL THE UNNECESSARY IO

#ifndef __x86_64__
void* arm_ping(void* _g)
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

  uint64_t start;
  uint64_t stop;
  // should start the clock and write to data in memory
  // uint64_t runs = 0;

  uint64_t state;
  for (uint64_t trial = 0; trial < NUM_TRIALS; trial++) {
    *g->first = 1;

    asm volatile("dmb ish;"
                 "dsb ish;"
                 "isb sy;" ::
                     :);
    rdtscll(start);
#ifdef AMORTIZED_RUNS
    for (uint64_t y = 0; y < AMORTIZED_RUNS; y++) {
#else
    for (uint64_t y = 0; y < 100; y++) {
#endif
      // update state
      state = y % 2;
      // NOTE: this is the new control flow based gadget for dcache

      *g->first = state;

      while (*g->second == (state == 0 ? 1 : 0)) { // wait for return
        // sit and wait
      }
    }
    rdtscll(stop);
    rec_times[trial] = (uint64_t)stop - start;
    pthread_barrier_wait(&barrier);
  }

  pthread_exit(rec_times);
}

void* arm_pong(void* _g)
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

  uint64_t state;
  // NOTE: m1(serve), m2(volley) should be 0, 1; respectively
  for (uint64_t trial = 0; trial < NUM_TRIALS; trial++) {
    *g->second = 1;

#ifdef AMORTIZED_RUNS
    for (uint64_t x = 0; x < AMORTIZED_RUNS; x++) {
#else
    for (uint64_t x = 0; x < 100; x++) {
#endif
      // update state
      state = x % 2; // 0 or 1
      // should observe the change in memory,
      while (*g->first == state) {
        // sit and wait
      }
      *g->second = (state == 0 ? 1 : 0); // not state
    }
    pthread_barrier_wait(&barrier);
  }

  pthread_exit(NULL);
}
#endif
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

    // NOTE: this is the new control flow based gadget for dcache
    rdtscll(start);

    *g->first = 1;

    while (*g->second == 0) { // wait for return
      // sit and wait
    }
    rdtscll(stop);
    *g->first = 0; // Reset
    rec_times[trial] = (uint64_t)stop - start;
#ifdef __x86_64__
    FORCE_SERIAL;
#endif
#if VERBOSE
    fprintf(stderr, DBG "ping: finished\n");
#endif
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

#if VERBOSE
    fprintf(stderr, "[INFO] Exiting thread %lu\n", g->player2);
#endif

    while (*g->first != 0) {
    }
    *g->second = 0; // Reset

#if VERBOSE
    fprintf(stderr, DBG "pong: finished\n");
#endif
#ifdef __x86_64__
    FORCE_SERIAL;
#endif
    pthread_barrier_wait(&barrier);
  }

  pthread_exit(NULL);
}

void pingpong(uint64_t thread1, uint64_t thread2, FILE* fd)
{

  uint64_t beginning = thread1;
  uint64_t ending = thread2;

  void* serve = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE,
      MAP_SHARED | MAP_ANONYMOUS, 0, 0);

  memset(serve, 0, PAGE_SIZE);

  void* volley = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE,
      MAP_SHARED | MAP_ANONYMOUS, 0, 0);
  memset(volley, 0, PAGE_SIZE);

  pthread_t* tid;
  tid = (pthread_t*)malloc(sizeof(pthread_t) * 2); // magic number justified,

  long start_condition;

  uint64_t cthread_1 = beginning;
  uint64_t cthread_2 = beginning;

  passes game = {
    .player1 = cthread_1,
    .player2 = cthread_2,
    .first = (uint64_t*)serve,
    .second = (uint64_t*)volley,
    .F = fd,
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
#ifdef __x86_64__
      start_condition = pthread_create(&tid[0], NULL, pong2, (void*)&game);
      if (start_condition != 0) {
        fprintf(stderr, DBG "PONG Did not start correct\n");
      }

      // player 2
      start_condition = pthread_create(&tid[1], NULL, ping2, (void*)&game);

      if (start_condition != 0) {
        fprintf(stderr, DBG "PING Did not start correct\n");
      }
#else

      start_condition = pthread_create(&tid[0], NULL, arm_pong, (void*)&game);
      if (start_condition != 0) {
        fprintf(stderr, DBG "PONG Did not start correct\n");
      }

      // player 2
      start_condition = pthread_create(&tid[1], NULL, arm_ping, (void*)&game);

      if (start_condition != 0) {
        fprintf(stderr, DBG "PING Did not start correct\n");
      }

#endif
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

  munmap(serve, PAGE_SIZE);
  munmap(volley, PAGE_SIZE);
  return;
}

void pair(uint64_t cpu1, uint64_t cpu2, FILE* f)
{

  pthread_t* tid;

  void* serve = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE,
      MAP_SHARED | MAP_ANONYMOUS, 0, 0);

  memset(serve, 0, PAGE_SIZE);

  void* volley = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE,
      MAP_SHARED | MAP_ANONYMOUS, 0, 0);
  memset(volley, 0, PAGE_SIZE);

  passes game = {
    .player1 = cpu1,
    .player2 = cpu2,
    .first = (uint64_t*)serve,
    .second = (uint64_t*)volley,
    .F = f,
  };

  tid = (pthread_t*)malloc(sizeof(pthread_t) * NUM_THREADS); // magic number justified,
                                                             // only ever two threads spinning
  // Set up the threads
  long start_condition;
#if VERBOSE
  printf("Start threads\n");
#endif
  // player 1
  start_condition = pthread_create(&tid[0], NULL, pong2, (void*)&game);

  if (start_condition != 0) {
    printf("[INFO] PONG started incorrect\n");
  }

  // player 2
  start_condition = pthread_create(&tid[1], NULL, ping2, (void*)&game);

  if (start_condition != 0) {
    printf("[INFO] PING started incorrect\n");
  }
  void* result_ptr;

  pthread_join(tid[0], NULL);
  pthread_join(tid[1], &result_ptr);

  uint64_t* results = (uint64_t*)result_ptr;
  for (uint64_t j = 0; j < ntrials; j++) {
    fprintf(f, "%lu,%lu,%lu,%lu\n", cpu1, cpu2, j, results[j]);
  }
  free(results);
  munmap(serve, PAGE_SIZE);
  munmap(volley, PAGE_SIZE);
  return;
}

#define WAIT(P, V)      \
  while (*(P) != (V)) { \
  }

typedef volatile long slot_t;

void amort_t1(slot_t* A, slot_t* B, long C)
{
  do {
    WAIT(A, C);
    C--;
    *B = C;
  } while (C > 0);
}

void amort_t2(slot_t* A, slot_t* B, long C)
{
  do {
    *A = C;
    C--;
    WAIT(B, C);
  } while (C > 0);
}

struct Amort_Args {
  long* A;
  long* B;
  long C;
  uint64_t tid_1;
  uint64_t tid_2;
  FILE* F;
};

#define SET_AFF(ID)                                    \
  do {                                                 \
    cpu_set_t set;                                     \
    CPU_ZERO(&set);                                    \
    CPU_SET(ID, &set);                                 \
    if (sched_setaffinity(0, sizeof(set), &set) < 0) { \
      perror("Can't setaffinity");                     \
      exit(-1);                                        \
    }                                                  \
                                                       \
  } while (0)

static void* amort_t1_wrap(void* p)
{
  struct Amort_Args* a = (struct Amort_Args*)p;
  long count = a->C;

  // cpu_set_t set;
  // CPU_ZERO(&set);
  // CPU_SET(a->tid_1, &set);

  SET_AFF(a->tid_1);

  // uint64_t start = rdtscp();
  uint64_t start, stop = 0;
  rdtscll(start);
  amort_t1(a->A, a->B, a->C);
  rdtscll(stop);

  uint64_t total = stop - start;
  fprintf(a->F, "%li, %li, %i, %f\n", a->tid_1, a->tid_2, NUM_TRIALS,
      total / (float)count);

  return NULL;
}

static void* amort_t2_wrap(void* p)
{
  struct Amort_Args* a = (struct Amort_Args*)p;
  SET_AFF(a->tid_2);
  amort_t2(a->A, a->B, a->C);
  return NULL;
}

#define AMORTIZED_RUNS 100000
int amortized_pair(int t1, int t2, FILE* f)
{
  // force separate locations in mem
  long A[500];
  long B[500];
  // set values
  A[0] = -1;
  B[0] = -1;

  for (int i = 0; i < NUM_TRIALS; i++) {
    struct Amort_Args args = {
      .A = A, .B = B, .C = AMORTIZED_RUNS, .tid_1 = t1, .tid_2 = t2, .F = f
    };

    pthread_t th1, th2;
    if (pthread_create(&th1, NULL, amort_t1_wrap, &args) != 0) {
      perror("pthread_create t1");
      return 1;
    }
    if (pthread_create(&th2, NULL, amort_t2_wrap, &args) != 0) {
      perror("pthread_create t2");
      return 1;
    }

    pthread_join(th1, NULL);
    pthread_join(th2, NULL);
  }

  return 0;
}

int amortized_pingpong(uint64_t beginning, uint64_t end, FILE* f)
{

  // force separate locations in mem
  long A[500];
  long B[500];
  // set values
  A[0] = -1;
  B[0] = -1;
  for (uint64_t thread1 = beginning; thread1 < end; thread1++) {
    for (uint64_t thread2 = beginning; thread2 < end; thread2++) {
      if (thread1 == thread2) {
        continue;
      }

      for (int i = 0; i < NUM_TRIALS; i++) {
        struct Amort_Args args = { .A = A,
          .B = B,
          .C = AMORTIZED_RUNS,
          .tid_1 = thread1,
          .tid_2 = thread2,
          .F = f };

        pthread_t th1, th2;
        if (pthread_create(&th1, NULL, amort_t1_wrap, &args) != 0) {
          perror("pthread_create t1");
          return 1;
        }
        if (pthread_create(&th2, NULL, amort_t2_wrap, &args) != 0) {
          perror("pthread_create t2");
          return 1;
        }

        pthread_join(th1, NULL);
        pthread_join(th2, NULL);
      }
    }
  }

  return 0;
}

int main(int argc, char* argv[])
{

  if (argc != 4) {
    // TODO: bake modes into this (thread pairs vs thread sweeps)
    printf("usage: dcache_late thread_1 thread_2 Mode\n");
    exit(-1);
  }
  long t1 = (uint64_t)atol(argv[1]);   // thread 1
  long t2 = (uint64_t)atol(argv[2]);   // thread 2
  long mode = (uint64_t)atol(argv[3]); // mode

  FILE* f = fopen(FNAME, "w");
  // mk barrier
  if (pthread_barrier_init(&barrier, NULL, NUM_THREADS)) {
    perror("Could not create a barrier");
    return EXIT_FAILURE;
  }

#if VERBOSE
  printf("Start Tests\n");
#endif
  fprintf(f, "thread_1,thread_2,iter,time\n");
  switch (mode) {
  case 0: {
#if VERBOSE
    fprintf(stderr, DBG "starting pair \n");
#endif

    fprintf(stderr, DBG "starting pair\n");
    pair(t1, t2, f);
    break;
  }
  case 1: {
#if VERBOSE
    fprintf(stderr, DBG "starting pingpong\n");
#endif
    pingpong(t1, t2, f);
    break;
  }
  case 2: {
#if VERBOSE
    fprintf(stderr, DBG "AMORTIZED: starting pair \n");
#endif
    amortized_pair(t1, t2, f);
    break;
  }
  case 3: {
#if VERBOSE
    fprintf(stderr, DBG "AMORTIZED: starting pingpong \n");
#endif
    amortized_pingpong(t1, t2, f);
    break;
  }
  default: {
    fprintf(stderr, "usage: pingpong thread_1 thread_2 Mode\n");
    fprintf(stderr, "\t\t\t\t\t^^Mode not Mapped\n");
  }
  }
}
