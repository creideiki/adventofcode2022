#!/usr/bin/env python

input = [row.strip().split() for row in open('9.input').readlines()]

visited = set()

head = (0, 0)
tail = (0, 0)

for insn in input:
    dir = insn[0]
    steps = int(insn[1])

    for _ in range(steps):
        prev_head = head

        if dir == "U":
            head = (head[0], head[1] + 1)
        elif dir == "D":
            head = (head[0], head[1] - 1)
        elif dir == "L":
            head = (head[0] - 1, head[1])
        elif dir == "R":
            head = (head[0] + 1, head[1])

        if abs(head[0] - tail[0]) >= 2 or \
           abs(head[1] - tail[1]) >= 2:
            tail = prev_head

        visited.add(tail)

print(len(visited))
