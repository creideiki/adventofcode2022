#!/usr/bin/env python

import heapq
import numpy

class Map:
    def __init__(self, input):
        self.height = len(input)
        self.width = len(input[0])
        self.map = numpy.zeros((self.height, self.width), dtype=numpy.uint)

        for row in range(self.height):
            for col in range(self.width):
                if input[row][col] == "S":
                    self.map[row, col] = 0
                elif input[row][col] == "E":
                    self.start = [row, col]
                    self.map[row, col] = ord('z') - ord('a')
                else:
                    self.map[row, col] = ord(input[row][col]) - ord('a')

        self.lengths = numpy.empty((self.height, self.width), dtype=numpy.uint)
        self.lengths.fill(pow(2, 32) - 1)
        self.lengths[self.start[0], self.start[1]] = 0

    def solve(self):
        queue = []
        heapq.heappush(queue, (0, (self.start[0], self.start[1])))

        while len(queue) > 0:
            length, coords = heapq.heappop(queue)
            row, col = coords
            if length > self.lengths[row, col]:
                continue

            ns = [
                [row + 1, col],
                [row - 1, col],
                [row, col + 1],
                [row, col - 1]
            ]

            neighbours = []
            for n in ns:
                if n[0] >= 0 and \
                   n[0] < self.height and \
                   n[1] >= 0 and \
                   n[1] < self.width and \
                   self.map[row, col] <= self.map[n[0], n[1]] + 1:
                    neighbours.append((n[0], n[1]))

            for v in neighbours:
                new_length = length + 1
                if new_length < self.lengths[v[0], v[1]]:
                    self.lengths[v[0], v[1]] = new_length
                    heapq.heappush(queue, (new_length, (v[0], v[1])))

    def solution(self):
        closest = pow(2, 32) - 1

        it = numpy.nditer(self.map, flags=['multi_index'])
        for element in it:
            if element > 0:
                continue

            if self.lengths[it.multi_index[0], it.multi_index[1]] < closest:
                closest = self.lengths[it.multi_index[0], it.multi_index[1]]

        return closest


lines = [list(line.strip()) for line in open('12.input').readlines()]

map = Map(lines)

map.solve()

print(map.solution())
