#!/usr/bin/env python

from functools import reduce


def priority(item):
    if ord(item) in range(ord('a'), ord('z') + 1):
        return ord(item) - 96
    if ord(item) in range(ord('A'), ord('Z') + 1):
        return ord(item) - 64 + 26


rucksacks = [row.strip() for row in open('3.input').readlines()]
rucksacks = [(r[:len(r)//2], r[len(r)//2:]) for r in rucksacks]
duplicates = [set(r[0]) & set(r[1]) for r in rucksacks]
print(reduce(lambda x, y: x + y, [priority(d.pop()) for d in duplicates]))
