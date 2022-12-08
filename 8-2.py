#!/bin/env python

import numpy

input = [list(line.strip()) for line in open('8.input').readlines()]
forest = numpy.array(input, dtype=numpy.uint8)
size = len(input)

scores = numpy.zeros((size, size), dtype=numpy.uint32)

for x_house in range(size):
    for y_house in range(size):
        height_house = forest[y_house, x_house]
        score = 1

        dist = 0
        y = y_house
        for x in range(x_house - 1, -1, -1):
            dist += 1
            if forest[y, x] >= height_house:
                break
        score *= dist

        dist = 0
        x = x_house
        for y in range(y_house - 1, -1, -1):
            dist += 1
            if forest[y, x] >= height_house:
                break
        score *= dist

        dist = 0
        y = y_house
        for x in range(x_house + 1, size):
            dist += 1
            if forest[y, x] >= height_house:
                break
        score *= dist

        dist = 0
        x = x_house
        for y in range(y_house + 1, size):
            dist += 1
            if forest[y, x] >= height_house:
                break
        score *= dist

        scores[y_house, x_house] = score


print(numpy.amax(scores))
