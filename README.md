# latency testing tools

## Ping Pong
Needed a ping pong tester, so I made one
```bash
$ ./pingpong thread1 thread2
```
Should give you the total latency of:
1. The time of thread 1 to write, and time taken for that write to be observed by thread 2.
2. The time of thread 2 to write, and time taken for that write to be observed by thread 1

This output will be given in clk cycles, as captured from the read time stamp counter (thank you peter).
