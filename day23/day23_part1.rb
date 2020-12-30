
input = "523764819"
cups = input.scan(/\d/).map(&:to_i)

100.times { |i|
  pickup = cups.shift(4)
  dst = pickup[0]
  while (pickup.include?(dst))
    dst -= 1
    dst = 9 if(dst<=0)
  end
  cups.insert(cups.index(dst) + 1, pickup[3])
  cups.insert(cups.index(dst) + 1, pickup[2])
  cups.insert(cups.index(dst) + 1, pickup[1])
  cups.push pickup[0]
}
until(cups[-1]==1)
  cups.push cups.shift
end
puts cups.join("")
