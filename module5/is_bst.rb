# In this problem you are going to test whether a binary search tree data structure from some programming language library was implemented correctly.

# The BinaryTree class represents a binary tree with methods to add nodes and check if the tree is a Binary Search Tree (BST).
class BinaryTree
  attr_accessor :nodes

  def initialize
    @nodes = []
  end

  def add_node(key, left, right)
    @nodes << { key: key, left: left, right: right }
  end

  # Checks if the binary tree is a Binary Search Tree (BST) 
  # This method uses an iterative in-order traversal to verify the BST property.

  def is_bst?
    return true if @nodes.empty?

    stack = []
    current_index = 0
    prev_key = -Float::INFINITY

    while stack.any? || current_index != -1
      while current_index != -1
        stack.push(current_index)
        current_index = @nodes[current_index][:left]
      end

      current_index = stack.pop
      current_node = @nodes[current_index]

      return false if current_node[:key] <= prev_key

      prev_key = current_node[:key]
      current_index = current_node[:right]
    end

    true
  end
end

n = gets.to_i

tree = BinaryTree.new

n.times do
  key, left, right = gets.split.map(&:to_i)
  tree.add_node(key, left, right)
end

if tree.is_bst?
  puts "CORRECT"
else
  puts "INCORRECT"
end
