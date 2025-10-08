#!/bin/bash



## runner







## METRICS
LADDER_DATA="$(tail --lines=+2 src/icache_ladder_out.file)"
ICACHE_DATA="$(tail --lines=+2 src/icache_out.file)"
DCACHE_DATA="$(tail --lines=+2 src/dcache_out.file)"

LADDER_AVG="$(echo "$LADDER_DATA" | awk -F, '{print $NF}' | awk '{sum+=$1} END {print (sum/NR)/200}')"
ICACHE_AVG="$(echo "$ICACHE_DATA" | awk -F, '{print $NF}' | awk '{sum+=$1} END {print sum/NR}')"
DCACHE_AVG="$(echo "$DCACHE_DATA" | awk -F, '{print $NF}' | awk '{sum+=$1} END {print sum/NR}')"

LADDER_MIN="$(echo "$LADDER_DATA" | awk -F, '{print $NF/200}' | sort -n | head -n1)"
ICACHE_MIN="$(echo "$ICACHE_DATA" | awk -F, '{print $NF}'   | sort -n | head -n1)"
DCACHE_MIN="$(echo "$DCACHE_DATA" | awk -F, '{print $NF}'   | sort -n | head -n1)"

echo -e "\tladder\ticache\tdcache"
echo -e "avg\t$LADDER_AVG\t$ICACHE_AVG\t$DCACHE_AVG"
echo -e "min\t$LADDER_MIN\t$ICACHE_MIN\t$DCACHE_MIN"


