#!/usr/bin/env python

import re

monkeys = {}

class IsHuman(RuntimeError):
    pass

class Monkey:
    setting = False

    def __init__(self, name, operation):
        number_format = re.compile("^(?P<num>[0-9]+)$")
        calc_format = re.compile("^(?P<m1>[a-z]+) (?P<op>[-+*/]) (?P<m2>[a-z]+)$")

        self.operation = operation
        self.name = name
        self.val = None
        if (m := number_format.match(self.operation)):
            self.val = int(m["num"])
        else:
            m = calc_format.match(self.operation)
            self.m1 = m["m1"]
            self.op = m["op"]
            if self.name == "root":
                self.op = "=="
            self.m2 = m["m2"]

    def value(self):
        if self.setting and self.name == "humn":
            raise IsHuman

        if self.val is not None:
            return self.val

        if self.op == "+":
            self.val = monkeys[self.m1].value() + monkeys[self.m2].value()
        elif self.op == "-":
            self.val = monkeys[self.m1].value() - monkeys[self.m2].value()
        elif self.op == "*":
            self.val = monkeys[self.m1].value() * monkeys[self.m2].value()
        elif self.op == "/":
            self.val = monkeys[self.m1].value() // monkeys[self.m2].value()

        return self.val

    def set_equal(self, value):
        if self.name == "humn":
            self.val = value
            return

        try:
            left = monkeys[self.m1].value()
        except IsHuman:
            left = None

        try:
            right = monkeys[self.m2].value()
        except IsHuman:
            right = None

        if self.op == "==":
            if right is not None:
                monkeys[self.m1].set_equal(right)
            if left is not None:
                monkeys[self.m2].set_equal(left)
        elif self.op == "+":
            if right is not None:
                monkeys[self.m1].set_equal(value - right)
            if left is not None:
                monkeys[self.m2].set_equal(value - left)
        elif self.op == "-":
            if right is not None:
                monkeys[self.m1].set_equal(value + right)
            if left is not None:
                monkeys[self.m2].set_equal(left - value)
        elif self.op == "*":
            if right is not None:
                monkeys[self.m1].set_equal(value // right)
            if left is not None:
                monkeys[self.m2].set_equal(value // left)
        elif self.op == "/":
            if right is not None:
                monkeys[self.m1].set_equal(value * right)
            if left is not None:
                monkeys[self.m2].set_equal(left // value)

    def __str__(self):
        return f"<{self.__class__.__name__}: {self.name} = {self.operation} ({self.val})>"


monkey_format = re.compile("^(?P<name>[a-z]+): (?P<op>.*)$")

lines = [row.strip() for row in open("21.input").readlines()]

for line in lines:
    m = monkey_format.match(line)
    monkeys[m["name"]] = Monkey(m["name"], m["op"])

Monkey.setting = True
monkeys["root"].set_equal(None)
Monkey.setting = False

print(monkeys["humn"].value())
