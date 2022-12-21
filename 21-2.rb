#!/usr/bin/env ruby

$monkeys = {}

class IsHuman < ::StandardError
end

class Monkey
  def initialize(name, operation)
    number_format = /^(?<num>[[:digit:]]+)$/
    calc_format = /^(?<m1>[[:alpha:]]+) (?<op>[-+*\/=]) (?<m2>[[:alpha:]]+)$/

    @operation = operation
    @name = name
    @value = nil

    if m = number_format.match(@operation)
      @value = m['num'].to_i
    else
      m = calc_format.match(@operation)
      @m1 = m['m1']
      @op = m['op']
      @op = '==' if @name == 'root'
      @m2 = m['m2']
    end
  end

  def value
    raise IsHuman if setting? and @name == 'humn'
    return @value if @value

    @value = $monkeys[@m1].value.send(@op, $monkeys[@m2].value)
  end

  def set_equal!(value)
    if @name == 'humn'
      @value = value
      return
    end

    begin
      left = $monkeys[@m1].value
    rescue IsHuman
      left = nil
    end
    begin
      right = $monkeys[@m2].value
    rescue IsHuman
      right = nil
    end

    case @op
    when '=='
      $monkeys[@m1].set_equal!(right) if right
      $monkeys[@m2].set_equal!(left) if left
    when '+'
      $monkeys[@m1].set_equal!(value - right) if right
      $monkeys[@m2].set_equal!(value - left) if left
    when '-'
      $monkeys[@m1].set_equal!(value + right) if right
      $monkeys[@m2].set_equal!(left - value) if left
    when '*'
      $monkeys[@m1].set_equal!(value / right) if right
      $monkeys[@m2].set_equal!(value / left) if left
    when '/'
      $monkeys[@m1].set_equal!(value * right) if right
      $monkeys[@m2].set_equal!(left / value) if left
    end
  end

  def to_s
    "<#{self.class}: #{@name} = #{@operation} (#{@value})>"
  end

  alias inspect to_s

  def self.setting=(maybe)
    @@setting = maybe
  end

  def self.setting
    @@setting ||= false
  end

  private

  def setting?
    self.class.setting
  end
end


input = File.read('21.input').lines

monkey_format = /^(?<name>[[:alpha:]]+): (?<op>.*)$/

input.each do |line|
  m = monkey_format.match line
  $monkeys[m['name']] = Monkey.new(m['name'], m['op'])
end

Monkey.setting = true
$monkeys['root'].set_equal! nil
Monkey.setting = false
print $monkeys['humn'].value, "\n"
