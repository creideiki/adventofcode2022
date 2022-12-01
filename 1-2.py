#!/usr/bin/env python

values = [row.strip() for row in open('1.input').readlines()]

elf_calories = {}

elf = 0
for v in values:
    if v == '':
        elf += 1
    else:
        elf_calories[elf] = elf_calories.get(elf, 0) + int(v)

sorted = list(elf_calories.values())
sorted.sort()
print(sum(sorted[-3:]))
