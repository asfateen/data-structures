# In this problem you will implement Rope — data structure that can store a string and efficiently cut a part (a substring) of this string and insert it in a different position. This data structure can be enhanced to become persistent — that is, to allow access to the previous versions of the string. These properties make it a suitable choice for storing the text in text editors.

# adapted from this python implementation by Ivan Lazarevic https://github.com/ivanbgd/Rope-Data-Structure/blob/master/rope_data_structure.py
class Node
  attr_accessor :value, :parent, :left, :right, :size

  def initialize(value)
    @value = value
    @parent = nil
    @left = nil
    @right = nil
    @size = 1
  end

  def to_s
    "(#{@value}, #{@size})"
  end

  def inspect
    "Value: #{@value}; Size: #{@size}"
  end
end

# Implements a splay tree to manage nodes in the Rope data structure.
class SplayTree
  attr_accessor :root, :size

  def initialize
    @root = nil
    @size = 0
  end
  
  # Performs an in-order traversal of the splay tree.
  #
  def in_order
    return '' unless @root

    result = []
    stack = []
    current = @root

    loop do
      while current
        stack.push(current)
        current = current.left
      end
      break if stack.empty?

      current = stack.pop
      result << current.value
      current = current.right
    end

    result.join
  end

  # Performs a level-order traversal of the splay tree.
  #
  def level_order
    return [] unless @root

    result = []
    queue = [@root]

    until queue.empty?
      current = queue.shift
      result << current
      queue.push(current.left) if current.left
      queue.push(current.right) if current.right
    end

    result
  end
  
  # Performs a right rotation around the given node.
  #
  def rotate_right(node)
    parent = node.parent
    y = node.left
    return unless y

    b = y.right
    y.parent = parent
    if parent
      if node == parent.left
        parent.left = y
      else
        parent.right = y
      end
    else
      @root = y
    end

    node.parent = y
    y.right = node
    node.left = b
    b.parent = node if b

    node.size = (node.left&.size || 0) + (node.right&.size || 0) + 1
    y.size = (y.left&.size || 0) + (y.right&.size || 0) + 1
  end

  # Performs a left rotation around the given node.
  #
  def rotate_left(node)
    parent = node.parent
    x = node.right
    return unless x

    b = x.left
    x.parent = parent
    if parent
      if node == parent.left
        parent.left = x
      else
        parent.right = x
      end
    else
      @root = x
    end

    node.parent = x
    x.left = node
    node.right = b
    b.parent = node if b

    node.size = (node.left&.size || 0) + (node.right&.size || 0) + 1
    x.size = (x.left&.size || 0) + (x.right&.size || 0) + 1
  end

  # Splays the given node to the root of the splay tree.
  #
  def splay(node)
    return unless node

    while node.parent
      parent = node.parent
      grandparent = parent.parent

      if grandparent.nil?
        if node == parent.left
          rotate_right(parent)
        else
          rotate_left(parent)
        end
      elsif node == parent.left && parent == grandparent.left
        rotate_right(grandparent)
        rotate_right(parent)
      elsif node == parent.right && parent == grandparent.right
        rotate_left(grandparent)
        rotate_left(parent)
      elsif node == parent.left && parent == grandparent.right
        rotate_right(parent)
        rotate_left(grandparent)
      elsif node == parent.right && parent == grandparent.left
        rotate_left(parent)
        rotate_right(grandparent)
      end
    end
  end

  # Finds the node with the given rank in 0-based indexing.
  #
  def order_statistic_zero_based_ranking(k)
    raise 'Index out of bounds' unless (0...@size).cover?(k)

    node = @root
    while node
      left_size = node.left&.size || 0
      if k == left_size
        break
      elsif k < left_size
        node = node.left
      else
        k -= left_size + 1
        node = node.right
      end
    end

    splay(node)
    node
  end

  def insert(rank, value)
    raise 'Index out of bounds' unless (0..@size).cover?(rank)

    node = Node.new(value)

    if rank == @size && @size > 0
      last = order_statistic_zero_based_ranking(rank - 1)
      node.left = last
      node.size = last.size + 1
      last.parent = node
      @root = node
      @size += 1
      return
    end

    if @size == 0
      @root = node
      @size += 1
      return
    end

    right = order_statistic_zero_based_ranking(rank)
    node.right = right
    node.left = right.left
    right.left&.parent = node
    right.left = nil
    right.size = (right.right&.size || 0) + 1
    node.size = (node.left&.size || 0) + (node.right&.size || 0) + 1
    right.parent = node
    @root = node
    @size += 1
  end

  def insert_specific(value)
    node = Node.new(value)
    @root.parent = node if @root
    node.left = @root
    node.size = (node.left&.size || 0) + 1
    @root = node
    @size += 1
  end

  def subtree_maximum(node)
    return nil unless node

    node = node.right while node.right
    splay(node)
    node
  end
end

def merge(tree1, tree2)
  return tree2 unless tree1&.size&.positive?
  return tree1 unless tree2&.size&.positive?

  root2 = tree2.root
  root1 = tree1.subtree_maximum(tree1.root)
  root2.parent = root1
  root1.right = root2
  root1.size = (root1.left&.size || 0) + (root1.right&.size || 0) + 1
  tree1.size = root1.size
  tree1
end

def split(tree, rank)
  root1 = tree.order_statistic_zero_based_ranking(rank)
  root2 = root1.right
  root1.right = nil
  root1.size = (root1.left&.size || 0) + 1

  tree1 = SplayTree.new
  tree1.root = root1
  tree1.size = root1.size

  tree2 = SplayTree.new
  if root2
    root2.parent = nil
    tree2.root = root2
    tree2.size = root2.size
  end

  [tree1, tree2]
end

def process(tree, i, j, k)
  middle, right = split(tree, j)
  if i > 0
    left, middle = split(middle, i - 1)
  else
    left = nil
  end
  left = merge(left, right)
  if k > 0
    left, right = split(left, k - 1)
  else
    right = left
    left = nil
  end
  merge(merge(left, middle), right)
end

tree = SplayTree.new
rope = gets.strip
rope.each_char { |char| tree.insert_specific(char) }

num_ops = gets.to_i
num_ops.times do
  i, j, k = gets.strip.split.map(&:to_i)
  tree = process(tree, i, j, k)
end

puts tree.in_order
