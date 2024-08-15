# In this problem you will implement a hash table using the chaining scheme. 

# Represents a query to be processed.
class Query
  attr_reader :type, :ind, :s

  def initialize(query)
    @type = query[0]
    if @type == 'check'
      @ind = query[1].to_i
    else
      @s = query[1]
    end
  end

end
# Processes a series of queries on a hash table with chaining.
class QueryProcessor
  MULTIPLIER = 263
  PRIME = 1000000007

  def initialize(bucket_count)
    @bucket_count = bucket_count
    @hash_table = Array.new(@bucket_count){[]}
  end

  # Computes the hash value for a given string.
  def hash_func(s)
    ans = 0
    for c in s.chars.reverse
      ans = (ans * MULTIPLIER + c.ord) % PRIME
    end
    ans % @bucket_count
  end

  # Outputs the result of a search query.
  def write_search_result(was_found)
    puts was_found ? 'yes' : 'no'
  end

  # Outputs the contents of a chain.
  def write_chain(chain)
    puts chain.join(' ')
  end

    # Reads a query from standard input.
  def read_query()
    Query.new(gets.split)
  end

  # Processes a single query.
  def process_query(query)
    if query.type == 'check'
      if @hash_table[query.ind]
        puts @hash_table[query.ind].join(' ')
      else
        puts
      end

    else
      hash_value = hash_func(query.s)
      if query.type == 'add'
        unless @hash_table[hash_value].include?(query.s)
          @hash_table[hash_value].unshift(query.s)
        end
      elsif query.type == 'find'
        if @hash_table[hash_value].include?(query.s)
          puts('yes')
        else
          puts('no')
        end
      elsif query.type == 'del'
        if @hash_table[hash_value].include?(query.s)
          @hash_table[hash_value].delete(query.s)
        end
      end
    end
  end
  # Processes all queries read from standard input.
  def process_queries()
    n = gets.to_i
    n.times { process_query(read_query) }
  end


end

if __FILE__ == $0
  bucket_count = gets.to_i
  proc = QueryProcessor.new(bucket_count)
  proc.process_queries
end