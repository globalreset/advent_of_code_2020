groupAndMask = {}
groupOrMask = {}
groupId = 0
IO.readlines("day6_input.txt").each { |line|
  if(line.chomp=="")
    groupId += 1
  else
    mask = line.scan(/\w/)
               .map { |q| q.ord - 'a'.ord} #convert letter to bit position
               .inject(0) { |m,b| m |= (1<<b) } #create a bit mask
    groupOrMask[groupId]  = (groupOrMask[groupId]  ||  0) | mask #accumulate ORs
    groupAndMask[groupId] = (groupAndMask[groupId] || -1) & mask #accumulate ANDs
  end
}

countOnes = proc { |i| i.to_s(2).scan(/1/).size } #count num of bits set

sum = groupOrMask.values.map(&countOnes).inject(:+)
puts "Part 1: questions answered yes by each group = #{sum}"

sum = groupAndMask.values.map(&countOnes).inject(:+)
puts "Part 2: questions answered yes by every member of each group = #{sum}"
