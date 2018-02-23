require "./realloc_bug/*"
require "./*"

puts "start"

a = ReallocBug::Observable.range(0, 5).repeat(3).to_ary
b = ReallocBug::Observable.from_array([4, 5, 6, 7, 8, 9, 10]).filter{|x| x % 2 == 1}.to_ary

puts "end"
