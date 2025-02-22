# Part 1 approach
# subtraction and addition are commutative so...ARGF
# keep a running sum for the items in list1 and list2
# diff sum list1 and list2
class Day1Part1
  def initialize
    @list1 = []
    @list2 = []
    parse_input
  end

  def call
    answer = total_distance
    puts answer
  end

  private

  def parse_input
    filename = File.join(File.dirname(__FILE__), 'day01_input.txt')

    IO.foreach(filename, chomp: true).with_index do |line, _index|
      entries = line.split(' ')
      @list1 << entries[0].to_i
      @list2 << entries[1].to_i
    end

    @list1.sort!
    @list2.sort!
  end

  def total_distance
    distance = 0
    @list1.each_with_index do |num, index|
      distance += (num - @list2[index]).abs
    end

    distance
  end
end

Day1Part1.new.call

# Part2 approach
# track frequencies of location ids in list2
# for each location id in the list multiple by its frequency and sum the results
class Day1Part2
  def initialize
    @frequencies = Hash.new(0)
    @list = []
    @similarity_score = 0
    parse_input
  end

  def call
    answer = similarity
    puts answer
  end

  def similarity
    @list.each do |num|
      @similarity_score += num * @frequencies.fetch(num, 0)
    end

    @similarity_score
  end

  def parse_input
    filename = File.join(File.dirname(__FILE__), 'day01_input.txt')

    IO.foreach(filename, chomp: true).with_index do |line, _index|
      entries = line.split(' ')
      @list << entries[0].to_i
      number = entries[1].to_i
      @frequencies[number] += 1
    end
  end
end

Day1Part2.new.call
