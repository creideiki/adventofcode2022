#!/usr/bin/env ruby

require 'numo/narray'
require 'algorithms'

class Map
  attr_accessor :start, :end, :map, :lengths

  def initialize(input)
    @height = input.size
    @width = input[0].size
    @map = Numo::UInt8.zeros(@height, @width)
    input.each_index do |row|
      input[row].each_index do |col|
        case input[row][col]
        when 'S'
          @start = [row, col]
          @map[row, col] = 0
        when 'E'
          @end = [row, col]
          @map[row, col] = 'z'.ord - 'a'.ord
        else
          @map[row, col] = input[row][col].ord - 'a'.ord
        end
      end
    end

    @lengths = Numo::UInt32.new(@height, @width).fill Numo::UInt32::MAX
    @lengths[@start[0], @start[1]] = 0
  end

  def solve!
    queue = Containers::MinHeap.new
    queue.push(0, @start)

    until queue.empty?
      length = queue.next_key
      row, col = queue.pop
      next if length > @lengths[row, col]

      neighbours = [
        [row + 1, col],
        [row - 1, col],
        [row, col + 1],
        [row, col - 1]
      ]
      neighbours.select! do |coords|
        coords[0] >= 0 and
          coords[0] < @height and
          coords[1] >= 0 and
          coords[1] < @width and
          @map[coords[0], coords[1]] <= @map[row, col] + 1
      end

      neighbours.each do |step|
        new_length = length + 1
        if new_length < @lengths[step[0], step[1]]
          @lengths[step[0], step[1]] = new_length
          queue.push(new_length, [step[0], step[1]])
        end
      end
    end
    @lengths[@end[0], @end[1]]
  end

  def to_s
    s = "<#{self.class}:\n"
    s += "Start: #{@start}, end: #{@end}\n"
    s += "\nMap:\n"
    @height.times do |row|
      @width.times do |col|
        s += @map[row, col].to_s.rjust(2, '0') + ' '
      end
      s += "\n"
    end
    s += "\nLengths:\n"
    @height.times do |row|
      @width.times do |col|
        s += @lengths[row, col].to_s.rjust(Math::log10(@lengths.max).ceil, '0') + ' '
      end
      s += "\n"
    end
    s += '>'
    s
  end

  alias inspect to_s
end

input = File.read('12.input').lines.map(&:strip).map(&:chars)

map = Map.new(input)

print map.solve!, "\n"
