#!/usr/bin/env python

from functools import reduce

buffers = [row.strip() for row in open('6.input').readlines()]

for buf in buffers:
    for pos in range(len(buf)):
        if pos < 3:
            continue

        test = buf[pos - 3:pos + 1]
        sets = [set(s) for s in test]
        unique = reduce(lambda a, b: a | b, sets)
        if len(unique) == 4:
            print(pos + 1)
            break
