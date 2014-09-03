require 'rantly'
require 'rantly/rspec_extensions'
require 'generatron'
require_relative 'custom_generators'

class TestPurchaseAdapter
  def initialize(purchases)

  end
end

class TestChannelAdapter
  attr_reader :channel
  # someday this would accept instructions for being slow and failing
  def initialize(channel, events)
     @events = events
     @channel = channel
  end

  def retrieve_events(purchases)
    @events
  end
end
