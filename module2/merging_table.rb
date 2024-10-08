# In this problem, your goal is to simulate a sequence of merge operations with tables in a database.

# The Database class models a collection of tables in a database where tables can be merged.
# It keeps track of the number of rows in each table, the parent relationships for table merging,
# and the rank for efficient union operations.
class Database
  attr_reader :max_row_count
  def initialize(row_counts)
    @row_counts = row_counts
    @max_row_count = row_counts.max
    @n_tables = row_counts.length
    @parent = (0...@n_tables).to_a
    @rank = [0] * @n_tables
  end

  # Finds the representative parent of the table with path compression.
  def findParent(i)
    unless i == @parent[i]
      @parent[i] = findParent(@parent[i])
    end
    @parent[i]
  end

  # Merges two tables, combining their row counts and updating the maximum row count.
  def mergeTables(destination, source)
    source_parent = findParent(source)
    destination_parent = findParent(destination)
    return if source_parent == destination_parent

    if @rank[source_parent] > @rank[destination_parent]
      @parent[destination_parent] = source_parent
      @row_counts[source_parent] += @row_counts[destination_parent]
      @row_counts[destination_parent] = 0
      @max_row_count = [@max_row_count, @row_counts[source_parent]].max
    else
      @parent[source_parent] = destination_parent
      @row_counts[destination_parent] += @row_counts[source_parent]
      @row_counts[source_parent] = 0
      @max_row_count = [@max_row_count, @row_counts[destination_parent]].max

      if @rank[source_parent] == @rank[destination_parent]
        @rank[destination_parent] += 1
      end


    end
    



  end
end

if __FILE__ == $0
  n_tables, n_queries = gets.split.map(&:to_i)
  counts = gets.split.map(&:to_i)
  raise "count mismatch" unless counts.size == n_tables

  db = Database.new(counts)

  n_queries.times do
    destination, source = gets.split.map(&:to_i)
    db.mergeTables(destination - 1, source - 1)
    puts db.max_row_count
  end




end