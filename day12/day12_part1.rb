instructions = IO.readlines("day12_input.txt")
                 .map { |line| [line[0], line[1..-1].to_i] }

dirList = ["N", "E", "S", "W"]
dirVecs = {
  "N" => [ 0, 1],
  "E" => [ 1, 0],
  "S" => [ 0,-1],
  "W" => [-1, 0]
}
facingDir = "E"
pos = [0,0]

instructions.each { |i|
  if(dirVecs.keys.include?(i[0]))
    dir = i[0]
    pos[0] += dirVecs[dir][0]*i[1]
    pos[1] += dirVecs[dir][1]*i[1]
  elsif(i[0]=="F")
    pos[0] += dirVecs[facingDir][0]*i[1]
    pos[1] += dirVecs[facingDir][1]*i[1]
  elsif(i[0]=="R")
    turnAmount = i[1]/90
    facingDir = dirList[(dirList.find_index(facingDir) + turnAmount)%4]
  elsif(i[0]=="L")
    turnAmount = i[1]/90
    facingDir = dirList[(dirList.find_index(facingDir) - turnAmount)%4]
  end
}

puts "Part 1 answer: #{pos[0].abs + pos[1].abs}"
