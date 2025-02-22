file = File.open("./day04_input.txt")
data = file.readlines.map(&:chomp)
file.close

class Range
  attr_reader :start, :ending

  def initialize(start, ending)
    @start = start
    @ending = ending
  end

  def contains?(range)
    smaller = @start >= range.start && @ending <= range.ending
    bigger = @start <= range.start && @ending >= range.ending
    smaller || bigger
  end

  def overlaps?(range)
    left_range, other = @start <= range.start ? [self, range] : [range, self]
    other.start <= left_range.ending
  end
end

def find_overlaps(assignments)
  total_contains = 0
  total_overlaps = 0
  assignments.each do |assigment|
    r1, r2 = *assigment.split(',')
    puts r1, r2
    start, ending = *r1.split('-').map(&:to_i)
    range1 = Range.new(start, ending)
    start, ending = *r2.split('-').map(&:to_i)
    range2 = Range.new(start, ending)
    total_contains += range1.contains?(range2) ? 1 : 0
    total_overlaps += range1.overlaps?(range2) ? 1 : 0
  end
  puts 'Total intervals contained', total_contains
  puts 'Total intervals overlapping', total_overlaps
end

puts find_overlaps(data)
