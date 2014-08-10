require 'rantly'

class Rantly

  def chunk(array, qty)
    Enumerator.new do |yielder|
      chunks = qty #ow, mutation. But recursion stack-overflows
      remaining = array
      while(chunks > 1)
        yield_this_many = range(0, array.size)
        yielder.yield remaining.take(yield_this_many)

        remaining = remaining.drop(yield_this_many)
        chunks = chunks - 1
      end
      yielder.yield remaining
    end.to_a
  end
end
