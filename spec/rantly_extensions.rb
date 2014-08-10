require 'rantly'

class Rantly

  def chunk(array, qty)
    Enumerator.new do |yielder|
      def bite(yielder, array, chunks)
        if (chunks == 1) then
          yielder.yield array
        else
          yield_this_many = range(0, array.size)
          yielder.yield array.take(yield_this_many)
          bite(yielder, array.drop(yield_this_many), chunks - 1)
        end
      end
      bite(yielder, array, qty)
    end.to_a
  end
end
