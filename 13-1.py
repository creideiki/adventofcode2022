#!/usr/bin/env python

def compare(p1, p2):
    if len(p1) == 0 and len(p2) == 0:
        return 0
    if len(p1) == 0:
        return -1
    if len(p2) == 0:
        return 1

    left = p1[0]
    right = p2[0]

    if type(left) is int and type(right) is int:
        if left == right:
            return compare(p1[1:], p2[1:])
        elif left < right:
            return -1
        else:
            return 1
    elif type(left) is list and type(right) is list:
        r = compare(left, right)
        if r == 0:
            return compare(p1[1:], p2[1:])
        else:
            return r
    elif type(left) is int:
        r = compare([left], right)
        if r == 0:
            return compare(p1[1:], p2[1:])
        else:
            return r
    elif type(right) is int:
        r = compare(left, [right])
        if r == 0:
            return compare(p1[1:], p2[1:])
        else:
            return r
    else:
        raise RuntimeError(f"Type error: {left}, {right}")


input = [row.strip() for row in open('13.input').readlines()]

score = 0
index = 0

while len(input) > 0:
    index += 1
    p1 = eval(input[0])
    p2 = eval(input[1])

    if compare(p1, p2) == -1:
        score += index

    input = input[2:]
    if len(input) > 0 and input[0] == "":
        input = input[1:]

print(score)
