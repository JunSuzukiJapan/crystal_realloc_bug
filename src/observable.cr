
module Gctest
  class Observable(T, U)
    def self.from_array(array : Array(T))
      ColdObservable(T, T).new(ArrayIterator.new array)
    end

    def self.range(start : Int32, end : Int32)
      ColdObservable(Int32, Int32).new(RangeIterator.new(start, end))
    end

    def to_ary
      ary = [] of U

      while true
        item = @iter.next
        if item.is_a? U
          ary.push item
        else # item == Iterator::Stop
          break
        end
      end

      ary
    end

    def filter(&predicate : Proc(T, Bool))
      iter = FilterIterator.new(@iter, predicate)
      ColdObservable(T, T).new iter
    end

    def map(&selector : T -> U)
      iter = MapIterator.new(@iter, selector)
      ColdObservable(T, U).new iter
    end

    def repeat(count : Int32)
      iter = RepeatIterator.new(@iter, count)
      ColdObservable(T, T).new iter
    end
  end

  class ColdObservable(T, U) < Observable(T, U)

    # initializer
    def initialize(@iter : Iterator(T))
    end

    getter iter

    # instance methods
    def subscribe(
      onNext : Proc(T, Nil) = ->(x : T){},
      onError : Proc(Exception, Nil) = ->(ex : Exception){},
      onComplete : Proc(Nil) = ->(){}
    )
      observer = Observer(T).new(onNext, onError, onComplete)
      self.subscribe(observer)
    end

    def subscribe(observer : Observer(U))
      begin
        @iter.rewind
        while true
          item = @iter.next
          if item.is_a? U
            observer.onNext(item)
          else
            break
          end
        end

        observer.onComplete

     rescue ex : Exception
        observer.onError(ex)
      end
    end

    def subscribe(&onNext : U -> Nil)
      @iter.rewind
      while true
        item = @iter.next
        if item.is_a? U
          onNext.call(item)
        else # item == Iterator::Stop
          break
        end
      end
    end

  end
end