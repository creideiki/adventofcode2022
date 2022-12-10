#!/usr/bin/env ruby

require 'numo/narray'

class CPU
  attr_accessor :cycle, :strength, :x

  def initialize
    @x = 1
    @cycle = 0
    @crt = Numo::Bit.new(6, 40).fill 0
  end

  def advance_timer(cycles)
    cycles.times do
      beam_row = @cycle / 40
      beam_col = @cycle % 40
      @crt[beam_row, beam_col] = 1 if (beam_col - @x).abs <= 1
      @cycle += 1
    end
  end

  def display
    s = ''
    @crt.shape[0].times do |row|
      @crt.shape[1].times do |col|
        s += @crt[row, col] == 1 ? '#' : '.'
      end
      s += "\n"
    end
    s
  end

  def addx(v)
    advance_timer 2
    @x += v
  end

  def noop(_)
    advance_timer 1
  end

  def to_s
    s = "<#{self.class}: X: #{@x}, cycle: #{@cycle}\n"
    s += @crt.inspect
    s += "\n>"
  end
end

instructions = File.read('10.input').lines.map(&:strip)

instruction_format = /(?<inst>addx|noop) ?(?<oper>-?[[:digit:]]+)?/

cpu = CPU.new

instructions.each do |insn|
  instruction_format.match(insn) { |m| cpu.send(m['inst'], m['oper'].to_i) }
end

print cpu.display
