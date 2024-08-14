def hash_table(s, prime, x)
  hash_table = Array.new(s.length + 1, 0)
  (1..s.length).each do |i|
    hash_table[i] = (hash_table[i - 1] * x + s[i - 1].ord) % prime
  end
  hash_table
end

def hash_value(hash_table, prime, x, start, length)
  y = x.pow(length, prime)
  hash_value = (hash_table[start + length] - y * hash_table[start]) % prime
  hash_value
end

def are_equal(table1, table2, prime1, prime2, x, a, b, l)
  a_hash1 = hash_value(table1, prime1, x, a, l)
  a_hash2 = hash_value(table2, prime2, x, a, l)
  b_hash1 = hash_value(table1, prime1, x, b, l)
  b_hash2 = hash_value(table2, prime2, x, b, l)
  if a_hash1 == b_hash1 && a_hash2 == b_hash2
    'Yes'
  else
    'No'
  end
end

if __FILE__ == $0
  string = gets.chomp
  n_queries = gets.to_i
  M = 1_000_000_007
  M2 = 1_000_000_009
  X = 263
  hash_table1 = hash_table(string, M, X)
  hash_table2 = hash_table(string, M2, X)
  n_queries.times do
    a, b, l = gets.split.map(&:to_i)
    puts are_equal(hash_table1, hash_table2, M, M2, X, a, b, l)
  end
end
