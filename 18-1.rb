#!/usr/bin/env ruby

require 'numo/narray'

class Map
  def initialize(max_x, max_y, max_z)
    @size_x = max_x + 1
    @size_y = max_y + 1
    @size_z = max_z + 1
    @map = Numo::UInt8.zeros(@size_x, @size_y, @size_z)
  end

  def [](x, y, z)
    @map[x, y, z]
  end

  def []=(x, y, z, val)
    @map[x, y, z] = val
  end

  def count_exposed_faces
    count = 0
    @size_x.times do |x|
      @size_y.times do |y|
        @size_z.times do |z|
          next unless @map[x, y, z] == 1

          count += 1 if x == 0 or @map[x - 1, y, z] == 0
          count += 1 if x == @size_x - 1 or @map[x + 1, y, z] == 0
          count += 1 if y == 0 or @map[x, y - 1, z] == 0
          count += 1 if y == @size_y - 1 or @map[x, y + 1, z] == 0
          count += 1 if z == 0 or @map[x, y, z - 1] == 0
          count += 1 if z == @size_z - 1 or @map[x, y, z + 1] == 0
        end
      end
    end
    count
  end
end

input = File.read('18.input').lines.map(&:strip).map { |l| l.split(',').map(&:to_i) }

max_x = input.map(&:first).max
max_y = input.map { |c| c[1] }.max
max_z = input.map(&:last).max

map = Map.new(max_x, max_y, max_z)

input.each do |coords|
  map[coords[0], coords[1], coords[2]] = 1
end

print map.count_exposed_faces, "\n"
