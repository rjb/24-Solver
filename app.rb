def combinations(arr)
  results = []

  arr.each do |item1|
    arr.each do |item2|
      arr.each do |item3|
        results << [item1, item2, item3]
      end
    end
  end

  results
end

def chain_solutions(numbers)
  results = []
  operators = ["+", "-", "*", "/"]
  num_perms = numbers.permutation.to_a
  op_combos = combinations(operators)

  num_perms.each do |nums|
    op_combos.each do |ops|
      result = nums[0].to_f

      ops.each_with_index do |op, index|
        result = result.send(op.to_sym, nums[index+1].to_f)
      end

      if result == 24
          results << "((#{nums[0]} #{ops[0]} #{nums[1]}) #{ops[1]} #{nums[2]}) #{ops[2]} #{nums[3]}"
          break
      end
    end
  end

  results
end

def split_solutions(numbers)
  results = []
  operators = ['*', '+', '/', '-']
  num_perms = numbers.permutation(4).to_a.uniq

  num_perms.each do |nums|
    operators.each do |op|
      first = nums[0]
      first = first.send(op.to_sym, nums[1].to_f)

      operators.each do |op2|
        second = nums[2]
        second = second.send(op2.to_sym, nums[3].to_f)

        operators.each do |op3|
          result = first
          result = result.send(op3.to_sym, second)
          if result == 24
            results << "(#{nums[0]} #{op} #{nums[1]}) #{op3} (#{nums[2]} #{op2} #{nums[3]})"
          end
        end
      end
    end
  end

  results
end

def middle_left_solutions(numbers)
  results = []
  ops = ['*', '+', '/', '-']
  num_perms = numbers.permutation(4).to_a.uniq

  num_perms.each do |nums|
    ops.each do |op|
      ops.each do |op2|
        ops.each do |op3|
          middle_result = nums[1].send(op2.to_sym, nums[2].to_f)
          left_result = nums[0].send(op.to_sym, middle_result.to_f)
          result = nums[3].send(op3.to_sym, left_result.to_f)
          if result == 24
            results << "(#{nums[0]} #{op} (#{nums[1]} #{op2} #{nums[2]})) #{op3} #{nums[3]}"
          end
        end
      end
    end
  end

  results
end

def solve(numbers_orig)
  results = []
  results << chain_solutions(numbers_orig.map(&:to_i))
  results << split_solutions(numbers_orig.map(&:to_i))
  results << middle_left_solutions(numbers_orig.map(&:to_i))
  results.flatten.uniq
end

def valid_entry?(numbers)
  numbers.select { |num| /^[0-9]*$/ =~ num }.length == 4
end

def display_solutions(solutions)
  if solutions.count > 0
    puts "Solutions:"
    puts solutions
  else
    puts "No solutions."
  end
end

def display_welcome_message
  puts "-" * 25
  puts "Welcome to 24 Game Solver"
  puts "-" * 25
end

def display_instructions
  puts "Enter 4 numbers (space separated) and I will tell you the solutions:"
end

loop do
  display_welcome_message
  numbers = []

  loop do
    display_instructions
    numbers = gets.chomp.split
    break if valid_entry?(numbers)
    puts "Invalid entry."
  end

  solutions = solve(numbers)
  display_solutions(solutions)

  puts "Would you like to solve another set of numbers? (y/n)"
  break unless gets.chomp.downcase == 'y'
end

puts "Goodbye!"
