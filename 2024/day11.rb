require './utils'
# Blink per stone to track stones generated according to blink rules
# Add caching to speed up the calculation
class Day11
  def initialize
    @cache = Hash.new { |h, key| h[key] = Hash.new(0) }
  end

  def call
    elapsed = measure_time do
      part1 = blinks(input, 25)
      puts "Part1: #{part1}"
    end
    puts elapsed

    elapsed = measure_time do
      part2 = blinks_cached(input, 75)
      puts "Part2: #{part2}"
    end
    puts elapsed
  end

  private

  def blinks_cached(stones, count)
    total = 0
    stones.each do |stone|
      total += blink_cached(stone, count)
    end

    total
  end

  def blink_cached(stone, count)
    return 1 if count.zero?

    return @cache[stone][count] if @cache[stone][count] != 0

    if stone.zero?
      stones = blink_cached(1, count - 1)
    elsif (stone.to_s.length % 2).zero?
      stone_str = stone.to_s
      left = stone_str[0...stone_str.length / 2].to_i
      right = stone_str[stone_str.length / 2..].to_i
      stones = blink_cached(left, count - 1) + blink_cached(right, count - 1)
    else
      stones = blink_cached(stone * 2024, count - 1)
    end

    @cache[stone][count] = stones
    stones
  end

  def blinks(stones, count)
    total = 0

    stones.each do |stone|
      total += blinks_per_stone([stone], count)
    end

    total
  end

  def blinks_per_stone(stones, count)
    while count >= 1
      stones = blink(stones)
      count -= 1
    end

    stones.length
  end

  def blink(stones)
    output = []

    stones.each do |stone|
      if stone.zero?
        output << 1
      elsif (stone.to_s.length % 2).zero?
        left = stone.to_s[0...stone.to_s.length / 2].to_i
        right = stone.to_s[stone.to_s.length / 2..].to_i
        output << left
        output << right
      else
        output << stone * 2024
      end
    end

    output
  end

  def test2_input
    # 55312 stones after 25 blinks
    '125 17'.split(' ').map(&:to_i)
  end

  def test_input
    # 7 stones after 1 blink
    # output after 1 blink 1 2024 1 0 9 9 2021976
    '0 1 10 99 999'.split(' ').map(&:to_i)
  end

  def input
    '0 27 5409930 828979 4471 3 68524 170'.split(' ').map(&:to_i)
  end
end

Day11.new.call
