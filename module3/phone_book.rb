# In this problem you will implement a simple phone book manager.

# Represents a single query in the phone book manager.
# Each query has a type (add, delete, or find), a number,
# and optionally a name if the query type is 'add'.
class Query
  attr_accessor :name
  attr_reader :type, :number 

  def initialize(query)
    @type = query[0]
    @number = query[1].to_i
    @name = query[2] if @type == 'add'
  end

end

# Reads a set of queries from standard input.
def read_queries()
  n = gets.to_i
  Array.new(n){Query.new(gets.split)}
end

# Outputs the results of processing queries to standard output.
def write_responses(result)
  puts result.join("\n")
end

# Processes a list of queries to perform operations on a phonebook.
def process_queries(queries)
  result = []
  contacts = {}
  for query in queries
    if query.type == "add"
      contacts[query.number] = query.name
    elsif query.type == "del"
      if contacts.key?(query.number)
        contacts.delete(query.number)
      end
    else
      response = 'not found'
      if contacts.key?(query.number)
        response = contacts[query.number]
      end
      result << response
    end
  end
  result
end

if __FILE__ == $0
  write_responses(process_queries(read_queries))
end