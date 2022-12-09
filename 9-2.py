#!/usr/bin/env python

input = [row.strip().split() for row in open('9.input').readlines()]

visited = set()

knots = [(0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0), (0, 0)]

for insn in input:
    dir = insn[0]
    steps = int(insn[1])

    for _ in range(steps):
        if dir == "U":
            knots[0] = (knots[0][0], knots[0][1] + 1)
        elif dir == "D":
            knots[0] = (knots[0][0], knots[0][1] - 1)
        elif dir == "L":
            knots[0] = (knots[0][0] - 1, knots[0][1])
        elif dir == "R":
            knots[0] = (knots[0][0] + 1, knots[0][1])

        for previous in range(9):
            this = previous + 1

            if abs(knots[previous][0] - knots[this][0]) >= 2 or \
               abs(knots[previous][1] - knots[this][1]) >= 2:
                step_x = 0
                if knots[this][0] < knots[previous][0]:
                    step_x = 1
                elif knots[this][0] > knots[previous][0]:
                    step_x = -1

                step_y = 0
                if knots[this][1] < knots[previous][1]:
                    step_y = 1
                elif knots[this][1] > knots[previous][1]:
                    step_y = -1

                knots[this] = (knots[this][0] + step_x, knots[this][1] + step_y)

        visited.add(knots[9])

print(len(visited))
