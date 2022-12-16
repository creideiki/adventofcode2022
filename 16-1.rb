#!/usr/bin/env ruby

class Path
  attr_accessor :pos, :map, :steps, :flow, :opened, :path

  def initialize(pos, steps, map)
    @pos = pos
    @map = map
    @steps = steps
    @flow = 0
    @opened = []
    @path = []
  end

  def initialize_copy(other)
    @pos = other.pos
    @map = other.map
    @steps = other.steps
    @flow = other.flow
    @opened = other.opened.dup
    @path = other.path.dup
  end

  def move(valve)
    step
    @path << valve
  end

  def open?(valve)
    @opened.include? valve
  end

  def open(valve)
    step
    @path << :open
    @opened << valve
  end

  def stay
    step
    @path << :stay
  end

  def next_flow
    @opened.map { |valve| @map[valve][0] }.reduce(@flow, &:+)
  end

  def step
    @steps += 1
    @flow = next_flow
  end

  def to_s
    "<#{self.class} #{@pos}: after #{@steps} steps, flow #{@flow}, open: #{@opened}, path: #{path}>"
  end

  alias inspect to_s
end

class Map
  def initialize(input)
    valve_regexp = /^Valve (?<valve>[A-Z]{2}) has flow rate=(?<rate>[[:digit:]]+); tunnels? leads? to valves? (?<exits>[A-Z, ]+)$/

    @map = {}
    @valves = []
    @paths = {}
    input.each do |i|
      m = valve_regexp.match i
      valve = [m['rate'].to_i, m['exits'].split(', ')]
      @map[m['valve']] = valve
      @valves << m['valve']
    end
  end

  def step!
    new_paths = {}
    @valves.each do |valve|
      this_path = @paths[valve]
      next unless this_path

      neighbours = @map[valve][1]
      neighbours.each do |n|
        n_path = @paths[n]
        if not n_path or
           this_path.next_flow > n_path.next_flow
          n_path = @paths[valve].dup
          n_path.pos = n
          n_path.move n
        end
        new_paths[n] = n_path
      end
      if this_path.open?(valve) or @map[valve][0] == 0
        this_path.stay
      else
        this_path.open(valve)
      end
      new_paths[valve] = this_path
    end
    @paths = new_paths
  end

  def solve!
    @paths = { 'AA' => Path.new('AA', 0, @map) }
    30.times do |step|
      self.step!
      print self
    end
  end

  def to_s
    s = "<#{self.class}:\n"
    s += "Map:\n"
    @map.each_pair do |valve, data|
      s += "#{valve}: #{data[0]}, #{data[1]}\n"
    end
    s += "Paths:\n"
    @paths.each_value do |path|
      s += path.to_s + "\n"
    end
    s += '>'
    s
  end

  alias inspect to_s
end

input = File.read('16.sample').lines.map(&:strip)

map = Map.new(input)

map.solve!

# map.paths = { 'AA' => Path.new('AA', map.map) }
