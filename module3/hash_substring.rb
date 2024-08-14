PRIME = 1000000007
MULTIPLIER = 236
def poly_hash(string, prime, multiplier)
  hash_value = 0
  (string.length - 1).downto(0) do |i|
    hash_value = (hash_value * multiplier + string[i].ord) % prime
  end
  hash_value
end

def precomputed_hashes(text, pattern, prime, multiplier)
  t = text.length
  p = pattern.length
  s = text[t - p, p]
  h = Array.new(t - p + 1)
  h[t - p] = poly_hash(s, prime, multiplier)
  y = 1
  1.upto(p) do
    y = (y * multiplier) % prime
  end
  (t - p - 1).downto(0) do |i|
    h[i] = (multiplier * h[i + 1] + text[i].ord - y * text[i + p].ord) % prime
  end
  h
end

def rabin_karp(text, pattern)
  t = text.length
  p = pattern.length
 
  result = []
  pattern_hash = poly_hash(pattern, PRIME, MULTIPLIER)
  hash_substrings = precomputed_hashes(text, pattern, PRIME, MULTIPLIER)
  (0..t - p).each do |i|
    result << i if pattern_hash == hash_substrings[i]
  end
  result
end

if __FILE__ == $0
  pattern = gets.chomp
  text = gets.chomp
  positions = rabin_karp(text, pattern)
  positions.each { |pos| print "#{pos} " }
end
