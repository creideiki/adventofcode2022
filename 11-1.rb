#!/usr/bin/env ruby

class Monkey
  attr_accessor :business, :dest_false, :dest_true, :divisor, :items, :number, :operation

  def initialize(number)
    @business = 0
    @dest_false = nil
    @dest_true = nil
    @divisor = nil
    @items = nil
    @number = number
    @operation = nil
  end

  def to_s
    "<#{self.class} #{@number}: business: #{@business}, items: #{@items}, op: #{@operation}, div: #{@divisor}, true: #{@dest_true}, false: #{@dest_false}>"
  end

  alias inspect to_s
end

lines = File.read('11.input').lines.map(&:strip)

monkeys = []

current = nil

lines.each do |line|
  if (m = /^Monkey (?<num>[[:digit:]]+):$/.match(line))
    current = Monkey.new(m['num'].to_i)
    monkeys[m['num'].to_i] = current
  elsif (m = /^Starting items: (?<items>[[:digit:], ]+)$/.match(line))
    current.items = m['items'].split(', ').map(&:to_i)
  elsif (m = /^Operation: (?<oper>.+)$/.match(line))
    current.operation = m['oper']
  elsif (m = /^Test: divisible by (?<div>[[:digit:]]+)$/.match(line))
    current.divisor = m['div'].to_i
  elsif (m = /^If true: throw to monkey (?<target>[[:digit:]]+)$/.match(line))
    current.dest_true = m['target'].to_i
  elsif (m = /^If false: throw to monkey (?<target>[[:digit:]]+)$/.match(line))
    current.dest_false = m['target'].to_i
  end
end

20.times do |round|
  monkeys.each do |m|
    m.items.each do |item|
      m.business += 1
      bind = binding
      bind.local_variable_set(:old, item)
      item = eval(m.operation, bind)
      item /= 3
      dest = (item % m.divisor).zero? ? m.dest_true : m.dest_false
      monkeys[dest].items.append item
    end
    m.items = []
  end
end

monkeys.sort_by!(&:business)

print monkeys[-1].business * monkeys[-2].business, "\n"
