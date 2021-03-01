# --- Day 11: Seating System ---
# Your plane lands with plenty of time to spare.
# The final leg of your journey is a ferry that goes directly to the tropical
# island where you can finally start your vacation. As you reach the waiting
# area to board the ferry, you realize you're so early, nobody else has even arrived yet!

# By modeling the process people use to choose (or abandon) their seat in the
# waiting area, you're pretty sure you can predict the best place to sit.
# You make a quick map of the seat layout (your puzzle input).

# The seat layout fits neatly on a grid. Each position is either floor (.),
# an empty seat (L), or an occupied seat (#).
# For example, the initial seat layout might look like this:

# L.LL.LL.LL
# LLLLLLL.LL
# L.L.L..L..
# LLLL.LL.LL
# L.LL.LL.LL
# L.LLLLL.LL
# ..L.L.....
# LLLLLLLLLL
# L.LLLLLL.L
# L.LLLLL.LL
# Now, you just need to model the people who will be arriving shortly.
# Fortunately, people are entirely predictable and always follow a simple set of rules.
# All decisions are based on the number of occupied seats adjacent to a given seat
# (one of the eight positions immediately up, down, left, right, or diagonal from the seat).
# The following rules are applied to every seat simultaneously:

# If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
# If a seat is occupied (#) and four or more seats adjacent to it are also occupied,
# the seat becomes empty.
# Otherwise, the seat's state does not change.
# Floor (.) never changes; seats don't move, and nobody sits on the floor.

# After one round of these rules, every seat in the example layout becomes occupied:

# #.##.##.##
# #######.##
# #.#.#..#..
# ####.##.##
# #.##.##.##
# #.#####.##
# ..#.#.....
# ##########
# #.######.#
# #.#####.##
# After a second round, the seats with four or more occupied adjacent seats become empty again:

# #.LL.L#.##
# #LLLLLL.L#
# L.L.L..L..
# #LLL.LL.L#
# #.LL.LL.LL
# #.LLLL#.##
# ..L.L.....
# #LLLLLLLL#
# #.LLLLLL.L
# #.#LLLL.##
# This process continues for three more rounds:

# #.##.L#.##
# #L###LL.L#
# L.#.#..#..
# #L##.##.L#
# #.##.LL.LL
# #.###L#.##
# ..#.#.....
# #L######L#
# #.LL###L.L
# #.#L###.##
# #.#L.L#.##
# #LLL#LL.L#
# L.L.L..#..
# #LLL.##.L#
# #.LL.LL.LL
# #.LL#L#.##
# ..L.L.....
# #L#LLLL#L#
# #.LLLLLL.L
# #.#L#L#.##
# #.#L.L#.##
# #LLL#LL.L#
# L.#.L..#..
# #L##.##.L#
# #.#L.LL.LL
# #.#L#L#.##
# ..L.L.....
# #L#L##L#L#
# #.LLLLLL.L
# #.#L#L#.##
# At this point, something interesting happens: the chaos stabilizes and
# further applications of these rules cause no seats to change state!
# Once people stop moving around, you count 37 occupied seats.

# Simulate your seating area by applying the seating rules repeatedly until no
# seats change state. How many seats end up occupied?

# --- Part Two ---
# As soon as people start to arrive, you realize your mistake.
# People don't just care about adjacent seats - they care about the first seat they
# can see in each of those eight directions!

# Now, instead of considering just the eight immediately adjacent seats,
# consider the first seat in each of those eight directions.
# For example, the empty seat below would see eight occupied seats:

# .......#.
# ...#.....
# .#.......
# .........
# ..#L....#
# ....#....
# .........
# #........
# ...#.....

# The leftmost empty seat below would only see one empty seat,
# but cannot see any of the occupied ones:

# .............
# .L.L.#.#.#.#.
# .............

# The empty seat below would see no occupied seats:

# .##.##.
# #.#.#.#
# ##...##
# ...L...
# ##...##
# #.#.#.#
# .##.##.

# Also, people seem to be more tolerant than you expected:
# it now takes five or more visible occupied seats for an occupied seat to become empty
# (rather than four or more from the previous rules). The other rules still apply:
# empty seats that see no occupied seats become occupied, seats matching no rule don't change,
# and floor never changes.

# L.LL.LL.LL
# LLLLLLL.LL
# L.L.L..L..
# LLLL.LL.LL
# L.LL.LL.LL
# L.LLLLL.LL
# ..L.L.....
# LLLLLLLLLL
# L.LLLLLL.L
# L.LLLLL.LL

# Given the same starting layout as above, these new rules cause the seating area
# to shift and eventually become:

# #.L#.L#.L#
# #LLLLLL.LL
# L.L.L..#..
# ##L#.#L.L#
# L.L#.LL.L#
# #.LLLL#.LL
# ..#.L.....
# LLL###LLL#
# #.LLLLL#.L
# #.L#LL#.L#

# Again, at this point, people stop shifting around and the seating area reaches equilibrium.
# Once this occurs, you count 26 occupied seats.

