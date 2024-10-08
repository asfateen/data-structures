# In this problem you are going to solve the same problem as the previous one, but for a more general case, when binary search tree may contain equal keys.
# A Node class represents a node in a binary tree.
class Node
  attr_accessor :key, :left, :right

  def initialize(key, left = -1, right = -1)
    @key = key
    @left = left
    @right = right
  end
end
# Checks if the given binary tree is a Binary Search Tree (BST).
# Duplicate keys should always be in the right subtree of the first duplicated element.
# This function uses an iterative in-order traversal with a stack to verify the BST property.
def is_bst(tree)
  return true if tree.empty?

  stack = []
  stack.push([0, -Float::INFINITY, Float::INFINITY])

  while !stack.empty?
    index, min, max = stack.pop
    node = tree[index]

    return false if node.key < min || node.key >= max

    if node.right != -1
      stack.push([node.right, node.key, max])
    end

    if node.left != -1
      stack.push([node.left, min, node.key])
    end
  end

  true
end

n = gets.to_i
tree = Array.new(n)

n.times do |i|
  key, left, right = gets.split.map(&:to_i)
  tree[i] = Node.new(key, left, right)
end

puts is_bst(tree) ? "CORRECT" : "INCORRECT"
