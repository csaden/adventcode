# Direction enum for traversing graph
module Direction
  NORTH = 0
  EAST = 1
  SOUTH = 2
  WEST = 3
end

# Keep track of previously visited positions for possible new obstructions
class Tracked
  def initialize
    @positions = []
  end

  def add(position)
    @positions << position
    return unless @positions.length > 2

    @positions = @positions.drop(1)
  end

  def recent
    return [-1, -1] unless @positions[0]

    @positions[0]
  end

  def prev
    return [-1, -1] unless @positions[1]

    @positions[1]
  end
end

# Graph traversal. Compute count of unique positions the patrol "^" will visit
# Patrol travels in the same direction until encountering an obstacle then rotates 90 degrees
# Patrol travels north, east, south, or west in a straight line
class Day6
  Struct.new('Position', :i, :j)

  def initialize
    @direction = 0
    @visited = Set.new([])
    @north = Tracked.new
    @south = Tracked.new
    @east = Tracked.new
    @west = Tracked.new
    @obstructions = 0
  end

  def call
    parse_input
    patrol
  end

  private

  def parse_input
    filename = File.join(File.dirname(__FILE__), 'day06_input.txt')
    @grid = []
    IO.foreach(filename) do |line|
      @grid << line.strip.split('')
    end
    @m = @grid.length - 1
    @n = @grid[0].length - 1
  end

  def patrol
    i, j = guard

    while inbounds(i:, j:)
      case @direction
      when Direction::NORTH
        i, j = walk_north(i:, j:)
      when Direction::SOUTH
        i, j = walk_south(i:, j:)
      when Direction::EAST
        i, j = walk_east(i:, j:)
      when Direction::WEST
        i, j = walk_west(i:, j:)
      end
      rotate_guard
    end

    puts "visited #{@visited.length}"
    puts "new obstructions #{@obstructions}"
  end

  def guard
    @guard ||= (0..@m).each do |i|
        (0..@n).each do |j|
          next unless @grid[i][j] == '^'

          # mark guard start position unblocked cell
          @grid[i][j] = '.'
          return [i, j]
        end
    end
  end

  def walk_north(i:, j:)
    while inbounds(i:, j:) && open?(i:, j:)
      visit(i:, j:)
      @obstructions += 1 if (@east.recent[0] == i || @north.recent[0] == i || @north.prev[0] == i) && !patrol?(i:, j:)
      i -= 1
    end
    if blocked?(i:, j:)
      i += 1
      @north.add([i, j])
    end
    [i, j]
  end

  def walk_south(i:, j:)
    while inbounds(i:, j:) && open?(i:, j:)
      visit(i:, j:)
      @obstructions += 1 if (@west.recent[0] == i || @south.recent[0] == i || @south.prev[0] == i) && !patrol?(i:, j:)
      i += 1
    end
    if blocked?(i:, j:)
      i -= 1
      @south.add([i, j])
    end
    [i, j]
  end

  def walk_east(i:, j:)
    while inbounds(i:, j:) && open?(i:, j:)
      visit(i:, j:)
      @obstructions += 1 if (@south.recent[1] == j || @east.recent[1] == j || @east.prev[1] == j) && !patrol?(i:, j:)
      j += 1
    end
    if blocked?(i:, j:)
      j -= 1
      @east.add([i, j])
    end
    [i, j]
  end

  def walk_west(i:, j:)
    while inbounds(i:, j:) && open?(i:, j:)
      visit(i:, j:)
      @obstructions += 1 if (@north.recent[1] == j || @west.recent[1] == j || @west.prev[1] == j) && !patrol?(i:, j:)
      j -= 1
    end
    if blocked?(i:, j:)
      j += 1
      @west.add([i, j])
    end
    [i, j]
  end

  def rotate_guard
    @direction = (@direction + 1) % 4
  end

  def inbounds(i:, j:)
    in_row = i >= 0 && i <= @m
    in_col = j >= 0 && j <= @n
    in_row && in_col
  end

  def visit(i:, j:)
    @visited.add(Struct::Position.new(i:, j:))
  end

  def open?(i:, j:)
    @grid[i][j] == '.'
  end

  def blocked?(i:, j:)
    inbounds(i:, j:) && @grid[i][j] == '#'
  end

  def patrol?(i:, j:)
    guard_i, guard_j = @guard
    guard_i == i && guard_j == j
  end
end

Day6.new.call
