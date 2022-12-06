#!/usr/bin/env python

from functools import reduce

buffers = [row.strip() for row in open('6.input').readlines()]

for buf in buffers:
    for pos in range(len(buf)):
        if pos < 13:
            continue

        test = buf[pos - 13:pos + 1]
        sets = [set(s) for s in test]
        unique = reduce(lambda a, b: a | b, sets)
        if len(unique) == 14:
            print(pos + 1)
            break
