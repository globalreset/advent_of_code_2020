
seatBinValues = {
  'F' => 0,
  'B' => 1,
  'L' => 0,
  'R' => 1
}
seatList = []
IO.readlines("day5_input.txt").each { |line|
  row = 0
  col = 0
  if(line.size()>0)
     codes = line.scan(/\w/)
     codes[0..6].each { |code| row = (row<<1) + seatBinValues[code] }
     codes[7..9].each { |code| col = (col<<1) + seatBinValues[code] }
     seatList.push (row*8 + col)
  end
}
seatList.sort!
puts "Part 1 answer: highest seatId = #{seatList[-1]}"

seatList.size.times { |i|
   if(i>=1)
     if(seatList[i]-2==seatList[i-1])
        puts "Part 2 answer: missing seatId = #{seatList[i]-1}"
        exit
     end
  end
}
