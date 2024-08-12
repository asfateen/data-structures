
def naive_build_heap(data)
  swaps = []
  (0...data.length).each do |i|
    ((i + 1)...data.length).each do |j|
      if data[i] > data[j]
        swaps << [i, j]
        data[i], data[j] = data[j], data[i]
      end
    end
  end
  swaps
end

def build_heap(data)
  swaps = []
  n = data.length

  (n / 2 - 1).downto(0) do |i|
    sift_down(i, data, swaps)
  end

  swaps
end
  
def sift_down(i, data, swaps)
  min_index = i
  left = 2 * i + 1
  right = 2 * i + 2

  if left < data.length && data[left] < data[min_index]
    min_index = left
  end

  if right < data.length && data[right] < data[min_index]
    min_index = right
  end

  if i != min_index
    swaps << [i, min_index]
    data[i], data[min_index] = data[min_index], data[i]
    sift_down(min_index, data, swaps)
  end
end



if __FILE__ == $0
  n = gets.to_i
  input_sequence = gets.split.map(&:to_i)
  raise "Input sequence length does not match n" unless input_sequence.size == n

  swaps = build_heap(input_sequence)
  puts swaps.length

  swaps.each { |i, j| puts "#{i} #{j}" }
 

end
