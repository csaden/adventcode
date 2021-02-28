# --- Day 7: Handy Haversacks ---
# You land at the regional airport in time for your next flight.
# In fact, it looks like you'll even have time to grab some food:
# all flights are currently delayed due to issues in luggage processing.

# Due to recent aviation regulations, many rules (your puzzle input) are being enforced
# about bags and their contents; bags must be color-coded and must contain specific
# quantities of other color-coded bags. Apparently, nobody responsible for these
# regulations considered how long they would take to enforce!

# For example, consider the following rules:

# light red bags contain 1 bright white bag, 2 muted yellow bags.
# dark orange bags contain 3 bright white bags, 4 muted yellow bags.
# bright white bags contain 1 shiny gold bag.
# muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
# shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
# dark olive bags contain 3 faded blue bags, 4 dotted black bags.
# vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
# faded blue bags contain no other bags.
# dotted black bags contain no other bags.

# These rules specify the required contents for 9 bag types.
# In this example, every faded blue bag is empty, every vibrant plum bag contains 11 bags
# (5 faded blue and 6 dotted black), and so on.

# You have a shiny gold bag. If you wanted to carry it in at least one other bag,
# how many different bag colors would be valid for the outermost bag?
# (In other words: how many colors can, eventually, contain at least one shiny gold bag?)

# In the above rules, the following options would be available to you:

# A bright white bag, which can hold your shiny gold bag directly.
# A muted yellow bag, which can hold your shiny gold bag directly, plus some other bags.
# A dark orange bag, which can hold bright white and muted yellow bags,
# either of which could then hold your shiny gold bag.
# A light red bag, which can hold bright white and muted yellow bags,
# either of which could then hold your shiny gold bag.

# So, in this example, the number of bag colors that can eventually
# contain at least one shiny gold bag is 4.

# How many bag colors can eventually contain at least one shiny gold bag?
# (The list of rules is quite long; make sure you get all of it.)

# --- Part Two ---
# It's getting pretty expensive to fly these days - not because of ticket prices,
# but because of the ridiculous number of bags you need to buy!

# Consider again your shiny gold bag and the rules from the above example:

# faded blue bags contain 0 other bags.
# dotted black bags contain 0 other bags.
# vibrant plum bags contain 11 other bags: 5 faded blue bags and 6 dotted black bags.
# dark olive bags contain 7 other bags: 3 faded blue bags and 4 dotted black bags.

# So, a single shiny gold bag must contain 1 dark olive bag (and the 7 bags within it)
# plus 2 vibrant plum bags (and the 11 bags within each of those): 1 + 1*7 + 2 + 2*11 = 32 bags!

# Of course, the actual rules have a small chance of going several levels deeper than this example;
# be sure to count all of the bags, even if the nesting becomes topologically impractical!

# Here's another example:

# shiny gold bags contain 2 dark red bags.
# dark red bags contain 2 dark orange bags.
# dark orange bags contain 2 dark yellow bags.
# dark yellow bags contain 2 dark green bags.
# dark green bags contain 2 dark blue bags.
# dark blue bags contain 2 dark violet bags.
# dark violet bags contain no other bags.

# In this example, a single shiny gold bag must contain 126 other bags.

# How many individual bags are required inside your single shiny gold bag?



import re
from utils import read_file


BAG_COLOR_REGEX = r'[0-9]+\s+(.*?)\s+bag'
SHINY_GOLD = 'shiny gold'
NO_OTHER_BAGS = 'no other bags.'

def process_bag_colors(lines):
  bag_colors = dict()
  start_colors = []

  for line in lines:
    [outer_bag, inside_bags] = line.split('contain')
    outer_bag_color = outer_bag.replace(' bags ', '')
    inside_bag_colors = set(re.findall(BAG_COLOR_REGEX, inside_bags))

    if len(inside_bag_colors) > 0:
      bag_colors[outer_bag_color] = inside_bag_colors

    if SHINY_GOLD in inside_bag_colors:
      start_colors.append(outer_bag_color)

  return bag_colors, start_colors

def count_bags_holding_color(bag_colors, start_colors):
  count = len(start_colors)
  outer_bag_colors = set(start_colors)
  while len(start_colors) > 0:
    new_colors = []
    for color in start_colors:
      for outer_bag, holding_bags in bag_colors.items():
        if color in holding_bags:
          outer_bag_colors.add(outer_bag)
          new_colors.append(outer_bag)
    start_colors = new_colors

  return len(outer_bag_colors)

def bag_color_count(line, parent_count):
  num, kind, color, _ = line.split(' ')
  return [f'{kind} {color}', int(num) * parent_count]

def count_bags_inside(lines, bag_color):
  tree = [[bag_color, 1]]
  count = 1
  while len(tree) > 0:
    search_bag, num = tree.pop(0)
    bag_line = [line for line in lines if line.startswith(search_bag)]
    if bag_line:
      contains = map(lambda bag: bag_color_count(bag, num), bag_line[0].split(" bags contain ")[-1].split(', '))
      contains = list(contains)
      tree.extend(contains)
    count += num
  return count - 2

if __name__ == "__main__":
  lines = read_file("day07_input.txt")
  lines = [line for line in lines if not line.endswith(NO_OTHER_BAGS)]
  bag_colors, start_colors = process_bag_colors(lines)
  count = count_bags_holding_color(bag_colors, start_colors)
  print('Part 1 bag colors that can eventually contain one shiny gold bag', count)

  bags = count_bags_inside(lines, SHINY_GOLD)
  print('Part 2 individual bags required inside of one shiny gold bag', bags)
