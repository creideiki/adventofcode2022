#!/usr/bin/env ruby

require 'set'

def priority(item)
  case item
  when 'a'..'z'
    item.ord - 96
  when 'A'..'Z'
    item.ord - 64 + 26
  end
end

p = 0
File.read('3.input').lines.map(&:strip).each_slice(3) do |group|
  badge = Set.new(group[0].chars) &
          Set.new(group[1].chars) &
          Set.new(group[2].chars)
  p += priority(badge.to_a[0])
end
print p, "\n"
