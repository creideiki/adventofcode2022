#!/usr/bin/env python

from functools import reduce

strategies = [row.strip().split() for row in open('2.input').readlines()]


def score_round(other, me):
    outcome_score = {
        ('A', 'X'): 3,
        ('A', 'Y'): 6,
        ('A', 'Z'): 0,
        ('B', 'X'): 0,
        ('B', 'Y'): 3,
        ('B', 'Z'): 6,
        ('C', 'X'): 6,
        ('C', 'Y'): 0,
        ('C', 'Z'): 3
    }
    play_score = {
        'X': 1,
        'Y': 2,
        'Z': 3
    }
    return play_score[me] + outcome_score[(other, me)]


print(reduce(lambda x, y: x + y, [score_round(s[0], s[1]) for s in strategies]))
