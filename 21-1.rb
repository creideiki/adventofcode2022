#!/usr/bin/env ruby

$monkeys = {}

class Monkey
  def initialize(name, operation)
    number_format = /^(?<num>[[:digit:]]+)$/
    calc_format = /^(?<m1>[[:alpha:]]+) (?<op>[-+*\/]) (?<m2>[[:alpha:]]+)$/

    @operation = operation
    @name = name
    @value = nil

    if m = number_format.match(@operation)
      @value = m['num'].to_i
    else
      m = calc_format.match(@operation)
      @m1 = m['m1']
      @op = m['op']
      @m2 = m['m2']
    end
  end

  def value
    return @value if @value

    @value = $monkeys[@m1].value.send(@op, $monkeys[@m2].value)
  end

  def to_s
    "<#{self.class}: #{@name} = #{@operation} (#{@value})>"
  end

  alias inspect to_s
end


input = File.read('21.input').lines

monkey_format = /^(?<name>[[:alpha:]]+): (?<op>.*)$/

input.each do |line|
  m = monkey_format.match line
  $monkeys[m['name']] = Monkey.new(m['name'], m['op'])
end

print $monkeys['root'].value, "\n"