# Given the new visibility method and the rule change for occupied seats becoming empty,
# once equilibrium is reached, how many seats end up occupied?


FLOOR = "." # cannot sit here
EMPTY = "L" # empty seat
TAKEN = "#" # occupied seat

from collections import Counter
from utils import read_file

class Node():
  def __init__(self, state, i, j):
    self.state = state
    self.neighbors = []
    self.position = (i, j)
    self.next_state = None

  def apply_next_state(self):
    self.state = self.next_state

  def compute_state(self, max_occupied):
    counts = Counter(node.state for node in self.neighbors)
    if self.state == EMPTY and counts[TAKEN] == 0:
      self.next_state = TAKEN
    elif self.state == TAKEN and counts[TAKEN] >= max_occupied:
      self.next_state = EMPTY
    else:
      self.next_state = self.state
    return self.state != self.next_state

class AdjacentNode(Node):
  def __init__(self, state, i, j):
    super().__init__(state, i, j)

  def make_neighbors(self, graph):
    for i in range(-1, 2):
      for j in range(-1, 2):
        if i == 0 and j == 0:
          continue
        neighbor_position = (self.position[0] + i, self.position[1] + j)
        neighbor = graph.get(neighbor_position)
        if neighbor:
          self.neighbors.append(neighbor)


class LineOfSightNode(Node):
  def __init__(self, state, i, j):
    super().__init__(state, i, j)

  def make_neighbors(self, graph):
    # find left
    i, j = self.position
    j -= 1
    while graph.get((i, j)) and graph[(i, j)].state == FLOOR:
      j -= 1
    if graph.get((i, j)):
      self.neighbors.append(graph[(i, j)])

    # find left-up
    i, j = self.position
    i -= 1
    j -= 1
    while graph.get((i, j)) and graph[(i, j)].state == FLOOR:
      i -= 1
      j -= 1
    if graph.get((i, j)):
      self.neighbors.append(graph[(i, j)])

    # find up
    i, j = self.position
    i -= 1
    while graph.get((i, j)) and graph[(i, j)].state == FLOOR:
      i -= 1
    if graph.get((i, j)):
      self.neighbors.append(graph[(i, j)])

    # find right-up
    i, j = self.position
    i -= 1
    j += 1
    while graph.get((i, j)) and graph[(i, j)].state == FLOOR:
      i -= 1
      j += 1
    if graph.get((i, j)):
      self.neighbors.append(graph[(i, j)])

    # find right
    i, j = self.position
    j += 1
    while graph.get((i, j)) and graph[(i, j)].state == FLOOR:
      j += 1
    if graph.get((i, j)):
      self.neighbors.append(graph[(i, j)])

    # find right-down
    i, j = self.position
    i += 1
    j += 1
    while graph.get((i, j)) and graph[(i, j)].state == FLOOR:
      i += 1
      j += 1
    if graph.get((i, j)):
      self.neighbors.append(graph[(i, j)])

    # find down
    i, j = self.position
    i += 1
    while graph.get((i, j)) and graph[(i, j)].state == FLOOR:
      i += 1
    if graph.get((i, j)):
      self.neighbors.append(graph[(i, j)])

    # find left-down
    i, j = self.position
    i += 1
    j -= 1
    while graph.get((i, j)) and graph[(i, j)].state == FLOOR:
      i += 1
      j -= 1
    if graph.get((i, j)):
      self.neighbors.append(graph[(i, j)])


class Graph():
  def __init__(self, node_type, max_occupied):
    self.graph = {}
    self.rounds = 0
    self.node_type = node_type
    self.max_occupied = max_occupied

  def make_nodes(self, lines):
    for i, line in enumerate(lines):
      for j, char in enumerate(line):
        self.graph[(i, j)] = self.node_type(char, i, j)

  def make_neighbors(self):
    for node in self.graph.values():
      node.make_neighbors(self.graph)

  def compute_states(self):
    changes = [node.compute_state(self.max_occupied) for node in self.graph.values()]
    return any(changes)

  def apply_states(self):
    for node in self.graph.values():
      node.apply_next_state()
    self.rounds += 1

  def do_rounds(self):
    changed = self.compute_states()

    while changed:
      self.apply_states()
      changed = self.compute_states()

  def get_counts(self):
    return Counter(node.state for node in self.graph.values())

def get_occupied_seats(lines, node_type, max_occupied):
  graph = Graph(node_type, max_occupied)
  graph.make_nodes(lines)
  graph.make_neighbors()
  graph.do_rounds()
  counts = graph.get_counts()
  return counts[TAKEN], graph.rounds

if __name__ == "__main__":
  lines = read_file("day11_input.txt")
  seats, rounds = get_occupied_seats(lines, AdjacentNode, 4)
  print("Number of occupied seats after", rounds, "rounds:", seats)

  seats, rounds = get_occupied_seats(lines, LineOfSightNode, 5)
  print("Number of occupied seats after", rounds, "rounds:", seats)
