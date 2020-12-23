input = [
  "Player 1:",
  "9",
  "2",
  "6",
  "3",
  "1",
  "",
  "Player 2:",
  "5",
  "8",
  "4",
  "7",
  "10"
]
input = IO.readlines("day22_input.txt")
currentPlayer = 0
decks = {}
input.each { |line|
  if(line=~/Player ([12]):/)
    currentPlayer = Regexp.last_match(1).to_i
    decks[currentPlayer] = []
  elsif(line=~/\d/)
    decks[currentPlayer].push line.to_i
  end
}

while(decks.values.all? {|v| v.size()>0})
  #puts "--"
  #decks.values.each { |v| puts v.inspect}
  p1 = decks[1].shift
  p2 = decks[2].shift
  if(p1>p2)
    decks[1].push p1
    decks[1].push p2
  else
    decks[2].push p2
    decks[2].push p1
  end
end
winningDeck = decks.values.map { |v| v.size==0 ? nil : v }.compact[0]
deckSize = winningDeck.size
puts "Part 1 answer: #{winningDeck.each_with_index.map { |x,i| (deckSize-i)*x}.sum}"

currentPlayer = 0
decks = {}
input.each { |line|
  if(line=~/Player ([12]):/)
    currentPlayer = Regexp.last_match(1).to_i
    decks[currentPlayer] = []
  elsif(line=~/\d/)
    decks[currentPlayer].push line.to_i
  end
}

@lastWinningDeck = []
@decksSeen = {}

def recursiveCombat(player1, player2)
  decksSeen = {}
  while(player1.size>0 && player2.size>0)
    if(decksSeen[player1.join(",")+"|"+player2.join(",")])
      @lastWinningDeck = player1
      @decksSeen.keys.each{|k| puts k}
      return 1
    end
    decksSeen[player1.join(",")+"|"+player2.join(",")] = true
    p1 = player1.shift
    p2 = player2.shift
    p1Wins = p1>p2
    if(p1<=player1.size() && p2<=player2.size())
      p1Wins = (recursiveCombat(player1[0...p1], player2[0...p2])==1)
    end
    if(p1Wins)
      player1.push p1
      player1.push p2
    else
      player2.push p2
      player2.push p1
    end
  end
  if(player1.size>0)
    @lastWinningDeck = player1
    return 1
  else
    @lastWinningDeck = player2
    return 2
  end
end
recursiveCombat(decks[1], decks[2])
deckSize = @lastWinningDeck.size
puts "part 2 answer: #{@lastWinningDeck.each_with_index.map { |x,i| (deckSize-i)*x}.sum}"
