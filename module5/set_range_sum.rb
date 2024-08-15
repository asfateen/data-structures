# In this problem, your goal is to implement a data structure to store a set of integers and quickly compute range sums.

# Represents a vertex (node) in the splay tree.
# Each vertex holds a key, the sum of the subtree rooted at this vertex, 
# and pointers to its left and right children, as well as its parent.
class Vertex
  attr_accessor :key, :sum, :left, :right, :parent

  def initialize(key, sum, left = nil, right = nil, parent = nil)
    @key = key
    @sum = sum
    @left = left
    @right = right
    @parent = parent
  end
end

# Updates the sum of the given vertex and its children.
# Sets the parent pointer for the left and right children of the vertex.
#
def update(v)
  return if v.nil?
  v.sum = v.key + (v.left.nil? ? 0 : v.left.sum) + (v.right.nil? ? 0 : v.right.sum)
  v.left.parent = v unless v.left.nil?
  v.right.parent = v unless v.right.nil?
end
# Performs a small rotation (single rotation) to maintain the splay tree properties.
#
def smallRotation(v)
  parent = v.parent
  return if parent.nil?
  grandparent = parent.parent
  if parent.left == v
    m = v.right
    v.right = parent
    parent.left = m
  else
    m = v.left
    v.left = parent
    parent.right = m
  end
  update(parent)
  update(v)
  v.parent = grandparent
  unless grandparent.nil?
    if grandparent.left == parent
      grandparent.left = v
    else
      grandparent.right = v
    end
  end
end
# Performs a big rotation (double rotation) to maintain the splay tree properties.
#

def bigRotation(v)
  if v.parent.left == v && v.parent.parent.left == v.parent
    smallRotation(v.parent)
    smallRotation(v)
  elsif v.parent.right == v && v.parent.parent.right == v.parent
    smallRotation(v.parent)
    smallRotation(v)
  else
    smallRotation(v)
    smallRotation(v)
  end
end
# Splays the given vertex to the root of the splay tree.
def splay(v)
  return nil if v.nil?
  until v.parent.nil?
    if v.parent.parent.nil?
      smallRotation(v)
      break
    end
    bigRotation(v)
  end
  v
end

# Finds the vertex with the closest key greater than or equal to the given key,
# and splay the last visited vertex to the root.
#
def find(root, key)
  v = root
  last = root
  next_v = nil
  until v.nil?
    if v.key >= key && (next_v.nil? || v.key < next_v.key)
      next_v = v
    end
    last = v
    break if v.key == key
    v = v.key < key ? v.right : v.left
  end
  root = splay(last)
  [next_v, root]
end

# Splits the tree into two trees based on the given key.
# The first tree contains all nodes with keys less than the given key,
# and the second tree contains all nodes with keys greater than or equal to the given key.
#
def split(root, key)
  result, root = find(root, key)
  return [root, nil] if result.nil?

  right = splay(result)
  left = right.left
  right.left = nil
  left.parent = nil unless left.nil?
  update(left)
  update(right)

  [left, right]
end

# Merges two trees into one tree.
# The first tree is merged as the left subtree, and the second tree is merged as the right subtree.
#
def merge(left, right)
  return right if left.nil?
  return left if right.nil?
  while right.left
    right = right.left
  end
  right = splay(right)
  right.left = left
  update(right)
  right
end

# Inserts a key into the splay tree.
#
def insert(x)
  left, right = split($root, x)
  new_vertex = nil
  new_vertex = Vertex.new(x, x) if right.nil? || right.key != x
  $root = merge(merge(left, new_vertex), right)
end
# Removes a key from the splay tree.
#
def erase(x)
  left, middle = split($root, x)
  middle ,right = split(middle, x + 1)


  $root = merge(left, right)
end

# Searches for a key in the splay tree.
#
def search(x)
  node, $root = find($root, x)
  !node.nil? && node.key == x
end

# Computes the sum of the keys in the range [fr, to] in the splay tree.
#
def sum(fr, to)
  left, middle = split($root, fr)
  middle, right = split(middle, to + 1)
  ans = middle.nil? ? 0 : middle.sum
  $root = merge(merge(left, middle), right)
  ans
end

MODULO = 1_000_000_001
n = ARGF.readline.to_i
last_sum_result = 0
n.times do
  line = ARGF.readline.split
  case line[0]
  when '+'
    x = line[1].to_i
    insert((x + last_sum_result) % MODULO)
  when '-'
    x = line[1].to_i
    erase((x + last_sum_result) % MODULO)
  when '?'
    x = line[1].to_i
    puts search((x + last_sum_result) % MODULO) ? 'Found' : 'Not found'
  when 's'
    l = line[1].to_i
    r = line[2].to_i
    res = sum((l + last_sum_result) % MODULO, (r + last_sum_result) % MODULO)
    puts res
    last_sum_result = res % MODULO
  end
end
