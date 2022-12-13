#!/usr/bin/env ruby

def compare(p1, p2)
  left = p1.shift
  right = p2.shift

  return :equal if left.nil? and right.nil?
  return :less if left.nil?
  return :greater if right.nil?

  if left.is_a? Integer and right.is_a? Integer
    if left == right
      compare(p1, p2)
    elsif left < right
      :less
    else
      :greater
    end
  elsif left.is_a? Array and right.is_a? Array
    case compare(left, right)
    when :equal
      compare(p1, p2)
    when :less
      :less
    when :greater
      :greater
    end
  elsif left.is_a? Integer
    case compare([left], right)
    when :equal
      compare(p1, p2)
    when :less
      :less
    when :greater
      :greater
    end
  elsif right.is_a? Integer
    case compare(left, [right])
    when :equal
      compare(p1, p2)
    when :less
      :less
    when :greater
      :greater
    end
  else
    raise "Type error: #{left}, #{right}"
  end
end

input = File.read('13.input').lines.map(&:strip)

score = 0
index = 0

until input.empty?
  index += 1
  p1 = eval(input.shift)
  p2 = eval(input.shift)

  score += index if compare(p1, p2) == :less

  input.shift if input[0] == ''
end

print score, "\n"
