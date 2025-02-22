# Perform dfs (depth first search) to determine all valid trails
class Day10
  Position = Struct.new('Position', :i, :j)

  def initialize
    # sum of number of 9-height positions reachable from each trailhead via a hiking trail
    @scores = 0
    # sum of number of distinct hiking trails which begin at each trailhead
    @ratings = 0
    parse_input
  end

  def parse_input
    filename = File.join(File.dirname(__FILE__), 'day10_input.txt')
    @grid = []
    IO.foreach(filename) do |line|
      @grid << line.strip.split('').map(&:to_i)
    end
    @m = @grid.length - 1
    @n = @grid[0].length - 1
  end

  def call
    search
    output
  end

  private

  def output
    puts "DFS reachable hiking trails: #{@scores}"
    puts "BFS unique hiking trails from trail head: #{@ratings}"
  end

  def search
    (0..@m).each do |i|
      (0..@n).each do |j|
        # part 1 depth first search
        dfs(Position.new(i, j), 0) if @grid[i][j].zero?
        # part 2 breadth first search
        bfs(Position.new(i, j)) if @grid[i][j].zero?
      end
    end
  end

  def dfs(pos, count, visited = {})
    return if visited[pos]
    return if @grid[pos.i][pos.j] != count

    @scores += 1 if @grid[pos.i][pos.j] == 9

    visited[pos] = true

    neighbors = [
      Position.new(pos.i - 1, pos.j),
      Position.new(pos.i + 1, pos.j),
      Position.new(pos.i, pos.j + 1),
      Position.new(pos.i, pos.j - 1)
    ].filter do |node|
      inbounds(node)
    end

    neighbors.each do |node|
      dfs(node, count + 1, visited)
    end
  end

  def bfs(head)
    queue = []
    queue.push(head)

    until queue.empty?
      pos = queue.shift
      value = @grid[pos.i][pos.j]

      neighbors = [
        Position.new(pos.i - 1, pos.j),
        Position.new(pos.i + 1, pos.j),
        Position.new(pos.i, pos.j - 1),
        Position.new(pos.i, pos.j + 1)
      ].filter do |candidate|
        inbounds(candidate) && @grid[candidate.i][candidate.j] == value + 1
      end

      neighbors.each do |node|
        @ratings += 1 if @grid[node.i][node.j] == 9
        queue.push(node)
      end
    end
  end

  def inbounds(pos)
    pos.i >= 0 && pos.i <= @m && pos.j >= 0 && pos.j <= @n
  end
end

Day10.new.call
