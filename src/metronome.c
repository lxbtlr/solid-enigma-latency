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
  uint64_t runs = 0;

  uint64_t state;
  for (uint64_t trial = 0; trial < NUM_TRIALS; trial++) {
    *g->first = 1;
    asm volatile("dmb ish;"
                 "dsb ish;"
                 "isb sy;" :::);
    rdtscll(start);
    for (uint64_t y = 0; y < AMORTIZED_RUNS; y++) {
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
    for (uint64_t x = 0; x < AMORTIZED_RUNS; x++) {
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
