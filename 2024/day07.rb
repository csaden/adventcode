class Day7
  def initialize
    @sum = 0
    @concat_sum = 0
  end

  def call
    parse_input
    puts "sum #{@sum}"
    puts "concat sum #{@concat_sum}"
    puts "total #{@sum + @concat_sum}"
  end

  private

  def parse_input
    filename = File.join(File.dirname(__FILE__), 'day07_input.txt')
    IO.foreach(filename) do |line|
      # parse test_value (target) and sequence of numbers
      test_value, numbers = line.strip.split(':')
      target = test_value.strip.to_i
      sequence = numbers.split(' ').map(&:strip).map(&:to_i)

      # check add/multiply sequence to target value
      valid = math(target, sequence[0], sequence[1..])
      if valid
        @sum += target if valid
        # puts "*+ for #{target}" if valid
      else
        # check add/multiply/concatenate to target value
        valid = math_concat(target, sequence[0], sequence[1..])
        @concat_sum += target if valid
        # puts "||*+ for #{target}" if valid
      end
    end
  end

  def math(target, current, seq)
    return false if current > target
    return target == current if seq.empty?

    math(target, current + seq[0], seq[1..]) ||
      math(target, (current || 1) * seq[0], seq[1..])
  end

  def math_concat(target, current, seq)
    return false if current > target
    return target == current if seq.empty?

    math_concat(target, current + seq[0], seq[1..]) ||
      math_concat(target, current * seq[0], seq[1..]) ||
      math_concat(target, concatenate(current, seq), seq[1..])
  end

  def concatenate(current, seq)
    (current.to_s + seq[0].to_s).to_i
  end
end

Day7.new.call
