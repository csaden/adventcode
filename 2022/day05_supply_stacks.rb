class Stack
  def initialize(items = [])
    @items = items
  end

  def push(item)
    # part1 push individual items
    # @items.push(*item.reverse)
    # part2 push groups of items and retain order
    @items.push(*item)
  end

  def peek()
    @items.slice(-1)
  end

  def pop(count=1)
    @items.pop(count)
  end
end

def create_stack(input)
  stack = Stack.new(input.split(''))
end

def create_stacks
  [
    create_stack('SLW'),
    create_stack('JTNQ'),
    create_stack('SCHFJ'),
    create_stack('TRMWNGB'),
    create_stack('TRLSDHQB'),
    create_stack('MJBVFHRL'),
    create_stack('DWRNJM'),
    create_stack('BZTFHNDJ'),
    create_stack('HLQNBFT'),
  ]
end

file = File.open("./day05_input.txt")
data = file.readlines.drop(10).map(&:chomp)
file.close

def moves(arr)
  stacks = create_stacks()
  arr.each do |line|
    # an instruction line looks like "move 5 from 4 to 5"
    instructions = line.split(' ')

    count = instructions[1].to_i
    # subtract 1 for the stack indices
    from_index = instructions[3].to_i - 1
    to_index = instructions[5].to_i - 1

    from_stack = stacks[from_index]
    items = from_stack.pop(count)
    to_stack = stacks[to_index]
    to_stack.push(items)
  end
  stacks.map{|stack| stack.peek()}.join('')
end

puts moves(data)
