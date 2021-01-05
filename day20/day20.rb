input = [
  "Tile 2311:",
  "..##.#..#.",
  "##..#.....",
  "#...##..#.",
  "####.#...#",
  "##.##.###.",
  "##...#.###",
  ".#.#.#..##",
  "..#....#..",
  "###...#.#.",
  "..###..###",
  "",
  "Tile 1951:",
  "#.##...##.",
  "#.####...#",
  ".....#..##",
  "#...######",
  ".##.#....#",
  ".###.#####",
  "###.##.##.",
  ".###....#.",
  "..#.#..#.#",
  "#...##.#..",
  "",
  "Tile 1171:",
  "####...##.",
  "#..##.#..#",
  "##.#..#.#.",
  ".###.####.",
  "..###.####",
  ".##....##.",
  ".#...####.",
  "#.##.####.",
  "####..#...",
  ".....##...",
  "",
  "Tile 1427:",
  "###.##.#..",
  ".#..#.##..",
  ".#.##.#..#",
  "#.#.#.##.#",
  "....#...##",
  "...##..##.",
  "...#.#####",
  ".#.####.#.",
  "..#..###.#",
  "..##.#..#.",
  "",
  "Tile 1489:",
  "##.#.#....",
  "..##...#..",
  ".##..##...",
  "..#...#...",
  "#####...#.",
  "#..#.#.#.#",
  "...#.#.#..",
  "##.#...##.",
  "..##.##.##",
  "###.##.#..",
  "",
  "Tile 2473:",
  "#....####.",
  "#..#.##...",
  "#.##..#...",
  "######.#.#",
  ".#...#.#.#",
  ".#########",
  ".###.#..#.",
  "########.#",
  "##...##.#.",
  "..###.#.#.",
  "",
  "Tile 2971:",
  "..#.#....#",
  "#...###...",
  "#.#.###...",
  "##.##..#..",
  ".#####..##",
  ".#..####.#",
  "#..#.#..#.",
  "..####.###",
  "..#.#.###.",
  "...#.#.#.#",
  "",
  "Tile 2729:",
  "...#.#.#.#",
  "####.#....",
  "..#.#.....",
  "....#..#.#",
  ".##..##.#.",
  ".#.####...",
  "####.#.#..",
  "##.####...",
  "##..#.##..",
  "#.##...##.",
  "",
  "Tile 3079:",
  "#.#.#####.",
  ".#..######",
  "..#.......",
  "######....",
  "####.#..#.",
  ".#...#.##.",
  "#.#####.##",
  "..#.###...",
  "..#.......",
  "..#.###..."
]
input = IO.readlines("day20_input.txt")

# edges go 0-top, 1-right, 2-bottom, 3-left
# always top-down or left-right order inside edge
Tile = Struct.new(:id, :rows, :edges, :matches) {
  def flipX()
    self.rows = self.rows.map { |row| row.reverse }
    self.edges[:top].reverse!
    self.edges[:bottom].reverse!
    self.edges[:left], self.edges[:right] = self.edges[:right], self.edges[:left]
    self.matches[:left], self.matches[:right] = self.matches[:right], self.matches[:left]
  end

  def flipY()
    self.rows = self.rows.reverse
    self.edges[:left].reverse!
    self.edges[:right].reverse!
    self.edges[:top], self.edges[:bottom] = self.edges[:bottom], self.edges[:top]
    self.matches[:top], self.matches[:bottom] = self.matches[:bottom], self.matches[:top]
  end

  def rotateRight()
    rowsTmp = self.rows.map{ |r| r.clone }
    10.times { |i|
      10.times { |j|
        self.rows[i][j] = rowsTmp[9-j][i]
      }
    }
    self.edges[:top],    self.edges[:right],
    self.edges[:bottom], self.edges[:left] =
       self.edges[:left].reverse,  self.edges[:top],
       self.edges[:right].reverse, self.edges[:bottom]
    self.matches[:top],    self.matches[:right],
    self.matches[:bottom], self.matches[:left] =
       self.matches[:left],  self.matches[:top],
       self.matches[:right], self.matches[:bottom]
  end

  def to_s()
    "Tile #{id}:" +
    "\n     rows: #{self.rows.reduce("") { |str,r| str += "\n    " + r.join("")} }"
    #"\n      top: #{self.edges[:top]}" +
    #"\n    right: #{self.edges[:right]}" +
    #"\n   bottom: #{self.edges[:bottom]}" +
    #"\n     left: #{self.edges[:left]}"
  end
}

