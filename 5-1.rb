#!/usr/bin/env ruby

class Ship
  def initialize(stacks, last_stack)
    @num_stacks = last_stack + 1
    @ship = []
    @num_stacks.times { |_| @ship.append [] }

    stacks.each do |level|
      stack = 0
      level.chars.each_slice(4) do |slot|
        stack += 1
        crate = slot[1]
        next if crate == ' '

        @ship[stack].push crate
      end
    end
    @ship.map(&:reverse!)
  end

  def move(num, from, to)
    num.times do |_|
      @ship[to].push @ship[from].pop
    end
  end

  def result
    @ship.map { |stack| stack.last or '' }.reduce(:+)
  end

  def to_s
    s = "<#{self.class}:\n"
    ship.each_with_index do |stack, i|
      next if i.zero?

      s += i.to_s + ": " + stack.to_s + "\n"
    end
    s += ">"
  end

  def inspect
    to_s
  end
end

stack_format = /\[/
number_format = /^(( [[:digit:]]+ ) )+( [[:digit:]]+ )$/
move_format = /^move (?<num>[[:digit:]]+) from (?<from>[[:digit:]]+) to (?<to>[[:digit:]]+)$/

input = File.read('5.input').lines

ship = nil
stacks = []
last_stack = 0

input.each do |line|
  if stack_format.match line
    stacks.append line
  elsif number_format.match line
    last_stack = line.split[-1].to_i
    ship = Ship.new(stacks, last_stack)
  elsif (move = move_format.match line.strip)
    ship.move(move['num'].to_i, move['from'].to_i, move['to'].to_i)
  elsif line == "\n"
  end
end

print ship.result, "\n"
