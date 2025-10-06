# Makefile - Boilerplate for a C project with Assembly

# Compiler and flags
CC := gcc
AS := gcc              # Use gcc for preprocessing .S files
CFLAGS := -Wall -Wextra -O0 -g -lpthread

# Add the gadgets directory to the search path for source files
VPATH = gadgets

# Project name (name of the final executable)
TARGETS := icache dcache ladder

# Sources
icache_C_SRCS := icache.c
icache_S_SRCS := garbage.S
icache_SRCS := $(icache_C_SRCS) $(icache_S_SRCS)
# Object files
icache_OBJS := $(patsubst %.c,%.o,$(patsubst %.S,%.o,$(icache_SRCS)))

# ladder Sources
ladder_icache_C_SRCS := icache_ladder.c
ladder_icache_S_SRCS := ladder.S
ladder_icache_SRCS := $(ladder_icache_C_SRCS) $(ladder_icache_S_SRCS)
# Object files
ladder_icache_OBJS := $(patsubst %.c,%.o,$(patsubst %.S,%.o,$(ladder_icache_SRCS)))

# NTI dups
NTI_icache_C_SRCS := icache.c
NTI_icache_S_SRCS := movnti.S
NTI_icache_SRCS := $(icache_C_SRCS) $(NTI_icache_S_SRCS)
NTI_icache_OBJS := $(patsubst %.c,%.o,$(patsubst %.S,%.o,$(NTI_icache_SRCS)))

# ARM sources
arm_icache_C_SRCS := icache.c
arm_icache_S_SRCS := arm64.S
arm_icache_SRCS := $(icache_C_SRCS) $(arm_icache_S_SRCS)
arm_icache_OBJS := $(patsubst %.c,%.o,$(patsubst %.S,%.o,$(arm_icache_SRCS)))

# dcache sources
dcache_SRCS := dcache.c
dcache_OBJS := $(dcache_SRCS:.c=.o)

all: $(TARGETS)

# Build rules for each executable
icache: $(icache_OBJS)
	$(CC) $(CFLAGS) -o $@ $^

ladder: $(ladder_icache_OBJS)
	$(CC) $(CFLAGS) -o $@ $^

dcache: $(dcache_OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Example for commented out targets
#nti_icache: $(NTI_icache_OBJS)
#       $(CC) $(CFLAGS) -o $@ $^

#arm_icache: $(arm_icache_OBJS)
#       $(CC) $(CFLAGS) -o $@ $^

# Compile C source files
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Compile assembly (.S) files with preprocessor support
%.o: %.S
	$(AS) $(CFLAGS) -c -o $@ $<

# Clean build artifacts
clean:
	rm -f $(icache_OBJS) $(ladder_icache_OBJS) $(dcache_OBJS) $(NTI_icache_OBJS) $(arm_icache_OBJS) $(TARGETS)

# Phony targets
.PHONY: all clean
