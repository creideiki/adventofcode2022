#!/usr/bin/env ruby

require 'numo/narray'

class Map
  attr_accessor :sand

  def initialize(input)
    min_x = 2**16 - 1
    max_x = 0
    max_y = 0
    input.each do |path|
      path.each do |segment|
        min_x = segment[0] if segment[0] < min_x
        max_x = segment[0] if segment[0] > max_x
        max_y = segment[1] if segment[1] > max_y
      end
    end
    @width = max_x - min_x + 3
    @height = max_y + 1
    @offset = min_x - 1
    @map = Numo::UInt8.zeros(@width, @height)
    @source = [500 - @offset, 0]
    @map[@source[0], @source[1]] = 2
    @sand = 0

    input.each do |path|
      last_segment = nil
      path.each do |segment|
        if last_segment
          if last_segment[0] == segment[0] and last_segment[1] < segment[1]
            last_segment[1].upto(segment[1]) { |row| @map[segment[0] - @offset, row] = 1 }
          elsif last_segment[0] == segment[0] and last_segment[1] > segment[1]
            last_segment[1].downto(segment[1]) { |row| @map[segment[0] - @offset, row] = 1 }
          elsif last_segment[0] < segment[0] and last_segment[1] == segment[1]
            last_segment[0].upto(segment[0]) { |col| @map[col - @offset, segment[1]] = 1 }
          elsif last_segment[0] > segment[0] and last_segment[1] == segment[1]
            last_segment[0].downto(segment[0]) { |col| @map[col - @offset, segment[1]] = 1 }
          end
        end

        last_segment = segment
      end
    end
  end

  def fill!
    @sand += 1 while round!
  end

  def round!
    sand = @source.clone

    while true
      if sand[1] >= @height - 1
        return false
      elsif @map[sand[0], sand[1] + 1] == 0
        sand[1] += 1
      elsif @map[sand[0] - 1, sand[1] + 1] == 0
        sand[0] -= 1
        sand[1] += 1
      elsif @map[sand[0] + 1, sand[1] + 1] == 0
        sand[0] += 1
        sand[1] += 1
      else
        @map[sand[0], sand[1]] = 3
        return true
      end
    end
  end

  def to_s
    s = "<#{self.class}:\n"
    s += "Offset: #{@offset}\n"
    @height.times do |row|
      @width.times do |col|
        s += case @map[col, row]
             when 0
               '.'
             when 1
               '#'
             when 2
               '+'
             when 3
               'o'
             end
      end
      s += "\n"
    end
    s += "Height: #{@height}>"
    s
  end

  alias inspect to_s
end

input = File.read('14.input').lines
          .map(&:strip)
          .map do |l| (l.split ' -> ')
                   .map do |coords| (coords.split ',')
                            .map(&:to_i)
                   end
          end

map = Map.new(input)
map.fill!
print map.sand, "\n"
