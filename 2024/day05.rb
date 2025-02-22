# check if any page orderings violate the rules of one page X appearing before another page Y
# rules are in the format "X|Y"
# updates are in the format "\d,\d,\d,\d,\d"
class Day5
  def initialize
    @ordering = {}
    @updates = []
    @invalids = []
    @sum = 0
    @reorder_sum = 0
    parse_input
  end

  def call
    check_updates
    puts "sum of middle pages #{@sum}"
    check_invalids
    puts "sum of reordered pages #{@reorder_sum}"
  end

  private

  def parse_input
    filename = File.join(File.dirname(__FILE__), 'day05_input.txt')
    IO.foreach(filename) do |line|
      if line.strip.include?('|')
        parse_rule(line:)
      elsif line.include?(',')
        @updates << line.split(',').map(&:to_i)
      end
    end
  end

  def parse_rule(line:)
    before, after = line.split('|')
    if @ordering.key?(before)
      pages = @ordering[before]
      pages.add(after.to_i)
    else
      @ordering[before.to_s] = Set.new([after.to_i])
    end
  end

  def check(update:, for_invalid: false)
    i = update.length - 1
    while i.positive?
      after = update[i].to_s
      (i - 1).downto(0) do |index|
        before = update[index]
        if @ordering[after]&.include?(before)
          @invalids << update if for_invalid
          return false, [before, after.to_i]
        end
      end

      i -= 1
    end

    [true, []]
  end

  def check_updates
    @updates.each do |update|
      valid, = check(update:, for_invalid: true)
      @sum += middle_value(update:) if valid
    end
  end

  def check_invalids
    @invalids.each do |invalid|
      update = reorder(update: invalid)
      @reorder_sum += middle_value(update:)
    end
  end

  def reorder(update:)
    attempt = update.dup
    valid, swaps = check(update: attempt)
    until valid
      before, after = swaps
      attempt = swap(update: attempt, before:, after:)
      valid, swaps = check(update: attempt.dup)
    end

    attempt
  end

  def swap(update:, before:, after:)
    before_index = update.find_index(before)
    after_index = update.find_index(after)
    update[before_index], update[after_index] = update[after_index], update[before_index]
    update.dup
  end

  def middle_value(update:)
    update[(update.length - 1) / 2].to_i
  end
end

Day5.new.call
