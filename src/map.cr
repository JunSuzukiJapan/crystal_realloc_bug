module Gctest

  #
  # MapIterator
  #
  class MapIterator(T, U)
    include Iterator(T)

    def initialize(@iter : Iterator(T), @method : Proc(T, U))
    end

    def next
      item = @iter.next
      if item.is_a? T
        @method.call(item)
      else
        stop
      end
    end

    def rewind
      @iter.rewind
    end

  end
end