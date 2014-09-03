class Purchase
  def initialize(when_time = nil, customer_id = nil)
    @whence = when_time
    @who = customer_id
  end

  def inspect
    "Purchase by #{@customer_id} at #{@whence}"
  end
end

class Event
  def initialize(when_time = nil, who = nil, what = nil)
    @whence = when_time
    @who = who
    @what = what
  end

  def inspect
    "Event: #{@who} did #{@what} at #{@whence}"
  end
end

class Item
  def initialize(thing)
    @description = thing
  end
end

class ChannelInfluence
  attr_accessor :num_purchases, :relevance
  def initialize(n, r)
    @num_purchases = n
    @relevance = r
  end
end

class InfluenceService
  def initialize(service, data)

  end

  def investigate(item)
    channels = [:email, :web, :mobile]
    channel_stuff = channels.map { |c| [c, ChannelInfluence.new(0,0)]}.to_h
    PurchaseAttribution.new(0, channel_stuff)
  end
end

class PurchaseAttribution

  attr_accessor :channels, :total_purchases

  def initialize(total_purchases, channels)
    @channels = channels
    @total_purchases = total_purchases
  end


end

