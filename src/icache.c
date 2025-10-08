#define _GNU_SOURCE
#include <pthread.h> // pthread api
#include <sched.h>   // for processor affinity
#include <setjmp.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <ucontext.h>
#include <unistd.h> // unix standard apis
// #include <math.h>
//
// make our barrier
pthread_barrier_t barrier;

#define VERBOSE 0
#define SERVE_TALK 0
#define VOLLEY_TALK 0
#define SIGHANDLER 1
#define uchar_t uint8_t

#define PAGE_SIZE 0x4000

#define DBG "[INFO] "
#define COLOR_BOLD_YELLOW "\e[1;33m"
#define COLOR_BOLD_RED "\e[1;31m"
#define COLOR_RESET "\e[0m"
#define ALERT(str) COLOR_BOLD_RED str COLOR_RESET

#define NUM_THREADS 2
#define NUM_TRIALS 10000
uint64_t ntrials = NUM_TRIALS;

// #define AMORTIZED_RUNS 100
#define PATCH_SIZE 8

#define FNAME "icache_out.file"

extern uint8_t gadget_start[];
extern uint8_t gadget_entry[];
extern uint8_t gadget_end[];

extern uint8_t gadget_patch1[];
extern uint8_t gadget_patch2[];

size_t size_gadget() { return (uintptr_t)gadget_end - (uintptr_t)gadget_start; }
size_t entry_offset()
{
  return (uintptr_t)gadget_entry - (uintptr_t)gadget_start;
}
typedef struct {
  void (*code)(void);
  uint64_t* t1;
  uint64_t* t2;
  char patch1[PATCH_SIZE];
  char patch2[PATCH_SIZE];
  FILE* F;
} __attribute__((packed)) __attribute__((aligned(PAGE_SIZE))) gadget_t;

gadget_t josh_gad;

#define OFFSET(val) (uintptr_t)val - (uintptr_t)gadget_start
// FIX: There ~MAY~ still be a race condition
// look at gdb thread blocking detach on fork and follow ~fork child
void gadget_rst(gadget_t* gadget, uint64_t* t1, uint64_t* t2, FILE* f)
{
  // gadget must already be alloc'd by here
  uint8_t* code = (uint8_t*)gadget->code;
  memcpy(code, gadget_start, size_gadget());
  gadget->t1 = t1;
  gadget->t2 = t2;
  gadget->F = f;
  memcpy(gadget->patch1, code + OFFSET(gadget_patch1), PATCH_SIZE);
  memcpy(gadget->patch2, code + OFFSET(gadget_patch2), PATCH_SIZE);
#if VERBOSE
  fprintf(stderr,
      DBG "Shared memory created at:" COLOR_BOLD_YELLOW "%p\n" COLOR_RESET,
      code);
  fprintf(stderr, DBG "gadget_start:\t0x%016x\n", gadget_start);
  fprintf(stderr, DBG "\t\tdiff:\t0x%016x\n", entry_offset());
  fprintf(stderr, DBG "gadget_entry:\t0x%016x\n", gadget_entry);
  fprintf(stderr, DBG "\t\tdiff:\t0x%016x\n", gadget_end - gadget_entry);
  fprintf(stderr, DBG "gadget_end:\t0x%016x\n", gadget_end);
#endif
}

void gadget_init(gadget_t* gadget, uint64_t* t1, uint64_t* t2, FILE* f)
{

  // memcpy(garbage, gadget_start, size_gadget());
  gadget->code = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_EXEC | PROT_WRITE,
      MAP_SHARED | MAP_ANONYMOUS, // check this later
      0, 0);
  gadget_rst(gadget, t1, t2, f);
}

void gadget_dest(gadget_t* gadget)
{
  if (gadget && gadget != MAP_FAILED) {
    munmap(gadget, PAGE_SIZE);
  }
}

