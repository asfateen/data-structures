
def hash_table(s, prime, x)
  return [] if s.nil? || s.empty?

  hash_table = Array.new(s.length + 1, 0)
  (1..s.length).each do |i|
    hash_table[i] = (hash_table[i - 1] * x + s[i - 1].ord) % prime
  end
  hash_table
end

def hash_value(hash_table, prime, x, start, length)
  y = x.pow(length, prime)
  (hash_table[start + length] - y * hash_table[start]) % prime
end

def pre_compute(text, pattern)
  h1 = hash_table(text, $m, $x)
  h2 = hash_table(pattern, $m, $x)
  [h1, h2]
end

def check_match(a_start, length, p_len, k)
  stack = []
  stack.push([a_start, 0, length, 1])
  stack.push([a_start + length, length, p_len - length, 1])
  count = 0
  temp = 2
  c = 0

  until stack.empty?
    a, b, l, n = stack.shift
    u1 = hash_value($h1, $m, $x, a, l)
    v1 = hash_value($h2, $m, $x, b, l)
    count = c if temp != n

    if u1 != v1
      count += 1
      if l > 1
        stack.push([a, b, l / 2, n + 1])
        stack.push([a + l / 2, b + l / 2, l - l / 2, n + 1])
      else
        c += 1
      end
    end

    return false if count > k
    temp = n
  end

  count <= k
end

def solve(t, p, k)
  return [] if t.nil? || p.nil? || t.empty? || p.empty?

  $h1, $h2 = pre_compute(t, p)
  pos = []
  (0..(t.length - p.length)).each do |i|
    pos << i if check_match(i, p.length / 2, p.length, k)
  end
  pos
end

$m = 1_000_000_007
$x = 263

ARGF.each_line do |line|
  k, t, p = line.split
  results = solve(t, p, k.to_i)
  puts "#{results.length} #{results.join(' ')}"
end
