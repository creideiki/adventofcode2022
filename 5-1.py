#!/usr/bin/env python

from collections import deque
import re

class Ship:
    def __init__(self, stacks, last_stack):
        self.num_stacks = last_stack + 1
        self.ship = []
        for i in range(self.num_stacks):
            self.ship.append(deque())
        for level in stacks:
            stack = 0
            for num in range(self.num_stacks - 1):
                stack += 1
                crate = level[num * 4 + 1]
                if crate == " ":
                    continue
                self.ship[stack].appendleft(crate)

    def move(self, num, source, dest):
        for _ in range(num):
            self.ship[dest].append(self.ship[source].pop())

    def result(self):
        res = ""
        for stack in self.ship:
            if len(stack) >= 1:
                res += stack[-1]
        return res

    def __str__(self):
        s = f"<{self.__class__.__name__}:\n"
        for stack in self.ship[1:]:
            s += str(stack)
            s += "\n"
        s += ">"
        return s


lines = open('5.input').readlines()

number_format = re.compile("^(( [0-9]+ ) )+( [0-9]+ )$")
move_format = re.compile("^move (?P<num>[0-9]+) from (?P<from>[0-9]+) to (?P<to>[0-9]+)$")

ship = None
stacks = []
last_stack = 0

for line in lines:
    if "[" in line:
        stacks.append(line)
    elif number_format.match(line):
        last_stack = int(line.split()[-1])
        ship = Ship(stacks, last_stack)
    elif (move := move_format.match(line.strip())):
        ship.move(int(move['num']), int(move['from']), int(move['to']))
    elif line == "\n":
        pass

print(ship.result())
