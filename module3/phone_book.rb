class Query
  attr_accessor :name
  attr_reader :type, :number 

  def initialize(query)
    @type = query[0]
    @number = query[1].to_i
    @name = query[2] if @type == 'add'
  end

end

def read_queries()
  n = gets.to_i
  Array.new(n){Query.new(gets.split)}
end

def write_responses(result)
  puts result.join("\n")
end

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