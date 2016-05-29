def solve(numbers)
  results = []
  op_combos = ['*', '+', '/', '-'].repeated_permutation(3).to_a
  num_perms = numbers.permutation(4).to_a.uniq

  num_perms.each do |nums|
    op_combos.each do |ops|
      results << chain_string(nums, ops) if chain?(nums, ops)
      results << middle_left_string(nums, ops) if middle_left?(nums, ops)
      results << middle_split_string(nums, ops) if middle_split?(nums, ops)
      results << middle_right_string(nums, ops) if middle_right?(nums, ops)
    end
  end

  results.uniq
end

def chain_string(nums, ops)
  "((#{nums[0]} #{ops[0]} #{nums[1]}) #{ops[1]} #{nums[2]}) #{ops[2]} #{nums[3]}"
end

def middle_left_string(nums, ops)
  "(#{nums[0]} #{ops[0]} (#{nums[1]} #{ops[1]} #{nums[2]})) #{ops[2]} #{nums[3]}"
end

def middle_split_string(nums, ops)
  "(#{nums[0]} #{ops[0]} #{nums[1]}) #{ops[1]} (#{nums[2]} #{ops[2]} #{nums[3]})"
end

def middle_right_string(nums, ops)
  "#{nums[0]} #{ops[0]} ((#{nums[1]} #{ops[1]} #{nums[2]}) #{ops[2]} #{nums[3]})"
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
  numbers.select { |num| num =~ /^[0-9]*$/ }.length == 4
end

def display_solutions(solutions)
  if solutions.count > 0
    puts "Solutions:"
    puts solutions
    puts "Found: #{solutions.count}"
  else
    puts "No solutions found."
  end
end

def display_welcome_message
  puts "-" * 20
  puts "Welcome to 24-Solver"
  puts "-" * 20
end

def display_instructions
  puts "Enter your 4 numbers (space separated)," \
         " then press Enter to see solutions that equals 24."
end

loop do
  display_welcome_message
  numbers = []

  loop do
    display_instructions
    numbers = gets.chomp.split
    break if valid_entry?(numbers)
    puts "Whole numbers only please."
  end

  solutions = solve(numbers.map(&:to_i))
  display_solutions(solutions)

  puts "Would you like to solve another set of numbers? (y/n)"
  break unless gets.chomp.downcase == 'y'
end

puts "Goodbye!"
