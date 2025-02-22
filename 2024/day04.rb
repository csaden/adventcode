# breadth first search in each direction from a matching 'X'
class Day4Part1
  def initialize
    parse_input
    @found = 0
  end

  def call
    search
    puts "found 'XMAS' #{@found} times"
  end

  private

  def parse_input
    filename = File.join(File.dirname(__FILE__), 'day04_input.txt')
    @grid = []
    IO.foreach(filename) do |line|
      @grid << line.strip.split('')
    end
    @m = @grid[0].length
    @n = @grid.length
  end

  def search
    (0...@m).each do |i|
      (0...@n).each do |j|
        next unless @grid[i][j] == 'X'

        # check horizontal forward
        @found += 1 if i + 3 < @m && (@grid[i + 1][j] == 'M' && @grid[i + 2][j] == 'A' && @grid[i + 3][j] == 'S')

        # check horizontal backward
        @found += 1 if i - 3 >= 0 && (@grid[i - 1][j] == 'M' && @grid[i - 2][j] == 'A' && @grid[i - 3][j] == 'S')

        # check vertical forwards
        @found += 1 if j + 3 < @n && (@grid[i][j + 1] == 'M' && @grid[i][j + 2] == 'A' && @grid[i][j + 3] == 'S')

        # check vertical backwards
        @found += 1 if j - 3 >= 0 && (@grid[i][j - 1] == 'M' && @grid[i][j - 2] == 'A' && @grid[i][j - 3] == 'S')

        # check diagonal down right
        if i + 3 < @m && j + 3 < @n &&
           (@grid[i + 1][j + 1] == 'M' && @grid[i + 2][j + 2] == 'A' && @grid[i + 3][j + 3] == 'S')
          @found += 1
        end

        # check diagonal up left
        if i - 3 >= 0 && j - 3 >= 0 &&
           (@grid[i - 1][j - 1] == 'M' && @grid[i - 2][j - 2] == 'A' && @grid[i - 3][j - 3] == 'S')
          @found += 1
        end

        # check diagonal down left
        if i - 3 >= 0 && j + 3 < @n &&
           (@grid[i - 1][j + 1] == 'M' && @grid[i - 2][j + 2] == 'A' && @grid[i - 3][j + 3] == 'S')
          @found += 1
        end

        # check diagonal up right
        if i + 3 < @m && j - 3 >= 0 &&
           (@grid[i + 1][j - 1] == 'M' && @grid[i + 2][j - 2] == 'A' && @grid[i + 3][j - 3] == 'S')
          @found += 1
        end
      end
    end
  end
end

Day4Part1.new.call

# breadth first search in each direction from a matching 'A'
class Day4Part2
  def initialize
    parse_input
    @found = 0
  end

  def call
    search
    puts "found x-crossed MAS #{@found} times"
  end

  private

  def parse_input
    filename = File.join(File.dirname(__FILE__), 'day04_input.txt')
    @grid = []
    IO.foreach(filename) do |line|
      @grid << line.strip.split('')
    end
    @m = @grid[0].length
    @n = @grid.length
  end

  def search
    (0...@m).each do |i|
      (0...@n).each do |j|
        next unless @grid[i][j] == 'A'

        next if i.zero? || i == @m - 1
        next if j.zero? || j == @n - 1

        left = (@grid[i - 1][j - 1] == 'M' && @grid[i + 1][j + 1] == 'S') ||
               (@grid[i - 1][j - 1] == 'S' && @grid[i + 1][j + 1] == 'M')

        right = (@grid[i + 1][j - 1] == 'M' && @grid[i - 1][j + 1] == 'S') ||
                (@grid[i + 1][j - 1] == 'S' && @grid[i - 1][j + 1] == 'M')

        @found += 1 if left && right
      end
    end
  end
end

Day4Part2.new.call
