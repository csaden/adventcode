class Day8
  Struct.new('Position', :i, :j)

  def initialize
    @antinodes = Set.new([])
    @linear = Set.new([])
    @queues = {}
  end

  def call
    parse_input
    search
    process_nodes
    puts @antinodes.length
    puts @linear.length
  end

  private

  def parse_input
    filename = File.join(File.dirname(__FILE__), 'day08_input.txt')
    @grid = []
    IO.foreach(filename) do |line|
      @grid << line.strip.split('')
    end
    @m = @grid.length - 1
    @n = @grid[0].length - 1
  end

  def search
    (0..@m).each do |i|
      (0..@n).each do |j|
        label = @grid[i][j]
        next if label == '.'
        next if label == '#'

        pos = Struct::Position.new(i, j)
        @linear.add(pos)
        if @queues.key?(label)
          @queues[label] << Struct::Position.new(i, j)

        else
          @queues[label] = [pos]
        end
      end
    end
  end

  def process_nodes
    @queues.each_value do |queue|
      while queue.length > 1
        pos1 = queue.shift
        queue.each do |pos2|
          antinodes(pos1, pos2)
          linear_antinodes(pos1, pos2)
        end
      end
    end
  end

  def antinodes(pos1, pos2)
    di = diff_i(pos1, pos2)
    dj = diff_j(pos1, pos2)

    # compute antinode positions and check bounds
    antinode1 = Struct::Position.new(pos1.i - di, pos1.j - dj)
    antinode2 = Struct::Position.new(pos2.i + di, pos2.j + dj)

    @antinodes.add(antinode1) if inbounds(antinode1)
    @antinodes.add(antinode2) if inbounds(antinode2)
  end

  def linear_antinodes(pos1, pos2)
    di = diff_i(pos1, pos2)
    dj = diff_j(pos1, pos2)

    # compute antinode positions and check bounds
    antinode1 = Struct::Position.new(pos1.i - di, pos1.j - dj)
    while inbounds(antinode1)
      @linear.add(antinode1)
      antinode1 = Struct::Position.new(antinode1.i - di, antinode1.j - dj)
    end

    antinode2 = Struct::Position.new(pos2.i + di, pos2.j + dj)
    while inbounds(antinode2)
      @linear.add(antinode2)
      antinode2 = Struct::Position.new(antinode2.i + di, antinode2.j + dj)
    end
  end

  # compute antinode positions in line and check bounds
  def linear_before(pos1, di, dj)
    antinode1 = Struct::Position.new(pos1.i - di, pos1.j - dj)
    while inbounds(antinode1)
      @linear.add(antinode1)
      antinode1 = Struct::Position.new(antinode1.i - di, antinode1.j - dj)
    end
  end

  def linear_after(pos2, di, dj)
    antinode2 = Struct::Position.new(pos2.i + di, pos2.j + dj)
    while inbounds(antinode2)
      @linear.add(antinode2)
      antinode2 = Struct::Position.new(antinode2.i + di, antinode2.j + dj)
    end
  end

  def diff_i(pos1, pos2)
    (pos2.i - pos1.i)
  end

  def diff_j(pos1, pos2)
    (pos2.j - pos1.j)
  end

  def inbounds(pos)
    pos.i >= 0 && pos.i <= @m && pos.j >= 0 && pos.j <= @n
  end
end

Day8.new.call