uint64_t alaska_timestamp()
{
  struct timespec spec;
  clock_gettime(1, &spec);
  return spec.tv_sec * (1000 * 1000 * 1000) + spec.tv_nsec;
}

#ifdef __x86_64__

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

#define rdtscll(val) val = alaska_timestamp()
#endif

#if !SIGHANDLER
static sigjmp_buf jump_buf;
void sigill_handler(int sig, siginfo_t* info, void* ucontext)
{
  fprintf(stderr, COLOR_BOLD_RED "Caught SIGILL at address %p\n" COLOR_RESET,
      info->si_addr);
  uint8_t* code = (uint8_t*)info->si_addr;
  for (int i = 0; i < 8; i++) {
    fprintf(stderr, "%02x ", code[i]);
  }
  fprintf(stderr, "\n");

// Skip the illegal instruction by advancing the instruction pointer
#if defined(__x86_64__)
  ucontext_t* ctx = (ucontext_t*)ucontext;
  // ctx->uc_mcontext.gregs[REG_RIP]; // may need to adjust size of instruction
#elif defined(__aarch64__)
  ucontext_t* ctx = (ucontext_t*)ucontext;
  ctx->uc_mcontext.pc += 4; // ARM instructions are 4 bytes
#else
  // Use longjmp if you can't safely skip the instruction
  siglongjmp(jump_buf, 1);
#endif
}
#endif

void hex_dump(const void* addr, size_t length, size_t target)
{
  const uint8_t* data = (const uint8_t*)addr;
  size_t i, j;

  for (i = 0; i < length; i += 32) {
    printf("%08zx  ", i); // Print offset

    // Print hex values
    for (j = 0; j < 32; j++) {
      if (i + j < length) {
        if (i + j == target)
          printf("\e[31m");
        printf("%02x ", data[i + j]);
        if (i + j == target)
          printf("\e[0m");
      } else {
        printf("   ");
      }
    }
    printf("|\n");
  }
}

void* serve(void* arg)
{
  /*
   * Based on the thread ID begin running the shared c array code snippet at a
   *  different index (entry point)
   * Thread 0 will be our stopclock
   *
   */
  gadget_t* gadget = arg;
  long myid = (long)*(gadget->t1);
  // printf("%lu\n", myid);
  uint64_t start;
  uint64_t stop;
  uint64_t offset = entry_offset();

  uint64_t* rec_times = malloc(sizeof(uint64_t) * ntrials);

  // NOTE: set affinity to given thread
  cpu_set_t set;
  CPU_ZERO(&set);
  CPU_SET(myid, &set);
  if (sched_setaffinity(0, sizeof(set), &set) < 0) {
    fprintf(stderr, "Can't setaffinity\tServe");
    exit(-1);
  }

  // printf("%lu\n", offset);
  // hex_dump(josh_gad.code, 0x100, offset);
  //(void (*)(void))
#if VERBOSE
  fprintf(stderr, DBG "gadget_start+off:\t0x%016x\n", gadget_start + offset);
  fprintf(stderr, DBG "gadget_code+off:\t0x%016x\n", gadget->code + offset);
  fprintf(stderr, DBG ALERT("MYID") ":%lx\n", myid);
#endif
  uint64_t runs = 0;
  for (uint64_t i = 0; i < ntrials; i++) {

#if VERBOSE
    printf("serve:" COLOR_BOLD_RED "%i\n" COLOR_RESET, i);
#endif

#ifdef AMORTIZED_RUNS
    rdtscll(start);
    for (runs = 0; runs < AMORTIZED_RUNS; runs++) {

#if VERBOSE
      printf("runs: %lu\n", runs);
#endif
      (gadget->code + offset)();
    }
    rdtscll(stop);
    rec_times[i] = (uint64_t)(stop - start) / AMORTIZED_RUNS;
    printf("%lu\n", rec_times[i]);
#else

    rdtscll(start);
    (gadget->code + offset)();
    rdtscll(stop);
    rec_times[i] = (uint64_t)stop - start;
#endif

#if SERVE_TALK
    fprintf(stderr,
        DBG COLOR_BOLD_YELLOW "serve:" COLOR_RESET ALERT("post test\n"));
    hex_dump(gadget->code, 0x100, OFFSET(gadget_patch1));
#endif
    // NOTE: change this back

    //*(volatile uint64_t*)(gadget->code + OFFSET(gadget_patch1)) =
    //*(uint64_t*)gadget->patch1;
    // memcpy(gadget->code + OFFSET(gadget_patch1), gadget->patch1, PATCH_SIZE);
    pthread_barrier_wait(&barrier);
    *(volatile uint64_t*)(gadget->code + OFFSET(gadget_patch1)) = *(uint64_t*)gadget->patch1;
    fprintf(gadget->F, "%lu,%lu,%lu,%lu\n", *gadget->t1, *gadget->t2, i,
        stop - start);
    memcpy(gadget->code + OFFSET(gadget_patch1), gadget->patch1, PATCH_SIZE);
#if SERVE_TALK
    fprintf(stderr,
        DBG COLOR_BOLD_YELLOW "serve:" COLOR_RESET ALERT("fixed\n"));
    hex_dump(gadget->code, 0x100, OFFSET(gadget_patch1));
#endif
    // fprintf(gadget->F, "%lu,%lu,%lu,%lu\n", *gadget->t1, *gadget->t2, i,
    //        stop - start);
  }

  pthread_exit(rec_times);
}

