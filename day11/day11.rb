seatMap = IO.readlines("day11_input.txt")
            .map { |line| line.scan(/[L\.\#]/) }

seatAddr = []
rows = seatMap.size
cols = seatMap[0].size
rows.times { |row|
  cols.times { |col|
    if(seatMap[row][col]!=".")
      seatAddr.push [row,col]
    end
  }
}

seatDirs = [
    [-1,-1], [-1, 0], [-1, 1],
    [ 0,-1],          [ 0, 1],
    [ 1,-1], [ 1, 0], [ 1, 1],
  ]
seatCheckNear = Array.new(rows) { Array.new(cols) {[]} }
seatCheckFar  = Array.new(rows) { Array.new(cols) {[]} }
seatAddr.each { |row,col|
  seatDirs.each { |dir|
    rowChk = row+dir[0]
    colChk = col+dir[1]
    if((0...rows).include?(rowChk) && (0...cols).include?(colChk))
      seatCheckNear[row][col].push [rowChk, colChk]
      done = false
      while(!done && (0...rows).include?(rowChk) && (0...cols).include?(colChk))
        if(seatMap[rowChk][colChk]!=".")
          done = true
          seatCheckFar[row][col].push [rowChk, colChk]
        else
          rowChk += dir[0]
          colChk += dir[1]
        end
      end
    end
  }
}

def updateSeats(seatMap, seatAddr, seatCheck, leaveThresh)
  modified = false
  newSeatMap = seatMap.collect {|row| row.clone}
  seatAddr.each { |row,col|
    adjCnt = seatCheck[row][col].reduce(0){ |cnt, check|
      (seatMap[check[0]][check[1]]=="#") ? cnt + 1 : cnt
    }
    case(seatMap[row][col])
    when "L"
      if(adjCnt==0)
        newSeatMap[row][col] = "\#"
        modified = true
      end
    when "\#"
      if(adjCnt>=leaveThresh)
        newSeatMap[row][col] = "L"
        modified = true
      end
    end
  }
  return [modified, newSeatMap]
end

modified = true
while(modified)
  modified, seatMap = updateSeats(seatMap, seatAddr, seatCheckNear, 4)
end
puts "Part 1 answer: #{seatMap.reduce(0) { |cnt, row|
                        cnt += row.select{|col| (col=="\#")}.size
                      }}"

seatAddr.each {|row,col| seatMap[row][col] = "L"} #empty all the seats

modified = true
while(modified)
  modified, seatMap = updateSeats(seatMap, seatAddr, seatCheckFar, 5)
end
puts "Part 2 answer: #{seatMap.reduce(0) { |cnt, row|
                        cnt += row.select{|col| (col=="\#")}.size
                      }}"
