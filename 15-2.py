#!/usr/bin/env python

import re


class Intervals:
    def __init__(self):
        self.intervals = []

    def size(self):
        return len(self.intervals)

    def add(self, interval):
        new = []
        self.intervals.append(interval)
        self.intervals.sort()
        new.append(self.intervals[0])
        for i in self.intervals[1:]:
            if new[-1][0] <= i[0] and i[0] <= new[-1][1]:
                new[-1][1] = max(new[-1][1], i[1])
            elif new[-1][1] + 1 == i[0]:
                new[-1][1] = max(new[-1][1], i[1])
            else:
                new.append(i)
        self.intervals = new

    def __str__(self):
        return str(self.intervals)


class Map:
    def __init__(self, input):
        sensor_regexp = re.compile("^Sensor at x=(?P<sx>[0-9-]+), y=(?P<sy>[0-9-]+): closest beacon is at x=(?P<bx>[0-9-]+), y=(?P<by>[0-9-]+)$")

        self.dim = 4_000_001

        sensors = []
        beacons = []

        for sensor in input:
            m = sensor_regexp.match(sensor)
            sensors.append([int(m['sx']), int(m['sy'])])
            beacons.append([int(m['bx']), int(m['by'])])

        self.rows = []

        for row in range(self.dim):
            ints = Intervals()
            for index in range(len(sensors)):
                sx = sensors[index][0]
                sy = sensors[index][1]
                bx = beacons[index][0]
                by = beacons[index][1]

                manhattan_distance = abs(sx - bx) + abs(sy - by)
                if not abs(sy - row) < manhattan_distance:
                    continue

                left = sx - (manhattan_distance - abs(sy - row))
                right = sx + (manhattan_distance - abs(sy - row))
                ints.add([left, right])
            self.rows.append(ints)

    def find_beacon(self):
        for row in range(self.dim):
            if self.rows[row].size() != 2:
                continue
            return [self.rows[row].intervals[0][1] + 1, row]

    def __str__(self):
        s = f"<{self.__class__.__name__}:\n"
        for index in range(len(self.rows)):
            s += str(index) + ": " + str(self.rows[index]) + "\n"
        s += ">"
        return s


lines = [line.strip() for line in open('15.input').readlines()]

obj = Map(lines)
beacon = obj.find_beacon()
print(beacon[0] * 4_000_000 + beacon[1])