void* volley(void* arg)
{
  gadget_t* gadget = arg;
  long myid = (long)*(gadget->t2);
  // printf("%lu\n", myid);

  cpu_set_t set;
  CPU_ZERO(&set);
  CPU_SET(myid, &set);
  if (sched_setaffinity(0, sizeof(set), &set) < 0) {
    fprintf(stderr, "Can't setaffinity\tVolley");
    exit(-1);
  }
  uint64_t volley_counter = 0;
  // add barrier here
  for (uint64_t i = 0; i < ntrials; i++, volley_counter++) {

#if VERBOSE
    printf("volley:" COLOR_BOLD_RED "%i\n" COLOR_RESET, i);
#endif
    uint64_t j;
// TODO: split this into a more clear one or the other
#ifdef AMORTIZED_RUNS
    for (uint64_t j = 0; j < AMORTIZED_RUNS; j++) {
#endif
#if VERBOSE
      printf("VRUNS: %lu\n", j);
#endif
      gadget->code();
#ifdef AMORTIZED_RUNS
      *(volatile uint64_t*)(gadget->code + OFFSET(gadget_patch2)) = *(uint64_t*)gadget->patch2;
    }
#endif
#if VOLLEY_TALK
    fprintf(stderr,
        DBG COLOR_BOLD_YELLOW "volley:" COLOR_RESET ALERT("post test\n"));
    hex_dump(gadget->code, 0x100, OFFSET(gadget_patch2));
#endif
#if VOLLEY_TALK
    fprintf(stderr,
        DBG COLOR_BOLD_YELLOW "volley:" COLOR_RESET ALERT("fixed\n"));
    hex_dump(gadget->code, 0x100, OFFSET(gadget_patch2));
#endif
    //   memcpy(gadget->code + OFFSET(gadget_patch2), gadget->patch2,
    //   PATCH_SIZE);
    //  printf("volley: trial  %lu\n", i);

    pthread_barrier_wait(&barrier);
    *(volatile uint64_t*)(gadget->code + OFFSET(gadget_patch2)) = *(uint64_t*)gadget->patch2;
  }

  pthread_exit(NULL);
}
void pingpong(uint64_t thread1, uint64_t thread2, FILE* fd)
{
  // output file

  // fprintf(fd, "thread_1,thread_2,iter,time\n");
  uint64_t beginning = thread1;
  uint64_t ending = thread2;

  pthread_t* tid;
  tid = (pthread_t*)malloc(sizeof(pthread_t) * 2); // magic number justified,
  // NOTE: Beginning of first loop (through all threads)
  uint64_t cthread_1, cthread_2;

  gadget_init(&josh_gad, &cthread_1, &cthread_2, fd);
  for (cthread_2 = beginning; cthread_2 <= ending; cthread_2++) {

    for (cthread_1 = beginning; cthread_1 <= ending; cthread_1++) {
      if (cthread_2 == cthread_1)
        continue;
      // FIXME: option 2
      // josh_gad.t1 = &cthread_1;
      // josh_gad.t2 = &cthread_2;
      gadget_rst(&josh_gad, &cthread_1, &cthread_2, fd);
      int t1 = pthread_create(&tid[0], NULL, volley, (void*)&josh_gad);

      if (t1 == 1)
        fprintf(stderr, "Thread1 did not start");

      int t2 = pthread_create(&tid[1], NULL, serve, (void*)&josh_gad);

      if (t2 == 1)
        fprintf(stderr, "Thread2 did not start");

      void* result_ptr;

      pthread_join(tid[0], NULL);
      pthread_join(tid[1], &result_ptr);

      uint64_t* results = (uint64_t*)result_ptr;
      for (uint64_t j = 0; j < ntrials; j++) {
        fprintf(fd, "%lu,%lu,%lu,%lu\n", cthread_1, cthread_2, j, results[j]);
      }
      free(results);
    }
  }
  gadget_dest(&josh_gad);
  pthread_barrier_destroy(&barrier);
  return;
}

