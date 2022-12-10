#!/usr/bin/env python

import re


class CPU:
    def __init__(self):
        self.x = 1
        self.cycle = 0
        self.strength = 0
        self.next_sample = 20

    def advance_timer(self, cycles):
        if self.cycle + cycles >= self.next_sample:
            self.strength += self.next_sample * self.x
            self.next_sample += 40

        self.cycle += cycles

    def addx(self, v):
        self.advance_timer(2)
        self.x += int(v)

    def noop(self, _):
        self.advance_timer(1)

    def __str__(self):
        return f"<{self.__class__.__name__}: X: {self.x}, cycle: {self.cycle}, strength: {self.strength}>"


instructions = [insn.strip() for insn in open('10.input').readlines()]

instruction_format = re.compile("(?P<inst>addx|noop) ?(?P<oper>-?[0-9]+)?")

cpu = CPU()

for insn in instructions:
    m = instruction_format.match(insn)
    fun = getattr(cpu, m['inst'])
    fun(m['oper'])

print(cpu.strength)
