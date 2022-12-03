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

print File.read('3.input').lines.map(&:strip).
        map { |r| [r[.. r.length / 2 - 1], r[r.length / 2 ..]] }.
        map { |r| Set.new(r[0].chars) & Set.new(r[1].chars) }.
        map(&:to_a).
        map { |duplicate| priority(duplicate[0]) }.
        reduce(:+)
print "\n"
