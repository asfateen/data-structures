def max_sliding_window_optimized(sequence, m)
  return sequence if m == 1
  
  deque = []
  maximums = []
  
  sequence.each_with_index do |current, i|
    deque.shift if deque.first && deque.first < i - m + 1

    deque.pop while deque.last && sequence[deque.last] <= current

    deque.push(i)

    maximums << sequence[deque.first] if i >= m - 1
  end
  
  maximums
end

if __FILE__ == $0
  n = gets.to_i
  input_sequence = gets.split.map(&:to_i)
  raise "Input sequence length does not match n" unless input_sequence.size == n
  window_size = gets.to_i

  puts max_sliding_window_optimized(input_sequence, window_size).join(' ')
end
