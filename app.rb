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

def solve(numbers)
  results = []
  op_combos = combinations(['*', '+', '/', '-'])
  num_perms = numbers.permutation(4).to_a.uniq

  num_perms.each do |nums|
    op_combos.each do |ops|
      if chain?(nums, ops)
        results << "((#{nums[0]} #{ops[0]} #{nums[1]}) #{ops[1]} #{nums[2]}) #{ops[2]} #{nums[3]}"
      end

      if middle_left?(nums, ops)
        results << "(#{nums[0]} #{ops[0]} (#{nums[1]} #{ops[1]} #{nums[2]})) #{ops[2]} #{nums[3]}"
      end

      if middle_split?(nums, ops)
        results << "(#{nums[0]} #{ops[0]} #{nums[1]}) #{ops[1]} (#{nums[2]} #{ops[2]} #{nums[3]})"
      end

      if middle_right?(nums, ops)
        results << "(#{nums[0]} #{ops[0]} ((#{nums[1]} #{ops[1]} #{nums[2]}) #{ops[2]} #{nums[3]})"
      end
    end
  end

  results.uniq
end

def chain?(nums, ops)
  result = nums[0].to_f
  ops.each_with_index do |op, index|
    result = result.send(op.to_sym, nums[index+1].to_f)
  end
  result == 24 ? true : false
end

def middle_left?(nums, ops)
  middle = nums[1].send(ops[1].to_sym, nums[2].to_f)
  left = nums[0].send(ops[0].to_sym, middle.to_f)
  result = left.send(ops[2].to_sym, nums[3].to_f)
  result == 24 ? true : false
end

def middle_split?(nums, ops)
  left = nums[0].send(ops[0].to_sym, nums[1].to_f)
  right = nums[2].send(ops[2].to_sym, nums[3].to_f)
  result = left.send(ops[1].to_sym, right.to_f)
  result == 24 ? true : false
end

def middle_right?(nums, ops)
  middle = nums[1].send(ops[1].to_sym, nums[2].to_f)
  right = middle.send(ops[2].to_sym, nums[3].to_f)
  result = nums[0].send(ops[0].to_sym, right.to_f)
  result == 24 ? true : false
end

def valid_entry?(numbers)
  numbers.select { |num| /^[0-9]*$/ =~ num }.length == 4
end

def display_solutions(solutions)
  if solutions.count > 0
    puts "Solutions:"
    puts solutions
    puts "Found: #{solutions.count}"
  else
    puts "No solutions."
  end
end

def display_welcome_message
  puts "-" * 25
  puts "Welcome to 24-Solver"
  puts "-" * 25
end

def display_instructions
  puts "Enter 4 numbers (space separated) and I will display every possible solution:"
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

  solutions = solve(numbers.map(&:to_i))
  display_solutions(solutions)

  puts "Would you like to solve another set of numbers? (y/n)"
  break unless gets.chomp.downcase == 'y'
end

puts "Goodbye!"
