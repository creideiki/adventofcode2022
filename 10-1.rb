#!/usr/bin/env ruby

class CPU
  attr_accessor :cycle, :strength, :x

  def initialize
    @x = 1
    @cycle = 0
    @strength = 0
    @next_sample = 20
  end

  def advance_timer(cycles)
    if @cycle + cycles >= @next_sample
      @strength += @next_sample * @x
      @next_sample += 40
    end
    @cycle += cycles
  end

  def addx(v)
    advance_timer 2
    @x += v
  end

  def noop(_)
    advance_timer 1
  end

  def to_s
    "<#{self.class}: X: #{@x}, cycle: #{@cycle}, strength: #{@strength}>"
  end
end

instructions = File.read('10.input').lines.map(&:strip)

instruction_format = /(?<inst>addx|noop) ?(?<oper>-?[[:digit:]]+)?/

cpu = CPU.new

instructions.each do |insn|
  instruction_format.match(insn) { |m| cpu.send(m['inst'], m['oper'].to_i) }
end

print cpu.strength, "\n"
