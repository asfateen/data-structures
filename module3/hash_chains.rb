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

class QueryProcessor
  MULTIPLIER = 263
  PRIME = 1000000007

  def initialize(bucket_count)
    @bucket_count = bucket_count
    @hash_table = Array.new(@bucket_count){[]}
  end

  def hash_func(s)
    ans = 0
    for c in s.chars.reverse
      ans = (ans * MULTIPLIER + c.ord) % PRIME
    end
    ans % @bucket_count
  end

  def write_search_result(was_found)
    puts was_found ? 'yes' : 'no'
  end

  def write_chain(chain)
    puts chain.join(' ')
  end

  def read_query()
    Query.new(gets.split)
  end

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