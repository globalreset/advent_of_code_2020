numList = [13,16,0,12,15,1]
#numList = [0,3,6]
lastTurn = {}
prevAge = 0
num = 0
#2020.times { |i|
30000000.times { |i|
  if(i<numList.size())
    num = numList[i%numList.size]
  else
    num = prevAge
  end
  #puts "#{i+1}: #{num}"
  if(lastTurn[num]==nil)
    lastTurn[num] = i
    prevAge = 0
  else
    prevAge = i - lastTurn[num]
    lastTurn[num] = i
  end
}
puts num
