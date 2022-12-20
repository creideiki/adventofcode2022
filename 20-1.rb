#!/usr/bin/env ruby

class Linked_List
  class Linked_Number
    attr_accessor :value, :pos, :back, :forward

    def initialize(value, pos, back, forward)
      @value = value
      @pos = pos
      @back = back
      @forward = forward
    end

    def to_s
      "<#{self.class}: number #{@value}, original #{@pos}, next #{@forward&.value}, previous #{@back&.value}>"
    end

    alias inspect to_s
  end

  def initialize(elements)
    @size = elements.size
    @elements = Array.new @size

    back = nil
    forward = nil
    elements.each_with_index do |n, value|
      num = Linked_Number.new(n, value, back, forward)
      back.forward = num if back
      back = num
      @elements[value] = num
    end
    @elements[0].back = @elements[-1]
    @elements[-1].forward = @elements[0]
  end

  def unlink!(number)
    back = number.back
    forward = number.forward

    back.forward = forward
    number.back = nil

    forward.back = back
    number.forward = nil

    number
  end

  def link!(number, back, forward)
    back.forward = number
    number.back = back

    forward.back = number
    number.forward = forward
  end

  def size
    @size
  end

  def to_s
    cur = @elements[0]
    s = ''
    loop do
      s += cur.value.to_s
      s += ', '
      cur = cur.forward
      break if cur == @elements[0]
    end
    s
  end

  attr_accessor :elements
end

input = File.read('20.input').lines.map(&:strip).map(&:to_i)

numbers = Linked_List.new(input)

numbers.size.times do |round|
  num = numbers.elements.find { |num| num.pos == round }
  next if (num.value % (numbers.size - 1)).zero?

  back = num.back

  old = numbers.unlink!(num)
  num = back

  if old.value.positive?
    (old.value % (numbers.size - 1)).times do
      num = num.forward
    end
  else
    (old.value.abs % (numbers.size - 1)).times do
      num = num.back
    end
  end

  forward = num.forward
  numbers.link!(old, num, forward)
end

num = numbers.elements.find { |num| num.value.zero? }

sum = 0
3.times do
  1_000.times do
    num = num.forward
  end
  sum += num.value
end
print sum, "\n"
