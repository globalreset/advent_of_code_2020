map = IO.readlines("daythree_input.txt").collect { |line| line.scan(/\.|#/) }
rows = map.size
cols = map[0].size

treeCnt = 0;
(rows-1).times { |row|
  col = ((row+1)*3) % cols
  treeCnt += 1 if(map[row+1][col]=="#")
}
puts "Part 1: tree count = #{treeCnt}"

slopeList = [[1,1], [3,1], [5,1], [7,1], [1,2]]
treeCnts = []
slopeList.each { |right, down|
  treeCnt = 0
  row = down
  col = right
  while (row < rows)
    treeCnt += 1 if(map[row][col]=="#")
    row += down
    col = (col+right) % cols
  end
  treeCnts.push treeCnt
}
product = 1
treeCnts.each { |cnt| product *= cnt }
puts "Part 2: tree counts = #{treeCnts.inspect}, product = #{product}"
