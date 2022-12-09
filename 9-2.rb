#!/usr/bin/env ruby

require 'set'

input = File.read('9.input').lines.map(&:strip).map(&:split)

visited = Set.new

knots = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]

input.each do |insn|
  dir = insn[0]
  steps = insn[1].to_i

  steps.times do
    case dir
    when 'U'
      knots[0][1] += 1
    when 'D'
      knots[0][1] -= 1
    when 'L'
      knots[0][0] -= 1
    when 'R'
      knots[0][0] += 1
    end

    9.times do |previous|
      this = previous + 1

      if (knots[previous][0] - knots[this][0]).abs >= 2 or
         (knots[previous][1] - knots[this][1]).abs >= 2
        knots[this][0] += 1 if knots[this][0] < knots[previous][0]
        knots[this][0] -= 1 if knots[this][0] > knots[previous][0]
        knots[this][1] += 1 if knots[this][1] < knots[previous][1]
        knots[this][1] -= 1 if knots[this][1] > knots[previous][1]
      end
    end
    visited.add [knots[9][0], knots[9][1]]
  end
end

print visited.size, "\n"
