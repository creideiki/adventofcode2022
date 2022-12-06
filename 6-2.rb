#!/usr/bin/env ruby

require 'set'

buffers = File.read('6.input').lines.map(&:strip)
buffers.each do |buf|
  buf.chars.each_index do |pos|
    next if pos < 13

    unique = buf[pos - 13..pos].chars.map { |s| Set.new(s.chars) }.reduce(&:|)
    if unique.size == 14
      print pos + 1, "\n"
      break
    end
  end
end
