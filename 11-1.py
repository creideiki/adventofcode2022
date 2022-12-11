#!/usr/bin/env python

import re


class Monkey:
    def __init__(self, number):
        self.business = 0
        self.dest_false = None
        self.dest_true = None
        self.divisor = None
        self.items = None
        self.number = number
        self.operation = None

    def __str__(self):
        return f"<{self.__class__.__name__}  {self.number}: business: {self.business}, items: {self.items}, op: {self.operation}, div: {self.divisor}, true: {self.dest_true}, false: {self.dest_false}>"


lines = [line.strip() for line in open('11.input').readlines()]

monkeys = []

current = None

for line in lines:
    if (m := re.match("^Monkey (?P<num>[0-9]+):$", line)):
        current = Monkey(int(m['num']))
        monkeys.append(current)
    elif (m := re.match("^Starting items: (?P<items>[0-9, ]+)$", line)):
        current.items = [int(i) for i in m['items'].split(", ")]
    elif (m := re.match("^Operation: new = (?P<oper>.+)$", line)):
        current.operation = m['oper']
    elif (m := re.match("^Test: divisible by (?P<div>[0-9]+)$", line)):
        current.divisor = int(m['div'])
    elif (m := re.match("If true: throw to monkey (?P<target>[0-9]+)$", line)):
        current.dest_true = int(m['target'])
    elif (m := re.match("If false: throw to monkey (?P<target>[0-9]+)$", line)):
        current.dest_false = int(m['target'])

for round in range(20):
    for m in monkeys:
        for item in m.items:
            m.business += 1
            item = eval(m.operation, {}, {'old': item})
            item //= 3
            dest = -1
            if item % m.divisor == 0:
                dest = m.dest_true
            else:
                dest = m.dest_false
            monkeys[dest].items.append(item)
        m.items = []

s = sorted(monkeys, key=lambda m: m.business)
print(s[-1].business * s[-2].business)
