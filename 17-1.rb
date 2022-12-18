#!/usr/bin/env ruby

require 'numo/narray'

class Rock
  @shapes = [
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
    @shapes
  end

  def initialize(shape)
    @rock = @shapes[shape]
    @x = 2
    @y = 0
  end
end

class Cave
  def initialize(jets)
    @height = 10
    @map = Numo::UInt8.zeros(@height, 7)
    @next_shape = -1
    @jets = jets
    @jet_offset = -1
    @rock = nil
  end

  def step!
    unless @rock
      @rock = Rock.new(@next_shape)
      @next_shape = (@next_shape + 1) % Rock.shapes.size
    end
    push!
    @rock = nil if fall!
  end

  def push!
    
  end

  def fall!
    false
  end

  def expand!
    z = Numo::UInt8.zeros(10, 7)
    @map = z.append(map, axis:0)
  end

  def to_s
    s = "<#{self.class}:\n"
    s += "Next shape: #{@next_shape}\n"
    @height.times do |row|
      7.times do |col|
        s += case @map[row, col]
             when 0
               '.'
             when 1
               '#'
             when 2
               '@'
             end
      end
      s += "\n"
    end
    s += "\n>"
    s
  end

  alias inspect to_s
end

input = File.read('17.sample').strip

cave = Cave.new(input)

print cave, "\n"
