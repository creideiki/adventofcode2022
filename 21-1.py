#!/usr/bin/env python

import re

monkeys = {}

class Monkey:
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
            self.m2 = m["m2"]

    def value(self):
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

    def __str__(self):
        return f"<{self.__class__.__name__}: {self.name} = {self.operation} ({self.val})>"


monkey_format = re.compile("^(?P<name>[a-z]+): (?P<op>.*)$")

lines = [row.strip() for row in open("21.input").readlines()]

for line in lines:
    m = monkey_format.match(line)
    monkeys[m["name"]] = Monkey(m["name"], m["op"])

print(monkeys["root"].value())