void cpu2cpu(uint64_t thread1, uint64_t thread2, FILE* f)
{
  // TODO: use the array system in use for pingpong mode
  gadget_init(&josh_gad, &thread1, &thread2, f);

  pthread_t* tid;
  tid = (pthread_t*)malloc(sizeof(pthread_t) * NUM_THREADS); // magic number justified,

  int t1 = pthread_create(&tid[0], NULL, volley, (void*)&josh_gad);

  if (t1 == 1)
    fprintf(stderr, "Thread1 did not start");

  int t2 = pthread_create(&tid[1], NULL, serve, (void*)&josh_gad);

  if (t2 == 1)
    fprintf(stderr, "Thread2 did not start");

  pthread_join(tid[0], NULL);
  pthread_join(tid[1], NULL);

  // destroy barrier once done
  pthread_barrier_destroy(&barrier);
}

int main(int argc, char* argv[])
{
  if (argc != 4) {
    // TODO: bake modes into this (thread pairs vs thread sweeps)
    printf("usage: late_icache thread_1 thread_2 Mode\n");
    exit(-1);
  }
#if !SIGHANDLER
  struct sigaction sa;
  sa.sa_sigaction = sigill_handler;
  sigemptyset(&sa.sa_mask);
  sa.sa_flags = SA_SIGINFO;
  if (sigaction(SIGILL, &sa, NULL) == -1) {
    perror("sigaction");
    exit(EXIT_FAILURE);
  }
#endif
  uint64_t mode = (uint64_t)atol(argv[3]);     // op mode
  uint64_t thread_1 = (uint64_t)atol(argv[1]); // thread 1
  uint64_t thread_2 = (uint64_t)atol(argv[2]); // thread 2

  if (pthread_barrier_init(&barrier, NULL, NUM_THREADS)) {
    perror("Could not create a barrier");
    return EXIT_FAILURE;
  }

  FILE* f = fopen(FNAME, "w");
  fprintf(f, "thread_1,thread_2,iter,time\n");
  switch (mode) {
  case 0:
    cpu2cpu(thread_1, thread_2, f);
    break;
  case 1:

    pingpong(thread_1, thread_2, f);
    break;
  case 2:
  default:

    fprintf(stderr, "Mode not specified\n");
    return 0;
  }
  return 0;
}
