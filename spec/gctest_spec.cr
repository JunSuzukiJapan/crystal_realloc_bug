require "./spec_helper"
require "../gctest"

describe Gctest do


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

  it "map" do
    a = Gctest::Observable.from_array [4, 5, 6, 7, 8, 9, 10]
    b = a.filter {|x| x % 2 == 1}
      .map {|x| x * x }
      #.subscribe {|x| puts x}
    ary = b.to_ary
    (ary <=> [25, 49, 81]).should eq 0
  end

  it "observer" do
    observer = Gctest::Observer.new(
      ->(x : Int32){ puts x },
      ->(ex : Exception){ puts "Error: ", ex },
      ->{ puts "Completed" }
    )
    observer = Gctest::Observer.new onNext: ->(x : Int32){ puts x }
    observer = Gctest::Observer(Int32).new onError: ->(e : Exception){ puts "Error" }
    observer = Gctest::Observer(Int32).new onComplete: ->(){ puts "Completed." }
    a = Gctest::Observable.from_array [4, 5, 6]
    a.subscribe(observer) # この行があると、なぜか 'it "map" do'内のb.mapを呼んだときにエラーが起きる。たぶん、Crystalのバグ?
    # おそらく、  https://github.com/crystal-lang/crystal/issues/5694   に関連してる。
  end
end
