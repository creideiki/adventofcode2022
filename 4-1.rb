#!/usr/bin/env ruby

assignments = File.read('4.input').lines.map(&:strip)
                .map { |s| s.split(',').map { |a| a.split('-').map(&:to_i) } }
overlap = assignments.map do |a|
  (a[0][0] <= a[1][0] and a[0][1] >= a[1][1]) or
    (a[1][0] <= a[0][0] and a[1][1] >= a[0][1])
end
print overlap.count { |a| a }, "\n"
