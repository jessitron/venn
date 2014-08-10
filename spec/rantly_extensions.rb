require 'rantly'

class Rantly

  def chunk(array)
    Enumerator.new do |yielder|
      def bite(yielder, (head, *tail))
        yielder.yield [head]
        if (not tail.empty?) then
          bite(yielder, tail)
        end
      end
      if (array.empty?) then []
      else      bite(yielder, array)
      end
    end.to_a
  end
end
