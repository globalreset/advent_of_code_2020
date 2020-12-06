groupAndMask = {}
groupOrMask = {}
groupId = 0
IO.readlines("day6_input.txt").each { |line|
  if(line.chomp=="")
    groupId += 1
  else
    individualMask = 0;
    line.scan(/\w/).each{ |q|
      maskBit = q.ord - 'a'.ord
      individualMask |= (1<<maskBit)
    }
    groupOrMask[groupId]  = (groupOrMask[groupId]  ||  0) | individualMask
    groupAndMask[groupId] = (groupAndMask[groupId] || -1) & individualMask
  end
}

sum = groupOrMask.values.collect{|mask| mask.to_s(2).scan(/1/).size}.inject(:+)
puts "Part 1: questions answered yes by each group = #{sum}"

sum = groupAndMask.values.collect{|mask| mask.to_s(2).scan(/1/).size}.inject(:+)
puts "Part 1: questions answered yes by every member of each group = #{sum}"
