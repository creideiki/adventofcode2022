#!/usr/bin/env python

from functools import cmp_to_key


def compare(p1, p2):
    if len(p1) == 0 and len(p2) == 0:
        return 0
    if len(p1) == 0:
        return -1
    if len(p2) == 0:
        return 1

    left = p1[0]
    right = p2[0]

    if type(left) is int and type(right) is int:
        if left == right:
            return compare(p1[1:], p2[1:])
        elif left < right:
            return -1
        else:
            return 1
    elif type(left) is list and type(right) is list:
        r = compare(left, right)
        if r == 0:
            return compare(p1[1:], p2[1:])
        else:
            return r
    elif type(left) is int:
        r = compare([left], right)
        if r == 0:
            return compare(p1[1:], p2[1:])
        else:
            return r
    elif type(right) is int:
        r = compare(left, [right])
        if r == 0:
            return compare(p1[1:], p2[1:])
        else:
            return r
    else:
        raise RuntimeError(f"Type error: {left}, {right}")


dividers = [[[2]], [[6]]]

input = [eval(row.strip()) for row in open('13.input').readlines() if row != "\n"]
input += dividers

s = sorted(input, key=cmp_to_key(compare))

key = 1
for d in dividers:
    key *= s.index(d) + 1

print(key)
