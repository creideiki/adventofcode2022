#!/usr/bin/env python

import numpy
from copy import deepcopy


class Map:
    def __init__(self, input):
        min_x = pow(2, 16) - 1
        max_x = 0
        max_y = 0
        for path in input:
            for segment in path:
                min_x = min(segment[0], min_x)
                max_x = max(segment[0], max_x)
                max_y = max(segment[1], max_y)
        self.width = max_y * 2 + 5
        self.height = max_y + 2
        self.offset = 500 - (self.width // 2)
        self.map = numpy.zeros((self.width, self.height), dtype=numpy.uint)
        self.source = [500 - self.offset, 0]
        self.map[self.source[0], self.source[1]] = 2
        self.sand = 0

        for path in input:
            last_segment = None
            for segment in path:
                if last_segment:
                    if last_segment[0] == segment[0] and last_segment[1] < segment[1]:
                        for row in range(last_segment[1], segment[1] + 1):
                            self.map[segment[0] - self.offset, row] = 1
                    elif last_segment[0] == segment[0] and last_segment[1] > segment[1]:
                        for row in range(last_segment[1], segment[1] - 1, -1):
                            self.map[segment[0] - self.offset, row] = 1
                    elif last_segment[0] < segment[0] and last_segment[1] == segment[1]:
                        for col in range(last_segment[0], segment[0] + 1):
                            self.map[col - self.offset, segment[1]] = 1
                    elif last_segment[0] > segment[0] and last_segment[1] == segment[1]:
                        for col in range(last_segment[0], segment[0] - 1, -1):
                            self.map[col - self.offset, segment[1]] = 1

                last_segment = segment

    def fill(self):
        while self.round():
            self.sand += 1
        self.sand += 1

    def round(self):
        sand = deepcopy(self.source)

        while True:
            if sand[1] == self.height - 1:
                self.map[sand[0], sand[1]] = 3
                return True
            elif self.map[sand[0], sand[1] + 1] == 0:
                sand[1] += 1
            elif self.map[sand[0] - 1, sand[1] + 1] == 0:
                sand[0] -= 1
                sand[1] += 1
            elif self.map[sand[0] + 1, sand[1] + 1] == 0:
                sand[0] += 1
                sand[1] += 1
            else:
                self.map[sand[0], sand[1]] = 3
                if sand[0] == self.source[0] and sand[1] == self.source[1]:
                    return False
                else:
                    return True

    def __str__(self):
        s = f"<{self.__class__.__name__}:\nOffset: {self.offset}\n"
        for row in range(self.height):
            for col in range(self.width):
                if self.map[col, row] == 0:
                    s += "."
                elif self.map[col, row] == 1:
                    s += "#"
                elif self.map[col, row] == 2:
                    s += "+"
                elif self.map[col, row] == 3:
                    s += "o"
            s += "\n"
        s += f"Height: {self.height}>"
        return s


lines = [line.strip().split(" -> ") for line in open('14.input').readlines()]
lines = list(map(lambda path: list(map(lambda segment: list(map(lambda coord: int(coord), segment.split(","))), path)), lines))

obj = Map(lines)

obj.fill()

print(obj.sand)
