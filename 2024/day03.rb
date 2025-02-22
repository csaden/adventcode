# Use regular expression matching to find patterns where "mul(12,34)" exist
# where mul stands for multiple, followed by an opening paren, followed by a 1-3 digit number,
# followed by a comma, followed by another 1-3 digit number, followed by a closing paren
# Compute the multiplications and add their sum
class Day3Part1
  def initialize
    @sum = 0
  end

  def call
    filename = File.join(File.dirname(__FILE__), 'day03_input.txt')

    text = ''
    IO.foreach(filename) do |line|
      text += line
    end
    matches = find_matches(text:)
    @sum += matches.inject(0) do |result, match|
      result + match[0].to_i * match[1].to_i
    end

    puts "sum: #{@sum}"
  end

  private

  def find_matches(text:)
    text.scan(/mul\((\d{1,3}),(\d{1,3})\)/)
  end
end

Day3Part1.new.call

# Match start of string before "do" and "don't"
# Match text between "do" and "don't" word boundaries
# Match text at end of string after last "do"
# Run original find_matches to get multiple commands
class Day3Part2
  def initialize
    @sum = 0
    @enabled = true
  end

  def call
    filename = File.join(File.dirname(__FILE__), 'day03_input.txt')
    text = ''
    IO.foreach(filename) do |line|
      text += line
    end
    find_do_matches(text:)

    puts "sum: #{@sum}"
  end

  private

  def find_do_matches(text:)
    matches = text.scan(/(mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\))/)
    matches.each do |match|
      puts match.join(',')
    end
    @sum += matches.inject(0) do |result, match|
      result += if match[0] == 'do()'
                  @enabled = true
                  0
                elsif match[0] == 'don\'t()'
                  @enabled = false
                  0
                elsif @enabled
                  match[1].to_i * match[2].to_i
                else
                  0
                end

      result
    end
  end
end

Day3Part2.new.call
