#!/usr/bin/env ruby

require 'numo/narray'

class Map
  def initialize(input, row)
    sensor_regexp = /^Sensor at x=(?<sx>[[:digit:]-]+), y=(?<sy>[[:digit:]-]+): closest beacon is at x=(?<bx>[[:digit:]-]+), y=(?<by>[[:digit:]-]+)$/
    @row = row

    min_x = 2**30 - 1
    max_x = 0
    max_dist = 0
    sensors = []
    beacons = []

    input.each do |sensor|
      m = sensor_regexp.match(sensor)
      sx = m['sx'].to_i
      sy = m['sy'].to_i
      bx = m['bx'].to_i
      by = m['by'].to_i
      min_x = [min_x, sx, bx].min
      max_x = [max_x, sx, bx].max
      max_dist = [max_dist, (sx - bx).abs + (sy - by).abs + 1].max
      sensors.append [sx, sy]
      beacons.append [bx, by]
    end

    @width = (max_x - min_x) + 2 * max_dist + 1
    @x_offset = min_x - max_dist
    @map = Numo::UInt8.zeros(@width)

    sensors.size.times do |index|
      sx = sensors[index][0] - @x_offset
      sy = sensors[index][1]
      bx = beacons[index][0] - @x_offset
      by = beacons[index][1]
      @map[sx] = 1 if sy == @row
      @map[bx] = 2 if by == @row

      manhattan_distance = (sx - bx).abs + (sy - by).abs
      next unless (sy - @row).abs < manhattan_distance

      num_cols = manhattan_distance - (sy - @row).abs + 1
      num_cols.times do |x_dist|
        @map[sx - x_dist] = 3 if sx - x_dist >= 0 and @map[sx - x_dist].zero?
        @map[sx + x_dist] = 3 if sx + x_dist < @width and @map[sx + x_dist].zero?
      end
    end
  end

  def count_impossibles
    count = 0
    @map.each { |cell| count += 1 if [1, 3].include? cell }
    count
  end

  def to_s
    s = "<#{self.class}:\n"
    s += "Row: #{@row}, x offset: #{@x_offset}, width: #{@width}\n"
    @width.times do |col|
      s += case @map[col]
           when 0
             '.'
           when 1
             'S'
           when 2
             'B'
           when 3
             '#'
           end
    end
    s += "\n>"
    s
  end

  alias inspect to_s
end

input = File.read('15.input').lines.map(&:strip)

map = Map.new(input, 2_000_000)

print map.count_impossibles, "\n"
