#!/bin/bash



NPROCS="$(nproc | awk '{print $1-1}')"

## runner

pushd src
echo -e "Running Icache Test:\nargs:\t 0 $NPROCS 1"
exec ./icache 0 $NPROCS 1
echo -e "Running Dcache Test:\nargs:\t 0 $NPROCS 1"
exec ./dcache "0 $NPROCS 1 && cp dcache_out.file a_dcache_out.file

echo -e "Running Dcache Test \(Amortized\):\nargs:\t 0 $NPROCS 1"
exec ./dcache 0 $NPROCS 3

popd


## METRICS
# LADDER_DATA="$(tail --lines=+2 src/icache_ladder_out.file)"
ICACHE_DATA="$(tail --lines=+2 src/icache_out.file)"
DCACHE_DATA="$(tail --lines=+2 src/dcache_out.file)"
A_DCACHE_DATA="$(tail --lines=+2 src/a_dcache_out.file)"

# LADDER_AVG="$(echo "$LADDER_DATA" | awk -F, '{print $NF}' | awk '{sum+=$1} END {print (sum/NR)/200}')"
ICACHE_AVG="$(echo "$ICACHE_DATA" | awk -F, '{print $NF}' | awk '{sum+=$1} END {print sum/NR}')"
DCACHE_AVG="$(echo "$DCACHE_DATA" | awk -F, '{print $NF}' | awk '{sum+=$1} END {print sum/NR}')"
A_DCACHE_AVG="$(echo "$A_DCACHE_DATA" | awk -F, '{print $NF}' | awk '{sum+=$1} END {print sum/NR}')"

# LADDER_MIN="$(echo "$LADDER_DATA" | awk -F, '{print $NF/200}' | sort -n | head -n1)"
ICACHE_MIN="$(echo "$ICACHE_DATA" | awk -F, '{print $NF}'   | sort -n | head -n1)"
DCACHE_MIN="$(echo "$DCACHE_DATA" | awk -F, '{print $NF}'   | sort -n | head -n1)"
A_DCACHE_MIN="$(echo "$A_DCACHE_DATA" | awk -F, '{print $NF}'   | sort -n | head -n1)"

echo -e "\tladder\ticache\tdcache"
echo -e "avg\t$LADDER_AVG\t$ICACHE_AVG\t$DCACHE_AVG"
echo -e "min\t$LADDER_MIN\t$ICACHE_MIN\t$DCACHE_MIN"

echo -e "\ticache\tdcache"
echo -e "avg\t$ICACHE_AVG\t$DCACHE_AVG"
echo -e "min\t$ICACHE_MIN\t$DCACHE_MIN"


