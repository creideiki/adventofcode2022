#!/bin/env python

import numpy

input = [list(line.strip()) for line in open('8.input').readlines()]
forest = numpy.array(input, dtype=numpy.uint8)
size = len(input)

visible = numpy.zeros((size, size), dtype=numpy.uint8)

for x in range(size):
    highest = -1
    for y in range(size):
        if forest[y, x] > highest:
            highest = forest[y, x]
            visible[y, x] = 1

for x in range(size):
    highest = -1
    for y in range(size):
        if forest[size - y - 1, x] > highest:
            highest = forest[size - y - 1, x]
            visible[size - y - 1, x] = 1

for y in range(size):
    highest = -1
    for x in range(size):
        if forest[y, x] > highest:
            highest = forest[y, x]
            visible[y, x] = 1

for y in range(size):
    highest = -1
    for x in range(size):
        if forest[y, size - x - 1] > highest:
            highest = forest[y, size - x - 1]
            visible[y, size - x - 1] = 1

print(numpy.count_nonzero(visible))
