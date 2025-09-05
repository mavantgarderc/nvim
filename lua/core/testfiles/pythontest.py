#!/usr/bin/env python3
"""tiny CLI: counts lines in files or stdin"""
import sys
def count_lines(files):
    if not files:
        print(sum(1 for _ in sys.stdin), "lines (stdin)")
        return
    for path in files:
        try:
            with open(path, 'r', encoding='utf-8') as f:
                n = sum(1 for _ in f)
            print(f"{path}: {n} lines")
        except Exception as e:
            print(f"{path}: error: {e}", file=sys.stderr)

if __name__ == "__main__":
    count_lines(sys.argv[1:])
