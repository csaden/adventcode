require 'set'

class Node
  attr_accessor :size, :children, :total_size
  attr_reader :name, :parent

  def initialize(name, parent, size=0)
    @parent = parent
    @name = name
    @size = size
    @children = []
  end

  def to_s
    child_names = @children.map{|child| child.name}.join(",")
    "name: #{name} (size: #{size}) child_dirs: #{child_names}"
  end
end

class FileTree
  attr_accessor :current
  attr_reader :root

  def initialize(name)
    @root = Node.new(name, nil)
    @current = @root
  end

  def find_node(name, node = nil)
    queue = [node]

    while queue.length > 0
      curr_node = queue.shift
      if curr_node.name == name
        return curr_node
      end
      curr_node.children.each do |child|
        queue << child
      end

    end

    return nil
  end

  def add_directory(name)
    node = Node.new(name, @current)
    @current.children << node
  end

  def to_parent()
    @current = @current.parent || @root
  end

  def to_root()
    @current = @root
  end

  # get total size of a directory, including files directly or indirectly owned in the subtree
  def dir_total_size(node)
    size = 0

    queue = [node]
    while queue.length > 0
      curr_node = queue.shift
      size += curr_node.size
      curr_node.children.each do |child|
        queue << child
      end
    end

    return size
  end

  def total_sizes()
    queue = [@root]
    while queue.length > 0
      node = queue.shift
      node.total_size = dir_total_size(node)
      node.children.each do |child|
        queue << child
      end
    end
  end

  def dirs_with_size_below(max_size = 100000)
    total = 0
    queue = [@root]
    while queue.length > 0
      node = queue.shift
      if node.total_size <= max_size
        total += node.total_size
      end
      node.children.each do |child|
        queue << child
      end
    end

    return total
  end
end

# create a FileTree with root node
# for the ls command
#   - add the dir name as a child of the current node
#   - add the file size to the current node for any files in the current directory
# for the cd dir command
#   set the current node to the child node with dir name
# for the cd .. command
#   set current node to the parent node

def parse_line(line)
  dir_name = nil
  file_size = 0
  to_dir = line.start_with?('$ cd')
  add_dir = line.start_with?('dir')

  if to_dir || add_dir
    dir_name = line.split(' ').last
  end

  add_file = line.start_with?(/\d+/)
  if add_file
    file_size = line.split(' ').slice(0).to_i
  end

  return to_dir, add_dir, dir_name, add_file, file_size
end

def get_input()
  file = File.open("./day07_input.txt")
  data = file.readlines.map(&:chomp)
  file.close
  data
end

def build_filesystem()
  tree = FileTree.new('/')
  data = get_input()

  data.each do |line|
    to_dir, add_dir, dir_name, add_file, file_size = parse_line(line)

    if to_dir
      # go to parent directory
      if dir_name == '..'
        tree.to_parent()
        puts "change directory to #{tree.current.name}"
      else
        node = tree.find_node(dir_name, tree.root)
        tree.current = node
        puts "change directory to #{tree.current.name}"
      end
    end

    if add_dir
      puts "add directory #{dir_name}"
      tree.add_directory(dir_name)
    end

    if add_file
      puts "add file to dir #{tree.current.name} with size #{file_size}"
      tree.current.size += file_size
    end
  end

  tree
end

tree = build_filesystem()
tree.total_sizes()
size = tree.dirs_with_size_below()
puts "total size for dirs #{size}"
