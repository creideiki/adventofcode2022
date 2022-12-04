#!/usr/bin/env python

from functools import reduce

assignments = [row.strip().split(",") for row in open('4.input').readlines()]
assignments = map(lambda a: list(map(lambda b: b.split("-"), a)), assignments)


def overlaps(a, b):
    if (int(a[0]) <= int(b[0]) and int(a[1]) >= int(b[1])) or \
       (int(b[0]) <= int(a[0]) and int(b[1]) >= int(a[1])):
        return 1
    else:
        return 0


print(reduce(lambda a, b: a + b, map(lambda a: overlaps(a[0], a[1]), assignments)))