currentTile = nil
currentRow = []
tileDb = {}
input.each { |line|
  if(line=~/Tile (\d+):/)
     id = Regexp.last_match(1).to_i
     currentTile = Tile.new(id, [], Hash.new(""), {})
     tileDb[id] = currentTile
  elsif(line=~/[#\.]+/)
     currentTile.rows <<= line.scan(/[#\.]/)
  end
}
tileDb.values.each { |tile|
    tile.edges[:top]     = tile.rows[0].join("")
    tile.edges[:right]   = tile.rows.reduce("") {|s,r| s += r[-1]}
    tile.edges[:bottom]  = tile.rows[-1].join("")
    tile.edges[:left]    = tile.rows.reduce("") {|s,r| s += r[0]}
}
#update match counts
tileDb.values.each { |tile|
  remainingTiles = tileDb.values - [tile]
  tile.edges.each { |type,edge|
    tile.matches[type] = remainingTiles.select { |t|
      t.edges.values.any? { |e|
        [edge,edge.reverse].include? e
      }
    }[0]
  }
}

cornerTiles = tileDb.values.select { |tile| tile.matches.values.flatten.compact.size==2 }
edgeTiles = tileDb.values.select { |tile| tile.matches.values.flatten.compact.size==3 }
centerTiles = tileDb.values.select { |tile| tile.matches.values.flatten.compact.size==4 }
puts "Part 1 answer: #{
    cornerTiles.map { |tile| tile.id }
               .reduce(1) {|acc, id| acc*id }
  }"

size = Math.sqrt(tileDb.keys.size).to_i
tileGrid = Array.new(size) { Array.new(size) }
#make first row, pick any corner
tileGrid[0][0] = cornerTiles[0]
#rotat until top and left have no match
until(tileGrid[0][0].matches[:right] && tileGrid[0][0].matches[:bottom])
  tileGrid[0][0].rotateRight
end
#finish first row, looking for left right matches
prevTile = tileGrid[0][0]
(1...size).each { |col|
  newTile = prevTile.matches[:right]
  tileGrid[0][col] = tileGrid[0][col-1].matches[:right]
  until(newTile.edges[:left]==prevTile.edges[:right])
    if(newTile.edges[:right]==prevTile.edges[:right])
      newTile.flipX
    elsif(newTile.edges[:left].reverse==prevTile.edges[:right])
      newTile.flipY
    else
      newTile.rotateRight
    end
  end
  prevTile = newTile
}

#all remaining rows are top-bottom matches
(1...size).each { |row|
   (0...size).each { |col|
     topTile = tileGrid[row-1][col]
     newTile = topTile.matches[:bottom]
     tileGrid[row][col] = newTile
     until(newTile.edges[:top]==topTile.edges[:bottom])
       if(newTile.edges[:bottom]==topTile.edges[:bottom])
         newTile.flipY
       elsif(newTile.edges[:top].reverse==topTile.edges[:bottom])
         newTile.flipX
       else
         newTile.rotateRight
       end
     end
   }
}

seaGrid = []
size.times { |tileRow|
  (1..8).each { |row|
    seaRow = []
    size.times { |tileCol|
      seaRow <<= tileGrid[tileRow][tileCol].rows[row][1..8]
    }
    seaGrid <<= seaRow.flatten
  }
}

8.times { |orientation|
  countMonsters = 0
  (1..(seaGrid.size-2)).each { |row|
    (0..(seaGrid[0].size-20)).each { |col|
      top = seaGrid[row-1][col..(col+19)].join("")
      mid = seaGrid[row+0][col..(col+19)].join("")
      bot = seaGrid[row+1][col..(col+19)].join("")
      if( top =~ /..................#./ &&
          mid =~ /#....##....##....###/ &&
          bot =~ /.#..#..#..#..#..#.../ )
        countMonsters += 1
        seaGrid[row-1][col+18] = "O"
        [0,5,6,11,12,17,18,19].each {|o| seaGrid[row+0][col+o] = "O"}
        [1,4,7,10,13,16].each {|o| seaGrid[row+1][col+o] = "O"}
      end
    }
  }
  if(countMonsters>0)
    puts "Part 2 answer: #{seaGrid.map { |r| r.map { |c| c=="#"?1:0}.reduce(:+) }.reduce(:+) }"
    exit
  end
  if(orientation&1==1)
    #unflip & rotate right
    seaTmp = seaGrid.map {|row| row.reverse }
    seaGrid.size.times { |r|
      seaGrid.size.times { |c|
        seaGrid[r][c] = seaTmp[seaGrid.size-1-c][r]
      }
    }
  else
    #flip x
    seaGrid = seaGrid.map {|row| row.reverse }
  end
}
