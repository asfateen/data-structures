#A natural generalization of the pattern matching problem is the following: find all text locations where dis- tance from pattern is sufficiently small

# Calculates the hash table for a given string.
def hash_table(s, prime, x)
  return [] if s.nil? || s.empty?

  hash_table = Array.new(s.length + 1, 0)
  (1..s.length).each do |i|
    hash_table[i] = (hash_table[i - 1] * x + s[i - 1].ord) % prime
  end
  hash_table
end

# Computes the hash value for a substring of length `length` starting at `start` in the original string.
def hash_value(hash_table, prime, x, start, length)
  y = x.pow(length, prime)
  (hash_table[start + length] - y * hash_table[start]) % prime
end

# Precomputes the hash tables for both the text and the pattern.
def pre_compute(text, pattern)
  h1 = hash_table(text, $m, $x)
  h2 = hash_table(pattern, $m, $x)
  [h1, h2]
end

# Checks if the substring starting at `a_start` and the pattern `p`
# match with at most `k` mismatches, using a divide-and-conquer approach.

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

# Solves the pattern matching problem for a given text and pattern with allowed mismatches.
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
