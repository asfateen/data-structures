
# In this problem, your goal is to implement the Rabin–Karp’s algorithm.

# Constants for the Rabin-Karp algorithm
PRIME = 1000000007
MULTIPLIER = 236

# Computes the polynomial hash of a given string.
def poly_hash(string, prime, multiplier)
  hash_value = 0
  (string.length - 1).downto(0) do |i|
    hash_value = (hash_value * multiplier + string[i].ord) % prime
  end
  hash_value
end

# Precomputes hash values for all substrings of the given length in the text.
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

# Implements the Rabin-Karp algorithm to find all occurrences of the pattern in the text.
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
