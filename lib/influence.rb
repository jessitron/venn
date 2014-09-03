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
  def initialize(num_purchases, relevance)
    @num_purchases = num_purchases
    @relevance = relevance
  end
end

class InfluenceService
  def initialize(purchase_source, channel_event_sources)
    @channel_event_sources = channel_event_sources
  end

  def investigate(item)
    channel_stuff = @channel_event_sources.map do |event_source|
      events = event_source.retrieve_events(:foo)
      [event_source.channel, ChannelInfluence.new(events.size, events.size)]
    end
    PurchaseAttribution.new(0, channel_stuff.to_h)
  end
end

class PurchaseAttribution

  attr_accessor :channels, :total_purchases

  def initialize(total_purchases, channels)
    @channels = channels
    @total_purchases = total_purchases
  end


end

