#!/usr/bin/env ruby

class Directory
  attr_accessor :dirs, :files, :parent

  def initialize(parent, name)
    @parent = parent
    @name = name
    @dirs = {}
    @files = {}
    @size = -1
  end

  def size
    if @size == -1
      @size = (@dirs.values.map(&:size).reduce(:+) or 0) +
              (@files.values.reduce(:+) or 0)
    end
    @size
  end

  def include?
    size <= 100_000
  end

  def to_s
    s = "<#{self.class}: #{@name} #{size}\n"
    s += "Subdirectories:\n"
    @dirs.each { |name, _| s += name + "\n" }
    s += "Files:\n"
    @files.each { |name, size| s += name + ": " + size.to_s + "\n" }
    s += ">"
  end

  def inspect
    to_s
  end
end

cd_format = /^\$ cd (?<dir>[[:alnum:][:punct:]]+)$/
ls_format = /^\$ ls$/
dir_list_format = /^dir (?<name>[[:alnum:]]+)$/
file_list_format = /^(?<size>[[:digit:]]+) (?<name>[[:alnum:][:punct:]]+)$/

root = Directory.new(nil, '/')

input = File.read('7.input').lines.map(&:strip)

cwd = root

input.each do |line|
  if (match = cd_format.match line)
    cwd = case match['dir']
          when '/'
            root
          when '..'
            cwd.parent
          else
            cwd.dirs[match['dir']]
          end
  elsif ls_format.match line
    next
  elsif (match = dir_list_format.match line)
    cwd.dirs[match['name']] = Directory.new(cwd, match['name'])
  elsif (match = file_list_format.match line)
    cwd.files[match['name']] = match['size'].to_i
  end
end

counted = []

to_check = [root]

while (cwd = to_check.pop)
  counted.append(cwd) if cwd.include?

  to_check.concat cwd.dirs.values
end

print counted.map(&:size).reduce(:+), "\n"
