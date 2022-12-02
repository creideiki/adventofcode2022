#!/usr/bin/env ruby

strategies = File.read('2.input').lines.map(&:split)

def score_round(other, me)
  outcome_score = {
    ['A', 'X'] => 3,
    ['A', 'Y'] => 6,
    ['A', 'Z'] => 0,
    ['B', 'X'] => 0,
    ['B', 'Y'] => 3,
    ['B', 'Z'] => 6,
    ['C', 'X'] => 6,
    ['C', 'Y'] => 0,
    ['C', 'Z'] => 3
  }

  play_score = {
    'X' => 1,
    'Y' => 2,
    'Z' => 3
  }

  play_score[me] + outcome_score[[other, me]]
end

play = {
  ['A', 'X'] => 'Z',
  ['A', 'Y'] => 'X',
  ['A', 'Z'] => 'Y',
  ['B', 'X'] => 'X',
  ['B', 'Y'] => 'Y',
  ['B', 'Z'] => 'Z',
  ['C', 'X'] => 'Y',
  ['C', 'Y'] => 'Z',
  ['C', 'Z'] => 'X'
}

print strategies.map { |s| score_round(s[0], play[[s[0], s[1]]]) }.reduce(:+), "\n"
