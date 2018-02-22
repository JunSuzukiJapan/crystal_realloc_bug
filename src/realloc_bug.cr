require "./realloc_bug/*"
require "./*"

puts "start"

a = ReallocBug::Observable.range(0, 5)
a = a.repeat(3)
ary = a.to_ary
puts "ary: #{ary}"

b = ReallocBug::Observable.from_array [4, 5, 6, 7, 8, 9, 10]
b = b.filter {|x| x % 2 == 1}
ary = b.to_ary

puts "end"
