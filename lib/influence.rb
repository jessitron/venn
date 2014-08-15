class Purchase
  def initialize(when_time = nil, customer_id = nil)

  end
end

class Event
  def initialize(when_time = nil, who = nil, what = nil)

  end
end

class Item
  def initialize(thing)

  end
end

class ChannelInfluence

  def initialize(num_purchases = 0, relevance = 0)

  end
end

class InfluenceService
  def initialize(service, data)

  end

  @channels = [:email, :web, :mobile]
  def investigate(item)
    channel_stuff = @channels.map { |c| Influence.new n,r }
    PurchaseAttribution.new()
  end
end

class Influence
  attr_accessor :num_purchases, :relevance
  def initialize(n, r)
    @num_purchases = n
    @relevance = r
  end

end

class PurchaseAttribution

  attr_accessor :channels, :total_purchases

  def initialize(total_purchases = 0, channels)
    @channels = channels
    @total_purchases = total_purchases
  end


end

