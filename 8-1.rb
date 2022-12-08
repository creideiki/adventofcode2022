#!/usr/bin/env ruby

require 'numo/narray'

input = File.read('8.input').lines.map(&:strip).map { |l| l.chars.map(&:to_i) }
size = input.size

visible = Numo::Bit.new(size, size).fill 0

size.times do |x|
  highest = -1
  size.times do |y|
    if input[y][x] > highest
      highest = input[y][x]
      visible[y, x] = 1
    end
  end
end

size.times do |x|
  highest = -1
  size.times do |y|
    if input[size - y - 1][x] > highest
      highest = input[size - y - 1][x]
      visible[size - y - 1, x] = 1
    end
  end
end

size.times do |y|
  highest = -1
  size.times do |x|
    if input[y][x] > highest
      highest = input[y][x]
      visible[y, x] = 1
    end
  end
end

size.times do |y|
  highest = -1
  size.times do |x|
    if input[y][size - x - 1] > highest
      highest = input[y][size - x - 1]
      visible[y, size - x - 1] = 1
    end
  end
end

print visible.count_true, "\n"
