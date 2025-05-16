# Makefile - Boilerplate for a C project with Assembly

# Compiler and flags
CC := gcc
AS := gcc              # Use gcc for preprocessing .S files
CFLAGS := -Wall -Wextra -O0 -g -lpthread

# Project name (name of the final executable)
#TARGETS := icache dcache arm_icache nti_icache
TARGETS := icache dcache #arm_icache #nti_icache

# Sources
icache_C_SRCS := icache.c
icache_S_SRCS := garbage.S
icache_SRCS := $(icache_C_SRCS) $(icache_S_SRCS)
# Object files
icache_OBJS := $(icache_SRCS:.c=.o)
icache_OBJS := $(icache_OBJS:.S=.o)

## NTI dups
#NTI_icache_C_SRCS := icache.c
#NTI_icache_S_SRCS := movnti.S
#NTI_icache_SRCS := $(icache_C_SRCS) $(NTI_icache_S_SRCS)
#NTI_icache_OBJS := $(NTI_icache_SRCS:.c=.o)
#NTI_icache_OBJS := $(NTI_icache_OBJS:.S=.o)

arm_icache_C_SRCS := icache.c
arm_icache_S_SRCS := arm64.S
arm_icache_SRCS := $(icache_C_SRCS) $(arm_icache_S_SRCS)

arm_icache_OBJS := $(arm_icache_SRCS:.c=.o)
arm_icache_OBJS := $(arm_icache_OBJS:.S=.o)


# Sources
dcache_SRCS := dcache.c

# Object files
dcache_OBJS := $(dcache_SRCS:.c=.o)

all: $(TARGETS)

# Build rules for each executable
icache: $(icache_OBJS)
	$(CC) $(CFLAGS) -o $@ $^

#nti_icache: $(NTI_icache_OBJS)
#	$(CC) $(CFLAGS) -o $@ $^

arm_icache: $(arm_icache_OBJS)
	$(CC) $(CFLAGS) -o $@ $^

dcache: $(dcache_OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Compile C source files
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Compile assembly (.S) files with preprocessor support
%.o: %.S
	$(AS) $(CFLAGS) -c -o $@ $<

# Clean build artifacts
clean:
	rm -f $(NTI_icache_OBJS) $(icache_OBJS) $(dcache_OBJS) $(TARGETS)

# Phony targets
.PHONY: all clean
