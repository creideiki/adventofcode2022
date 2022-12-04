#!/usr/bin/env ruby

assignments = File.read('4.input').lines.map(&:strip)
                .map { |s| s.split(',').map { |a| a.split('-').map(&:to_i) } }
overlap = assignments.map do |a|
  not ((a[0][1] < a[1][0]) or
       (a[0][0] > a[1][1]))
end
print overlap.count { |a| a }, "\n"
