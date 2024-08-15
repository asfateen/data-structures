class Node
  attr_accessor :key, :left, :right

  def initialize(key, left = -1, right = -1)
    @key = key
    @left = left
    @right = right
  end
end

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
