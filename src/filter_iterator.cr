module Gctest
  #
  # FilterIterator
  #
  class FilterIterator(T)
    include Iterator(T)

    def initialize(@iter : Iterator(T), @predicate : Proc(T, Bool))
    end

    def next
      while true
        item = @iter.next
        if item.is_a? T
          if @predicate.call(item) 
            return item
          end
        else
          return stop
        end
      end
    end

    def rewind
      @iter.rewind
    end

  end  
end