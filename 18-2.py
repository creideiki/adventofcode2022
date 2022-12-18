#!/usr/bin/env python

import numpy
from collections import deque


class Map:
    def __init__(self, max_x, max_y, max_z):
        self.size_x = max_x + 3
        self.size_y = max_y + 3
        self.size_z = max_z + 3
        self.map = numpy.zeros((self.size_x, self.size_y, self.size_z), dtype=numpy.uint8)

    def flood_fill(self):
        queue = deque([[0, 0, 0]])
        while len(queue) > 0:
            cell = queue.popleft()
            if self.map[cell[0], cell[1], cell[2]] != 0:
                continue

            self.map[cell[0], cell[1], cell[2]] = 2

            if cell[0] > 0 and self.map[cell[0] - 1, cell[1], cell[2]] == 0:
                queue.append([cell[0] - 1, cell[1], cell[2]])
            if cell[0] < self.size_x - 1 and self.map[cell[0] + 1, cell[1], cell[2]] == 0:
                queue.append([cell[0] + 1, cell[1], cell[2]])
            if cell[1] > 0 and self.map[cell[0], cell[1] - 1, cell[2]] == 0:
                queue.append([cell[0], cell[1] - 1, cell[2]])
            if cell[1] < self.size_y - 1 and self.map[cell[0], cell[1] + 1, cell[2]] == 0:
                queue.append([cell[0], cell[1] + 1, cell[2]])
            if cell[2] > 0 and self.map[cell[0], cell[1], cell[2] - 1] == 0:
                queue.append([cell[0], cell[1], cell[2] - 1])
            if cell[2] < self.size_z - 1 and self.map[cell[0], cell[1], cell[2] + 1] == 0:
                queue.append([cell[0], cell[1], cell[2] + 1])


    def count_exposed_faces(self):
        count = 0
        for x in range(self.size_x):
            for y in range(self.size_y):
                for z in range(self.size_z):
                    if self.map[x, y, z] == 1:
                        if x == 0 or self.map[x - 1, y, z] == 2:
                            count += 1
                        if x == self.size_x - 1 or self.map[x + 1, y, z] == 2:
                            count += 1
                        if y == 0 or self.map[x, y - 1, z] == 2:
                            count += 1
                        if y == self.size_y - 1 or self.map[x, y + 1, z] == 2:
                            count += 1
                        if z == 0 or self.map[x, y, z - 1] == 2:
                            count += 1
                        if z == self.size_z - 1 or self.map[x, y, z + 1] == 2:
                            count += 1
        return count


lines = [list(map(lambda c: int(c), line.strip().split(","))) for line in open('18.input').readlines()]

max_x = max([x for x, _, _ in lines])
max_y = max([y for _, y, _ in lines])
max_z = max([z for _, _, z in lines])

obj = Map(max_x, max_y, max_z)

for coords in lines:
    obj.map[coords[0], coords[1], coords[2]] = 1

obj.flood_fill()
print(obj.count_exposed_faces())
