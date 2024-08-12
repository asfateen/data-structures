
class TreeHeight
  def read
    @n = gets.to_i
    @parent = gets.split.map(&:to_i)
    @children = Hash.new { |hash, key| hash[key] = [] }
    @root = 0

    @parent.each_with_index do |parent_index, child_index|
      if parent_index == -1
        @root = child_index
      else
        @children[parent_index] << child_index
      end
    end

  end

  def compute_height
    height = 0
    queue = [[@root, 1]] # Each element in the queue is [node, current_height]

    until queue.empty?
      node, current_height = queue.shift
      height = [height, current_height].max

      @children[node].each do |child|
        queue << [child, current_height + 1]
      end
    end

    height
  end
end

if __FILE__ == $0
  tree = TreeHeight.new
  tree.read
  puts tree.compute_height
end

