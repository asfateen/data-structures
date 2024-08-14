PRIME1 = 1_000_000_007
PRIME2 = 1_000_004_249
X = 263
def poly_hash(s, prime, multiplier)
  hash_value = 0
  (s.length - 1).downto(0) do |i|
    hash_value = (hash_value * multiplier + s[i].ord) % prime
  end
  hash_value
end

def hash_table(s, p_len, prime, multiplier)
  h = Array.new(s.length - p_len + 1) { [] }
  substring = s[-p_len..-1]
  h[s.length - p_len] = poly_hash(substring, prime, multiplier)
  y = multiplier.pow(p_len, prime)
  (s.length - p_len - 1).downto(0) do |i|
    h[i] = (multiplier * h[i + 1] + s[i].ord - y * s[i + p_len].ord) % prime
  end
  h
end

def hash_dict(s, p_len, prime, multiplier)
  d = {}
  substring = s[-p_len..-1]
  last = poly_hash(substring, prime, multiplier)
  d[last] = s.length - p_len
  y = multiplier.pow(p_len, prime)
  (s.length - p_len - 1).downto(0) do |j|
    current = (multiplier * last + s[j].ord - y * s[j + p_len].ord) % prime
    d[current] = j
    last = current
  end
  d
end

def search_substring(hash_table, hash_dict)
  check = false
  matches = {}
  hash_table.each_with_index do |hash, i|
    b_start = hash_dict[hash] || -1
    if b_start != -1
      check = true
      matches[i] = b_start
    end
  end
  [check, matches]
end

def max_length(string_a, string_b, low, high, max_length, a_start, b_start)
  mid = (low + high) / 2
  return [a_start, b_start, max_length] if low > high

  a_hash1 = hash_table(string_a, mid, PRIME1, X)
  a_hash2 = hash_table(string_a, mid, PRIME2, X)
  b_hash1 = hash_dict(string_b, mid, PRIME1, X)
  b_hash2 = hash_dict(string_b, mid, PRIME2, X)

  check1, matches1 = search_substring(a_hash1, b_hash1)
  check2, matches2 = search_substring(a_hash2, b_hash2)

  if check1 && check2
    matches1.each do |a, b|
      temp = matches2[a] || -1
      if temp != -1
        max_length = mid
        a_start, b_start = a, b
        return max_length(string_a, string_b, mid + 1, high, max_length, a_start, b_start)
      end
    end
  end
  max_length(string_a, string_b, low, mid - 1, max_length, a_start, b_start)
end

if __FILE__ == $0
  while true
    line = gets
    break if line.nil? || line.strip.empty?

    s, t = line.split
    k = [s.length, t.length].min
    if s.length <= t.length
      short_string, long_string = s, t
    else
      short_string, long_string = t, s
    end
    l, i, j = max_length(long_string, short_string, 0, k, 0, 0, 0)
    if s.length <= t.length
      puts "#{i} #{l} #{j}"
    else
      puts "#{l} #{i} #{j}"
    end
  end
end
