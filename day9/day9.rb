PREAMBLE = 25
numbers = IO.readlines("day9_input.txt")
            .map{ |input| input.to_i }

firstInvalidNumber = -1
(PREAMBLE...numbers.size()).each { |i|
  if(!numbers[(i-PREAMBLE)...i]
      .combination(2)
      .reduce(false) {|r,p| r ||= (p.reduce(:+)==numbers[i])})
    firstInvalidNumber = numbers[i]
    break
  end
}

puts "Part 1 answer: #{firstInvalidNumber}"

numbers.size.times { |i|
  sum = 0
  len = 0
  until(sum>firstInvalidNumber || (i+len) >= numbers.size)
    sum += numbers[i+len]
    len += 1
    if(len>1 && sum==firstInvalidNumber)
      set = numbers[i...(i+len)]
      puts "Part 2 answer: #{set.max + set.min}"
      exit
    end
  end
}
