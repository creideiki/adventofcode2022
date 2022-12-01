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

_, max = elf_calories.max_by { |_, c| c }

print max, "\n"
