#!/usr/bin/env python

from functools import reduce


def priority(item):
    if ord(item) in range(ord('a'), ord('z') + 1):
        return ord(item) - 96
    if ord(item) in range(ord('A'), ord('Z') + 1):
        return ord(item) - 64 + 26


rucksacks = [row.strip() for row in open('3.input').readlines()]

p = 0
for base in range(0, len(rucksacks), 3):
    badge = set(rucksacks[base]) & \
        set(rucksacks[base + 1]) & \
        set(rucksacks[base + 2])
    p += priority(badge.pop())

print(p)
