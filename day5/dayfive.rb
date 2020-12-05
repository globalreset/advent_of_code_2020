
seatBinValues = {'F' => 0,  'B' => 1, 'L' => 0, 'R' => 1}
seatList = IO.readlines("day5_input.txt").collect { |line|
   line.scan(/\w/).collect { |code| seatBinValues[code] }.join("").to_i(2)
}.sort

puts "Part 1 answer: highest seatId = #{seatList[-1]}"

(1..(seatList.size()-1)).each { |i|
   if(seatList[i]-2==seatList[i-1])
      puts "Part 2 answer: missing seatId = #{seatList[i]-1}"
   end
}
