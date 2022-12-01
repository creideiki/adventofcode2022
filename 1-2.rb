#!/usr/bin/env ruby

values = File.read('1.input').lines.map(&:to_i)

elf_calories = Hash.new 0

elf = 0
values.each do |v|
  if v.zero?
    elf += 1
  else
    elf_calories[elf] += v
  end
end

sorted = elf_calories.sort_by { |_, c| c }

print sorted[-3..].map { |a| a[1] }.sum, "\n"
