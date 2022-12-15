#!/usr/bin/env ruby

class Intervals
  attr_accessor :intervals

  def initialize
    @intervals = []
  end

  def size
    @intervals.size
  end

  def add(interval)
    new = []
    @intervals.append interval
    @intervals.sort_by! { |i| i[0] }
    new.append @intervals[0]
    @intervals[1..].each do |i|
      if new.last[0] <= i[0] and i[0] <= new.last[1]
        new.last[1] = [new.last[1], i[1]].max
      elsif new.last[1] + 1 == i[0]
        new.last[1] = [new.last[1], i[1]].max
      else
        new.append i
      end
    end
    @intervals = new
  end

  def to_s
    @intervals.inspect
  end

  alias inspect to_s
end

class Map
  def initialize(input)
    sensor_regexp = /^Sensor at x=(?<sx>[[:digit:]-]+), y=(?<sy>[[:digit:]-]+): closest beacon is at x=(?<bx>[[:digit:]-]+), y=(?<by>[[:digit:]-]+)$/

    @dim = 4_000_001

    sensors = []
    beacons = []

    input.each do |sensor|
      m = sensor_regexp.match(sensor)
      sensors.append [m['sx'].to_i, m['sy'].to_i]
      beacons.append [m['bx'].to_i, m['by'].to_i]
    end

    @rows = []

    @dim.times do |row|
      int = Intervals.new
      sensors.size.times do |index|
        sx = sensors[index][0]
        sy = sensors[index][1]
        bx = beacons[index][0]
        by = beacons[index][1]

        manhattan_distance = (sx - bx).abs + (sy - by).abs
        next unless (sy - row).abs < manhattan_distance

        left = sx - (manhattan_distance - (sy - row).abs)
        right = sx + (manhattan_distance - (sy - row).abs)
        int.add [left, right]
      end
      @rows.append int
    end
  end

  def find_beacon
    @dim.times do |row|
      next unless @rows[row].size == 2

      return [@rows[row].intervals[0][1] + 1, row]
    end
  end

  def to_s
    s = "<#{self.class}:\n"
    @rows.each_with_index do |row, index|
      s += index.to_s + ': ' + row.to_s + "\n"
    end
    s += '>'
    s
  end

  alias inspect to_s
end

input = File.read('15.input').lines.map(&:strip)

map = Map.new(input)

beacon = map.find_beacon
print beacon[0] * 4_000_000 + beacon[1], "\n"
