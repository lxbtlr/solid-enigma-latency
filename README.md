# latency testing tools

## Ping Pong
Needed a ping pong tester, so I made one


### Dcache write latency
```bash
// This will write to dcache_out.file
$ ./dcache thread1 thread2 mode 
```


### Icache write latency
```bash
// This will write to icache_out.file
$ ./icache thread1 thread2 mode
```
For more specific information to the gadget used for the self modifying code, check `garbage.S`

### Measurement
Each latency test gives you the total latency of:
1. The time of thread 1 to write, and time taken for that write to be observed by thread 2.
2. The time of thread 2 to write, and time taken for that write to be observed by thread 1

This output will be given in clk cycles, as captured from the read time stamp counter (thank you peter).

All output is printed to stdout, info is output to stderr. Direct stdout to a file for processing.


### graphs.py
WIP: currently able to take an output file and create a heatmap from it:
```bash
//                  graph       title          input_file
 $ python3 graphs.py -g 1 -t "framework (amd)" test.out
```





## TODO: 
- look at using sched_setscheduler to increase priority of the tester to reduce noise


