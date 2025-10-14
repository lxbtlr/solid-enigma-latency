#!/usr/bin/env python3
"""
Assembly Ladder Microbenchmark Generator

This script generates assembly code for a "ladder" pingpong latency test where
two threads alternate execution through a series of steps. Each step involves
one thread waiting (jumping in place) until the other thread writes to unblock it.

Usage:
    python generate_asm_ladder.py [num_steps] [output_file]

Arguments:
    num_steps: Number of pingpong steps in the ladder (default: 3)
    output_file: Output .S file path (default: ladder_microbenchmark.S)
"""

import sys
import argparse


def generate_asm_ladder(num_steps=3):
    """
    Generate an assembly ladder microbenchmark with configurable number of steps.

    The generated code creates two "rails" where threads alternate execution:
    - Rail 1: First thread starts here, waits at each step until rail 2 unblocks it
    - Rail 2: Second thread enters via gadget_entry, alternates with rail 1

    Args:
        num_steps: Number of pingpong steps in the ladder

    Returns:
        str: Complete assembly code for the ladder microbenchmark
    """

    # Validate input
    if num_steps < 1:
        raise ValueError("num_steps must be at least 1")

    # Start with the header and rail_1 declaration
    asm_code = """.global gadget_start
gadget_start:
    .align 64
    .global rail_1
    .global rail_2

// NOTE: ICACHE LADDER
// This microbenchmark implements a pingpong latency test between two threads
// Thread 1 starts at rail_1, Thread 2 enters at gadget_entry
//RAIL 1
rail_1:
"""

    # Generate rail_1 steps
    for i in range(num_steps):
        asm_code += f"""rail_1_{i}:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_{i}(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
"""

    # Add rail_1 bottom
    asm_code += """rail_1_bottom:
    ret

.global gadget_entry
//.align 64
gadget_entry:
    MOVW $0x00eb,rail_1_0(%rip)     # Stop rail_1 from jumping in place (start the pingpong)

//RAIL 2  
rail_2:
"""

    # Generate rail_2 steps
    for i in range(num_steps):
        # Determine the next rail_1 target
        if i < num_steps - 1:
            next_target = f"rail_1_{i + 1}"
        else:
            next_target = "rail_1_bottom"

        asm_code += f"""rail_2_{i}:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
"""
        if next_target != "rail_1_bottom":
            asm_code += f"""MOVW $0x00eb,{next_target}(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
"""

    # Add rail_2 bottom and footer
    asm_code += """rail_2_bottom:
    ret

footer:
    ret

.global gadget_end
gadget_end:
"""

    return asm_code


def save_to_file(asm_code, filename):
    """Save the assembly code to a file."""
    try:
        with open(filename, 'w') as f:
            f.write(asm_code)
        print(f"Successfully generated assembly file: {filename}")
    except IOError as e:
        print(f"Error writing to file {filename}: {e}")
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Generate assembly ladder microbenchmark for pingpong latency testing",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Example usage:
  python generate_asm_ladder.py                    # Generate with 3 steps to ladder_microbenchmark.S
  python generate_asm_ladder.py 5                  # Generate with 5 steps to ladder_microbenchmark.S  
  python generate_asm_ladder.py 10 my_test.S       # Generate with 10 steps to my_test.S
        """
    )

    parser.add_argument('num_steps', nargs='?', type=int, default=3,
                        help='Number of pingpong steps in the ladder (default: 3)')
    parser.add_argument('output_file', nargs='?', default='ladder_microbenchmark.S',
                        help='Output .S file path (default: ladder_microbenchmark.S)')
    parser.add_argument('--preview', action='store_true',
                        help='Print the generated assembly to stdout instead of saving to file')

    args = parser.parse_args()

    # Validate arguments
    if args.num_steps < 1:
        print("Error: num_steps must be at least 1")
        sys.exit(1)

    # Generate the assembly code
    try:
        asm_code = generate_asm_ladder(args.num_steps)

        if args.preview:
            print(f"Generated assembly ladder with {args.num_steps} steps:")
            print("=" * 60)
            print(asm_code)
        else:
            save_to_file(asm_code, args.output_file)
            print(f"Generated ladder with {args.num_steps} steps")

    except ValueError as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()

