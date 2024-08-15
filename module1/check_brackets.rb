# In this problem you will implement a feature for a text editor to find errors in the usage of brackets in the code

# A struct representing a bracket with its character and position.
Bracket = Struct.new(:char, :position)

# Checks if a pair of brackets are matching.

def are_matching(left, right)
  ["()", "[]", "{}"].include?(left + right)
end

# Finds the first mismatch in the string of brackets.
def find_mismatch(text)
  opening_brackets_stack = []
  text.each_char.with_index(1) do |char, i|
    if "([{".include?(char)
      opening_brackets_stack.push(Bracket.new(char, i))

    elsif ")]}".include?(char)
      
      if opening_brackets_stack.empty? || !are_matching(opening_brackets_stack.last.char, char)
        return i
      else
        opening_brackets_stack.pop
      end
    end
  end
  opening_brackets_stack.empty? ? "Success" : opening_brackets_stack.last.position
end



if __FILE__ == $0
  text = gets.chomp
  mismatch = find_mismatch(text)
  puts mismatch
end
