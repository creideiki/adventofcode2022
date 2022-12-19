#!/usr/bin/env ruby

require 'numo/narray'

class Rock
  @@shapes = [
    [[1, 1, 1, 1]],
    [[0, 1, 0],
     [1, 1, 1],
     [0, 1, 0]],
    [[0, 0, 1],
     [0, 0, 1],
     [1, 1, 1]],
    [[1],
     [1],
     [1],
     [1]],
    [[1, 1],
     [1, 1]]
  ]

  def self.shapes
    @@shapes
  end

  def [](row, col)
    @rock[row][col]
  end

  def width
    @rock[0].size
  end

  def height
    @rock.size
  end

  attr_accessor :x, :y

  def initialize(shape)
    @rock = @@shapes[shape]
    @x = 2
    @y = 0
  end
end

class Cave
  def initialize(jets)
    @num_rocks = 0
    @height = 25
    @map = Numo::UInt8.zeros(@height, 7)
    @next_shape = -1
    @jets = jets.chars.map { |j| j == '<' ? -1 : +1 }
    @jet_offset = -1
    @rock = nil
    @highest_rock = @height
  end

  attr_reader :num_rocks, :highest_rock

  def find_repetition
    base = @jets.size
    1.upto(@jets.size * Rock.shapes.size) do |window_size|
      maybe_repeats = true
      window_size.times do |row|
        7.times do |col|
          if @map[@height - base - window_size * 0 - row, col] !=
             @map[@height - base - window_size * 1 - row, col] or
             @map[@height - base - window_size * 1 - row, col] !=
             @map[@height - base - window_size * 2 - row, col]
            maybe_repeats = false
            break
          end
        end
        break unless maybe_repeats
      end
      return [base, window_size] if maybe_repeats
    end
  end

  def rock_height
    @height - @highest_rock
  end

  def step!
    unless @rock
      @next_shape = (@next_shape + 1) % Rock.shapes.size
      @rock = Rock.new(@next_shape)
      @rock.y = @highest_rock - 3 - @rock.height
      expand! if @rock.y.negative?
    end
    push!
    @rock = nil unless fall!
  end

  def push!
    @jet_offset = (@jet_offset + 1) % @jets.size
    dir = @jets[@jet_offset]
    can_move = true
    if @rock.x + dir < 0 or
       @rock.width + @rock.x + dir > 7
      can_move = false
    else
      @rock.height.times do |row|
        @rock.width.times do |col|
          next unless @rock[row, col] == 1

          if @map[row + @rock.y, col + @rock.x + dir] != 0
            can_move = false
            break
          end
        end
      end
    end
    @rock.x += dir if can_move
  end

  def fall!
    can_fall = true
    if @rock.height + @rock.y >= @height
      can_fall = false
    else
      @rock.height.times do |row|
        @rock.width.times do |col|
          next unless @rock[row, col] == 1

          if @map[row + @rock.y + 1, col + @rock.x] != 0
            can_fall = false
            break
          end
        end
      end
    end
    if can_fall
      @rock.y += 1
    else
      @rock.height.times do |row|
        @rock.width.times do |col|
          @map[row + @rock.y, col + @rock.x] = @rock[row, col]
        end
      end
      @highest_rock = [@rock.y, @highest_rock].min
      @num_rocks += 1
    end
    can_fall
  end

  def expand!
    add = 100
    z = Numo::UInt8.zeros(add, 7)
    @map = z.append(@map, axis:0)
    @highest_rock += add
    @rock.y += add if @rock
    @height += add
  end

  def to_s
    s = "<#{self.class}:\n"
    s += "Next shape: #{@next_shape}, next push: #{@jets[@jet_offset]}\n"
    s += "Highest rock: #{@highest_rock}\n"
    @height.times do |row|
      s += row.to_s.rjust(Math::log10(@height).ceil, '0') + ' '
      7.times do |col|
        tile = 0
        if @rock and
           row.between?(@rock.y, @rock.y + @rock.height - 1) and
           col.between?(@rock.x, @rock.x + @rock.width - 1) and
           @rock[row - @rock.y, col - @rock.x] == 1
          tile = 2
        end
        tile += @map[row, col]
        s += case tile
             when 0
               '.'
             when 1
               '#'
             when 2
               '@'
             else
               '!'
             end
      end
      s += "\n"
    end
    if @rock
      s += "Rock: x: #{@rock.x}, y: #{@rock.y}\n"
      @rock.height.times do |row|
        @rock.width.times do |col|
          s += @rock[row, col].zero? ? '.' : '@'
        end
        s += "\n"
      end
      s += '>'
    end
    s
  end

  alias inspect to_s
end

input = File.read('17.input').strip

# Caves will be filled as:
#
# Remaining
# Period
# Period
# ...
# Period
# Period
# Base

# "cave" will be base + 3 periods, to find the repetition
cave = Cave.new(input)

until cave.rock_height >= input.size + input.size * Rock.shapes.size * 3 do
  cave.step!
end

base, period_height = cave.find_repetition

# "cave2" will be base + 1 period, to count the number of rocks in one
# period
cave2 = Cave.new(input)

until cave2.rock_height >= base do
  cave2.step!
end

base_rocks = cave2.num_rocks

until cave2.rock_height >= base + period_height do
  cave2.step!
end

period_rocks = cave2.num_rocks - base_rocks

final_rock = 1_000_000_000_000
periods = (final_rock - base_rocks) / period_rocks
remaining_rocks = final_rock - base_rocks - periods * period_rocks

remaining_rocks.times do
  cave2.step!
end

# "cave3" will be base + remaining, to count the rocks outside of any
# periods
cave3 = Cave.new(input)

until cave3.num_rocks == base_rocks + remaining_rocks do
  cave3.step!
end

print periods * period_height + cave3.rock_height, "\n"
