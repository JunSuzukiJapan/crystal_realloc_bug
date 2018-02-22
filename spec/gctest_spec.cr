require "./spec_helper"
require "../gctest"

describe Gctest do

  it "list" do
    list = Gctest::List(Int32).new
    list.push_first 1
    list.push_first 2
    list.push_first 3
    iter = list.iter
    iter.next.should eq 3
    iter.next.should eq 2
    iter.next.should eq 1
  end

  it "repeat" do
    logger = Debug::Logger.new

    list = Gctest::List(Int32).new
    list.push_first 1
    list.push_first 2
    list.push_first 3

    rep = Gctest::RepeatIterator(Int32).new(list.iter, 3)
    rep.each {|x| logger.push "#{x}"}

    logger.log.should eq "321321321"
  end

  it "repeat" do
    logger = Debug::Logger.new

    a = Gctest::Observable.range(0, 5)
    a = a.repeat(3)

    ary = [] of Int32
    a.subscribe {|x| ary.push x }
    (ary <=> [0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 0, 1, 2, 3,4]).should eq 0

    ary = a.to_ary # ERROR: 無限ループに陥る。
    #(ary <=> [0, 1, 2, 3, 4, 0, 1, 2, 3, 4, 0, 1, 2, 3,4]).should eq 0

    a.subscribe {|x| logger.push "#{x}"}
    logger.log.should eq "012340123401234"
  end

  it "map_iterator" do
    iter = Gctest::RangeIterator.new(1, 5)
    iter = Gctest::MapIterator.new(iter, ->(x : Int32){ x * x })

    iter.next.should eq 1
    iter.next.should eq 4
    iter.next.should eq 9
    iter.next.should eq 16
    iter.next.should eq 25
    (iter.next.is_a? Iterator::Stop).should be_true
  end
end
