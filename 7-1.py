#!/usr/bin/env python

from functools import reduce
import re

class Directory:
    def __init__(self, parent, name):
        self.parent = parent
        self.name = name
        self.dirs = {}
        self.files = {}
        self.sz = -1

    def size(self):
        if self.sz == -1:
            self.sz = reduce(lambda a, b: a + b,
                             [d.size() for d in self.dirs.values()], 0) + \
                      reduce(lambda a, b: a + b,
                             self.files.values(), 0)

        return self.sz

    def include(self):
        return self.size() <= 100_000

    def __str__(self):
        s = f"<{self.__class__.__name__}: {self.name} {self.size()}\n"
        s += "Subdirectories:\n"
        for name, _ in self.dirs.items():
            s += name
            s += "\n"
        s += "Files:\n"
        for name, size in self.files.items():
            s += f"{name}: {size}\n"
        s += ">"
        return s


cd_format = re.compile("^\\$ cd (?P<dir>[A-Za-z0-9\\.\\-]+)$")
ls_format = re.compile("^\\$ ls$")
dir_list_format = re.compile("^dir (?P<name>[A-Za-z0-9\\.\\-]+)$")
file_list_format = re.compile("^(?P<size>[0-9]+) (?P<name>[A-Za-z0-9\\.\\-]+)$")

root = Directory(None, '/')

lines = [row.strip() for row in open('7.input').readlines()]

cwd = root

for line in lines:
    if (match := cd_format.match(line)):
        if match['dir'] == '/':
            cwd = root
        elif match['dir'] == '..':
            cwd = cwd.parent
        else:
            cwd = cwd.dirs[match['dir']]
    elif ls_format.match(line):
        pass
    elif (match := dir_list_format.match(line)):
        cwd.dirs[match['name']] = Directory(cwd, match['name'])
    elif (match := file_list_format.match(line)):
        cwd.files[match['name']] = int(match['size'])

counted = []

to_check = [root]

while len(to_check) > 0:
    cwd = to_check.pop()
    if cwd.include():
        counted.append(cwd)

    to_check.extend(cwd.dirs.values())

print(reduce(lambda a, b: a + b, [d.size() for d in counted], 0))
