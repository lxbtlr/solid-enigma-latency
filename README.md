# latency testing tools

Needed a ping pong tester, so I made one

This system has been tested for x86_64, cont'd

## Build

```bash

$ cd src
$ make all

```

## Dcache write latency
```bash
// This will write to dcache_out.file
$ ./dcache thread1 thread2 mode 
```
### modes:
- 0 - cpu2cpu: test latency between two physical cpus using affinity
- 1 - pingpong: test latency between of every thread to every thread (in a range)
- 2 - [AMORTIZED] cpu2cpu: test latency between two physical cpus using affinity
- 3 - [AMORTIZED] pingpong: test latency between of every thread to every thread (in a range)

## Icache write latency
```bash
// This will write to icache_out.file
$ ./icache thread1 thread2 mode
```
For more specific information to the gadget used for the self modifying code, check `garbage.S`

### modes:
- 0 - cpu2cpu: test latency between two physical cpus using affinity
- 1 - pingpong: test latency between of every thread to every thread (in a range)

## Ladder (Amortized Icache) write latency
```bash
// This will write to icache_ladder_out.file
$ ./ladder thread1 thread2 mode
```

This script exists as an explicit mechanism to tests icache latency without cold-starts and other overheads: this microbenchmark should be comparable to that of `dcache` modes 2&3.

This script does require building the `ladder.S` file before running, this can be easily done using the `build_ladder.py` script found in this repo.
```bash
$ python build_ladder.py #_of_Rungs output_file
```

For more specific information to the gadget used for the self modifying code, check `ladder.S`

### modes:
- 0 - [AMORTIZED] cpu2cpu: test latency between two physical cpus using affinity
- 1 - [AMORTIZED] pingpong: test latency between of every thread to every thread (in a range)


## Measurement
Each latency test gives you the total latency of:
1. The time of thread 1 to write, and time taken for that write to be observed by thread 2.
2. The time of thread 2 to write, and time taken for that write to be observed by thread 1.

After this sequence of events a measurement is taken, however, amortized testing modes (marked [AMORTIZED]) perform multiple tests in a single measurement.


This output will be given in clk cycles, as captured from the read time stamp counter (rtdscp).

All output is printed to a `*_out.file` file, info is output to stderr. 
For additional insight / help debugging set the `VERBOSE` macro to 1 and rebuild.


## eval.sh
For quick insight into the results of some testing, use the eval.sh script to give you quick insights from the `*_out.file`'s.
```bash
// Run tests with icache, ladder, and dcache
...
$ ./eval.sh
```


## graphs.py
WIP: currently able to take an output file and create a heatmap from it:
```bash
//                  graph   input_file    title 
 $ python3 graphs.py -g 1  test.out "framework (amd)"
```





