# In this problem, you goal will be to implement a stack that also supports finding the maximum value and to ensure that all operations still work in constant time.

# A class that implements a stack with a `max` operation that returns the maximum element in the stack in O(1) time.
class StackWithMax
  def initialize
    @stack = [] # The main stack to store all elements.
    @max_stack = [] # A stack to store the maximum values.
  end

  def push(a)
    @stack.push(a)
    if @max_stack.empty? || a >= @max_stack.last
      @max_stack.push(a)
    end
  end

  def pop
    raise "Stack is empty" if @stack.empty?
    value = @stack.pop
    @max_stack.pop if value == @max_stack.last
  end

  def max
    raise "Stack is empty" if @stack.empty?
    @max_stack.last
  end
end

if __FILE__ == $0
  stack = StackWithMax.new

  num_queries = gets.to_i
  num_queries.times do
    query = gets.split

    case query[0]
    when "push"
      stack.push(query[1].to_i)
    when "pop"
      stack.pop
    when "max"
      puts stack.max
    else
      raise "Invalid operation"
    end
  end
end
