# In this problem you will implement in-order, pre-order and post-order traversals of a binary tree

# The TreeOrders class represents a binary tree and provides methods for different types of tree traversals.
class TreeOrders
  # Reads the binary tree structure from standard input.
  def read()
    @n = ARGF.readline.to_i
    @key = [nil] * @n
    @left = [nil] * @n
    @right = [nil] * @n

    for i in (0...@n)
      a = ARGF.readline.split.map(&:to_i)
      @key[i], @left[i], @right[i] = a[0], a[1], a[2]
    end
  end

  # Performs an in-order traversal of the binary tree.
  def inOrderTraversal
    return [] if @n == 0
    result = []
    stack = []
    current = 0

    while !stack.empty? || current != -1
      if current != -1
        stack.push(current)
        current = @left[current]
      else
        current = stack.pop
        result << @key[current]
        current = @right[current]
      end
    end

    result
  end
  # Performs a pre-order traversal of the binary tree.

  def preOrderTraversal
    return [] if @n == 0
    result = []
    stack = [0]

    until stack.empty?
      current = stack.pop
      result << @key[current]
      stack.push(@right[current]) if @right[current] != -1
      stack.push(@left[current]) if @left[current] != -1
    end

    result
  end

  # Performs a post-order traversal of the binary tree.
  def postOrderTraversal
    return [] if @n == 0
    result = []
    stack1 = [0]
    stack2 = []

    until stack1.empty?
      current = stack1.pop
      stack2.push(current)
      stack1.push(@left[current]) if @left[current] != -1
      stack1.push(@right[current]) if @right[current] != -1
    end

    until stack2.empty?
      result << @key[stack2.pop]
    end

    result
  end
end

if __FILE__ == $0
  tree = TreeOrders.new()
  tree.read()
  puts tree.inOrderTraversal.join(' ')
  puts tree.preOrderTraversal.join(' ')
  puts tree.postOrderTraversal.join(' ')
end
