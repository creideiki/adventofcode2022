#!/usr/bin/env ruby

def compare(p1, p2)
  left = p1[0]
  right = p2[0]

  return 0 if left.nil? and right.nil?
  return -1 if left.nil?
  return 1 if right.nil?

  if left.is_a? Integer and right.is_a? Integer
    if left == right
      compare(p1[1..], p2[1..])
    elsif left < right
      -1
    else
      1
    end
  elsif left.is_a? Array and right.is_a? Array
    case compare(left, right)
    when 0
      compare(p1[1..], p2[1..])
    when -1
      -1
    when 1
      1
    end
  elsif left.is_a? Integer
    case compare([left], right)
    when 0
      compare(p1[1..], p2[1..])
    when -1
      -1
    when 1
      1
    end
  elsif right.is_a? Integer
    case compare(left, [right])
    when 0
      compare(p1[1..], p2[1..])
    when -1
      -1
    when 1
      1
    end
  else
    raise "Type error: #{left}, #{right}"
  end
end

dividers = [[[2]], [[6]]]

input = File.read('13.input').lines.map(&:strip).map { |l| eval(l) }
input.reject! &:nil?
input += dividers

input.sort! { |a, b| compare(a, b) }

print dividers.map { |d| input.index(d) + 1 }.reduce(:*), "\n"
