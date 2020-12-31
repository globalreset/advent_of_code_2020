#input = "389125467"
input = "523764819"
LinkedList = Struct.new(:value, :next)
map = {}
cups = input.scan(/\d/).map(&:to_i)
cups = [cups, (10..1_000_000).to_a].flatten
maxCup = cups.max
cups.each_cons(2) { |a,b|
  map[a] ||= LinkedList.new(a, nil)
  map[b] ||= LinkedList.new(b, nil)
  map[a].next = map[b]
}
map[cups[-1]].next = map[cups[0]]
currentCup = map[cups[0]]

10_000_000.times {
  pickup = currentCup.next
  currentCup.next = pickup.next.next.next
  inplay = [currentCup.value, pickup.value, pickup.next.value, pickup.next.next.value]
  dst = currentCup.value
  while(inplay.include?(dst))
    dst -= 1
    dst = maxCup if(dst<=0)
  end
  pickup.next.next.next = map[dst].next
  map[dst].next = pickup
  currentCup = currentCup.next
}

puts "#{map[1].next.value} * #{map[1].next.next.value} = #{map[1].next.value*map[1].next.next.value} "
