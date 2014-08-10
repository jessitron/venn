require 'rantly/shrinks'

module Shrinkers
  #shrink an array of 2 inputs properly
  def self.shrink_like_i_say(r)
    def r.shrink
      #TODO: also shrink the second one
      if (first.shrinkable?)
        Shrinkers.shrink_like_i_say([first.shrink, last])
      else
        Shrinkers.shrink_like_i_say([first, last.shrink])
      end
    end

    def r.shrinkable?
      first.shrinkable? || last.shrinkable?
    end
    r
  end

  def self.do_not_shrink(r)
    def r.shrinkable?
      false
    end
    r
  end
end


