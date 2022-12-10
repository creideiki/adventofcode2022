#!/usr/bin/env python

import numpy
import re


class CPU:
    def __init__(self):
        self.x = 1
        self.cycle = 0
        self.crt = numpy.zeros((6, 40), dtype=numpy.bool8)

    def advance_timer(self, cycles):
        for _ in range(cycles):
            beam_row = self.cycle // 40
            beam_col = self.cycle % 40
            if abs(beam_col - self.x) <= 1:
                self.crt[beam_row, beam_col] = 1
            self.cycle += 1

    def display(self):
        s = ''
        for row in range(numpy.shape(self.crt)[0]):
            for col in range(numpy.shape(self.crt)[1]):
                if self.crt[row, col] == 1:
                    s += "#"
                else:
                    s += "."
            s += "\n"
        return s

    def addx(self, v):
        self.advance_timer(2)
        self.x += int(v)

    def noop(self, _):
        self.advance_timer(1)

    def __str__(self):
        s = f"<{self.__class__.__name__}: X: {self.x}, cycle: {self.cycle}\n"
        s += self.display()
        s += ">"
        return s


instructions = [insn.strip() for insn in open('10.input').readlines()]

instruction_format = re.compile("(?P<inst>addx|noop) ?(?P<oper>-?[0-9]+)?")

cpu = CPU()

for insn in instructions:
    m = instruction_format.match(insn)
    fun = getattr(cpu, m['inst'])
    fun(m['oper'])

print(cpu.display())
