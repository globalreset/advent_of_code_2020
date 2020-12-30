#input = "389125467"
input = "523764819"
cups = input.scan(/\d/).map(&:to_i)
cups = [cups, (10..1_000_000).to_a].flatten
map = {}
10_000_000.times { |i|
  pickup = cups.shift(4)
  dst = pickup[0]
  while (pickup.include?(dst))
    dst -= 1
    dst = 1_000_000 if(dst<=0)
  end
  idx = cups.index(dst)
  cups.insert(idx + 1, pickup[1], pickup[2], pickup[3])
  cups.push pickup.pop
}
idx = cups.index(1)
idx1 = (idx+1)%cups.size
idx2 = (idx+2)%cups.size
puts "#{cups[idx1]} * #{cups[idx2]} = #{cups[idx1]*cups[idx2]}"
