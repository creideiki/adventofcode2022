#!/usr/bin/env ruby

require 'set'

input = File.read('9.input').lines.map(&:strip).map(&:split)

visited = Set.new

head_x = 0
head_y = 0
tail_x = 0
tail_y = 0

input.each do |insn|
  dir = insn[0]
  steps = insn[1].to_i

  steps.times do
    prev_head_x = head_x
    prev_head_y = head_y

    case dir
    when 'U'
      head_y += 1
    when 'D'
      head_y -= 1
    when 'L'
      head_x -= 1
    when 'R'
      head_x += 1
    end

    if (head_x - tail_x).abs >= 2 or
       (head_y - tail_y).abs >= 2
      tail_x = prev_head_x
      tail_y = prev_head_y
    end

    visited.add [tail_x, tail_y]
  end
end

print visited.size, "\n"
