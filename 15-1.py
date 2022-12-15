#!/usr/bin/env python

import numpy
import re

class Map:
    def __init__(self, input, row):
        sensor_regexp = re.compile("^Sensor at x=(?P<sx>[0-9-]+), y=(?P<sy>[0-9-]+): closest beacon is at x=(?P<bx>[0-9-]+), y=(?P<by>[0-9-]+)$")
        self.row = row

        min_x = pow(2, 30) - 1
        max_x = 0
        max_dist = 0
        sensors = []
        beacons = []

        for sensor in input:
            m = sensor_regexp.match(sensor)
            sx = int(m['sx'])
            sy = int(m['sy'])
            bx = int(m['bx'])
            by = int(m['by'])
            min_x = min(min_x, sx, bx)
            max_x = max(max_x, sx, bx)
            max_dist = max(max_dist, abs(sx - bx) + abs(sy - by) + 1)
            sensors.append((sx, sy))
            beacons.append((bx, by))

        self.width = (max_x - min_x) + 2 * max_dist + 1
        self.x_offset = min_x - max_dist
        self.map = numpy.zeros((self.width), dtype=numpy.uint)

        for index in range(len(sensors)):
            sx = sensors[index][0] - self.x_offset
            sy = sensors[index][1]
            bx = beacons[index][0] - self.x_offset
            by = beacons[index][1]
            if sy == self.row:
                self.map[sx] = 1
            if by == self.row:
                self.map[bx] = 2

            manhattan_distance = abs(sx - bx) + abs(sy - by)
            if not abs(sy - self.row) < manhattan_distance:
                continue

            num_cols = manhattan_distance - abs(sy - self.row) + 1
            for x_dist in range(num_cols):
                if sx - x_dist >= 0 and self.map[sx - x_dist] == 0:
                    self.map[sx - x_dist] = 3
                if sx + x_dist < self.width and self.map[sx + x_dist] == 0:
                    self.map[sx + x_dist] = 3

    def count_impossibles(self):
        count = 0
        for cell in self.map:
            if cell == 1 or cell == 3:
                count += 1
        return count

    def __str__(self):
        s = f"<{self.__class__.__name__}:\n"
        s += f"Row: #{self.row}, x offset: #{self.x_offset}, width: #{self.width}\n"
        for col in range(self.width):
            if self.map[col] == 0:
                s += "."
            elif self.map[col] == 1:
                s += "S"
            elif self.map[col] == 2:
                s += "B"
            elif self.map[col] == 3:
                s += "#"
        s += "\n>"
        return s


lines = [line.strip() for line in open('15.input').readlines()]

obj = Map(lines, 2_000_000)
print(obj.count_impossibles())
