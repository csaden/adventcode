class Day9
  MaxFile = Struct.new('MaxFile', :id, :space)

  def initialize
    @files = []
  end

  def call
    sum = move_blocks(parse_input)
    puts sum
    sum = move_files(test_input)
    puts sum
  end

  private

  def parse_input
    path = File.join(File.dirname(__FILE__), 'day09_input.txt')
    File.foreach(path).first
  end

  def test_input
    '2333133121414131402'
  end

  def move_files(input)
    check_sum = 0
    factor = 0 # track index for multplying file ids
    i = 0 # track starting input index
    j = input.length - 1 # track trailing input index
    max_id = input.length.even? ? (input.length - 1 / 2) : input.length / 2
    min_id = 0
    processed = 0 # track process count of max file_ids

    while min_id <= max_id
      # process even index where file with min_id is present in disk space
      if (i % 2).zero?
        loop = input[i].to_i
        loop.times do
          puts "#{factor} * #{min_id}"
          check_sum += factor * min_id
          factor += 1
        end
        i += 1
        min_id += 1
      # move file to free space only if max_id file size less than equal to free disk space
      else
        size = input[j].to_i
        free = input[i].to_i

        # process max_id immediately if file can be moved to free space
        if size <= free
          puts "#{factor} * #{max_id}"
          check_sum += factor * max_id
          factor += 1
          max_id -= 1
          j -= 2
          i += 1
        else
          i += free - size
          factor += free - size
        end

        remaining = free - size
        while remaining.positive?

          max_id = @files[remaining].shift
          puts "#{factor} * #{max_id}"
          check_sum += factor * max_id
          factor += 1
          i += 1
        end
      end
    end

    loop = input[j].to_i - processed
    if loop.positive?
      loop.times do
        puts "#{factor} * #{max_id}"
        check_sum += factor * max_id
        factor += 1
      end
    end

    check_sum
  end

  def move_blocks(input)
    check_sum = 0
    factor = 0 # track index for multplying file ids
    i = 0 # track starting input index
    j = input.length - 1 # track trailing input index
    max_id = input.length.even? ? (input.length - 1 / 2) : input.length / 2
    min_id = 0
    processed = 0 # track process count of max file_ids

    while min_id < max_id
      # process even index where file with min_id is present in disk space
      if (i % 2).zero?
        loop = input[i].to_i
        loop.times do
          check_sum += factor * min_id
          factor += 1
        end
        i += 1
        min_id += 1
      # process the empty space where file with max_id and lower ids will fill free disk space
      else
        freq = input[j].to_i - processed
        loop = input[i].to_i
        loop.times do
          check_sum += factor * max_id
          factor += 1
          freq -= 1
          processed += 1

          next unless freq.zero?

          j -= 2
          max_id -= 1
          freq = input[j].to_i
          processed = 0
        end
        i += 1
      end
    end

    loop = input[j].to_i - processed
    if loop.positive?
      loop.times do
        check_sum += factor * max_id
        factor += 1
      end
    end

    check_sum
  end
end

Day9.new.call
