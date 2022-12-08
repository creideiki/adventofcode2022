#!/usr/bin/env ruby

require 'numo/narray'

input = File.read('8.input').lines.map(&:strip).map { |l| l.chars.map(&:to_i) }
size = input.size

scores = Numo::Int32.new(size, size).fill 0

size.times do |x_house|
  size.times do |y_house|
    height_house = input[y_house][x_house]
    score = 1

    dist = 0
    y = y_house
    x_house.downto(0) do |x|
      next if x == x_house

      dist += 1
      break if input[y][x] >= height_house
    end
    score *= dist

    dist = 0
    y = y_house
    x_house.upto(size - 1) do |x|
      next if x == x_house

      dist += 1
      break if input[y][x] >= height_house
    end
    score *= dist

    dist = 0
    x = x_house
    y_house.downto(0) do |y|
      next if y == y_house

      dist += 1
      break if input[y][x] >= height_house
    end
    score *= dist

    dist = 0
    x = x_house
    y_house.upto(size - 1) do |y|
      next if y == y_house

      dist += 1
      break if input[y][x] >= height_house
    end
    score *= dist

    scores[y_house, x_house] = score
  end
end

print scores.max, "\n"
