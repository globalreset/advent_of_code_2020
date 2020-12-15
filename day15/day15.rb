numList = [13,16,0,12,15,1]
lastTurn = {}
prevAge = 0
num = 0
#2020.times { |i|
30000000.times { |i|
  num = numList.shift || prevAge
  prevAge = lastTurn[num] ? i-lastTurn[num] : 0
  lastTurn[num] = i
}
puts num
