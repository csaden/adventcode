require 'set'

file = File.open("./day03_input.txt")
data = file.readlines.map(&:chomp)
file.close


def get_priority(char)
  return char.ord - 96 if char >= 'a' && char <= 'z'
  char.ord - 38
end

def get_duplicate(compartment)
  i = (compartment.length / 2) - 1
  items = compartment[..i]
  items_hash = items.split('').zip([true]*items.length).to_h

  other_items = compartment[i+1..]

  other_items.split('').find { |item| items_hash.key?(item) }
end

def sum_priorities(lines)
  total = 0
  lines.each do |line|
    item = get_duplicate(line)
    total += get_priority(item)
  end
  total
end

puts sum_priorities(data)

def get_common_badge(bag1, bag2, bag3)
  badges1 = Set.new(bag1.split(''))
  badges2 = Set.new(bag2.split(''))
  badges3 = Set.new(bag3.split(''))

  return (badges1 & badges2 & badges3).to_a.first
end

def sum_badge_priorities(lines)
  total = 0
  lines.each_slice(3) do |group|
    badge = get_common_badge(*group)
    total += get_priority(badge)
  end
  total
end

puts sum_badge_priorities(data)
