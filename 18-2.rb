#!/usr/bin/env ruby

require 'numo/narray'

class Map
  def initialize(max_x, max_y, max_z)
    @size_x = max_x + 3
    @size_y = max_y + 3
    @size_z = max_z + 3
    @map = Numo::UInt8.zeros(@size_x, @size_y, @size_z)
  end

  def [](x, y, z)
    @map[x + 1, y + 1, z + 1]
  end

  def []=(x, y, z, val)
    @map[x + 1, y + 1, z + 1] = val
  end

  def flood_fill!
    queue = [[0, 0, 0]]
    until queue.empty?
      cell = queue.shift
      next if @map[cell[0], cell[1], cell[2]] != 0

      @map[cell[0], cell[1], cell[2]] = 2
      queue << [cell[0] - 1, cell[1], cell[2]] if cell[0] > 0 and @map[cell[0] - 1, cell[1], cell[2]].zero?
      queue << [cell[0] + 1, cell[1], cell[2]] if cell[0] < @size_x - 1 and @map[cell[0] + 1, cell[1], cell[2]].zero?
      queue << [cell[0], cell[1] - 1, cell[2]] if cell[1] > 0 and @map[cell[0], cell[1] - 1, cell[2]].zero?
      queue << [cell[0], cell[1] + 1, cell[2]] if cell[1] < @size_y - 1 and @map[cell[0], cell[1] + 1, cell[2]].zero?
      queue << [cell[0], cell[1], cell[2] - 1] if cell[2] > 0 and @map[cell[0], cell[1], cell[2] - 1].zero?
      queue << [cell[0], cell[1], cell[2] + 1] if cell[2] < @size_z - 1 and @map[cell[0], cell[1], cell[2] + 1].zero?
    end
  end

  def count_exposed_faces
    count = 0
    (@size_x - 1).times do |x|
      (@size_y - 1).times do |y|
        (@size_z - 1).times do |z|
          next unless @map[x + 1, y + 1, z + 1] == 1

          count += 1 if @map[x + 1 - 1, y + 1, z + 1] == 2
          count += 1 if @map[x + 1 + 1, y + 1, z + 1] == 2
          count += 1 if @map[x + 1, y + 1 - 1, z + 1] == 2
          count += 1 if @map[x + 1, y + 1 + 1, z + 1] == 2
          count += 1 if @map[x + 1, y + 1, z + 1 - 1] == 2
          count += 1 if @map[x + 1, y + 1, z + 1 + 1] == 2
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

map.flood_fill!

print map.count_exposed_faces, "\n"
