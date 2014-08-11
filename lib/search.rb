class Search
  def initialize(sources)
    @sources = sources
  end

  def find_buyers(item, result_qty)
    # boo
    @sources.flat_map{ |s| s.query(item) }
  end
end

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

  def investigate(item)

  end
end

class PurchaseAttribution

  def initialize(total_purchases = 0, channels = {})

  end
end
