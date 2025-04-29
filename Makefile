# Makefile - Boilerplate for a C project with Assembly

# Compiler and flags
CC := gcc
AS := gcc              # Use gcc for preprocessing .S files
CFLAGS := -Wall -Wextra -O0 -g

# Project name (name of the final executable)
TARGET := late_icache

# Sources
C_SRCS := icache.c
S_SRCS := garbage.S
SRCS := $(C_SRCS) $(S_SRCS)

# Object files
OBJS := $(SRCS:.c=.o)
OBJS := $(OBJS:.S=.o)

# Default target
all: $(TARGET)

# Link all object files to create the final executable
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Compile C source files
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Compile assembly (.S) files with preprocessor support
%.o: %.S
	$(AS) $(CFLAGS) -c -o $@ $<

# Clean build artifacts
clean:
	rm -f $(OBJS) $(TARGET)

# Phony targets
.PHONY: all clean
