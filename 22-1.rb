#!/usr/bin/env ruby

require 'numo/narray'
require 'ostruct'

class Map
  def initialize(input)
    @instructions = input.pop.scan(/[[:digit:]]+|L|R/).map { |i| /[[:digit:]]+/.match(i) ? i.to_i : i }

    input.pop

    input = input.map(&:chars)
    @height = input.size + 2
    @width = input.map(&:size).max + 2
    @map = Numo::UInt8.zeros(@height, @width)
    input.each_index do |row|
      input[row].each_index do |col|
        case input[row][col]
        when ' '
          @map[row + 1, col + 1] = 0
        when '.'
          @map[row + 1, col + 1] = 1
        when '#'
          @map[row + 1, col + 1] = 2
        end
      end
    end

    @pos = OpenStruct.new
    @pos.row = 1
    @width.times do |x|
      if @map[@pos.row, x] == 1
        @pos.col = x
        break
      end
    end
    @dir = '>'
  end

  def step!
    inst = @instructions.shift
    case inst
    when 'R'
      @dir = case @dir
             when '>'
               'v'
             when 'v'
               '<'
             when '<'
               '^'
             when '^'
               '>'
             end
    when 'L'
      @dir = case @dir
             when '>'
               '^'
             when '^'
               '<'
             when '<'
               'v'
             when 'v'
               '>'
             end
    else
      case @dir
      when '>'
        inst.times do |step|
          case @map[@pos.row, @pos.col + 1]
          when 0
            @width.times do |x|
              case @map[@pos.row, x + 1]
              when 1
                @pos.col = x + 1
                break
              when 2
                break
              end
            end
          when 1
            @pos.col += 1
          when 2
            break
          end
        end
      when 'v'
        inst.times do
          case @map[@pos.row + 1, @pos.col]
          when 0
            @height.times do |y|
              case @map[y + 1, @pos.col]
              when 1
                @pos.row = y + 1
                break
              when 2
                break
              end
            end
          when 1
            @pos.row += 1
          when 2
            break
          end
        end
      when '<'
        inst.times do
          case @map[@pos.row, @pos.col - 1]
          when 0
            @width.times do |x|
              case @map[@pos.row, @width - 1 - x]
              when 1
                @pos.col = @width - 1 - x
                break
              when 2
                break
              end
            end
          when 1
            @pos.col -= 1
          when 2
            break
          end
        end
      when '^'
        inst.times do
          case @map[@pos.row - 1, @pos.col]
          when 0
            @height.times do |y|
              case @map[@height - 1 - y, @pos.col]
              when 1
                @pos.row = @height - 1 - y
                break
              when 2
                break
              end
            end
          when 1
            @pos.row -= 1
          when 2
            break
          end
        end
      end
    end
  end

  def solve!
    until @instructions.empty? do
      step!
    end
  end

  def password
    @pos.row * 1_000 +
      @pos.col * 4 +
      ['>', 'v', '<', '^'].index(@dir)
  end

  def to_s
    s = "<#{self.class}:\n"
    s += "Position: #{@pos}\n"
    @height.times do |row|
      @width.times do |col|
        s += if row == @pos.row and col == @pos.col
               @dir
             else
               case @map[row, col]
               when 0
                 ' '
               when 1
                 '.'
               when 2
                 '#'
               end
             end
      end
      s += "\n"
    end
    s += @instructions.to_s
    s += '>'
    s
  end

  alias inspect to_s
end

input = File.read('22.input').lines.map(&:rstrip)

map = Map.new(input)

map.solve!

print map.password, "\n"
