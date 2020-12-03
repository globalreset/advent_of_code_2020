entryList = IO.readlines("daytwo_input.txt").collect { |line|
  if(line=~/([0-9]+)-([0-9]+) (\w): (\w+)/)
    [Regexp.last_match(1).to_i, Regexp.last_match(2).to_i, Regexp.last_match(3), Regexp.last_match(4)]
  else
    puts "error on #{line}"
    exit
  end
}

validCnt = 0
entryList.each { |min, max, char, password|
  charCnt = password.scan(/#{char}/).size
  validCnt+=1 if(charCnt >= min && charCnt <= max)
}
puts "Part 1: #{validCnt}"

validCnt = 0
entryList.each { |min, max, char, password|
  validCnt+=1 if((password[min-1]==char) ^ (password[max-1]==char))
}
puts "Part 2: #{validCnt}"
