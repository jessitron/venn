require_relative 'spec_helper'
require_relative '../lib/influence'

describe InfluenceService do
  let(:now) { Time.now }
  let(:earlier) { now - 60 }

  def make_adapters(channel_events)
    channel_events.map {|(channel,events)| TestChannelAdapter.new(channel, events)}
  end

  it "returns a reasonable amount of influence" do
    property_of {
      Generators.of(Generators.any_number_of(CustomGenerators.purchase),
                    CustomGenerators.channel_events,
                    CustomGenerators.item).sample
    }.check do |(purchases, channel_events, item)|
      total_purchases = purchases.size

      result = InfluenceService.new(TestPurchaseAdapter.new(purchases),
                                    make_adapters(channel_events)).investigate(item)

      expect(result.channels.keys).to include(:web,:mobile,:email)
      result.channels.each do |(channel, influence)|
        expect(influence.num_purchases).to be <= total_purchases
        expect(influence.relevance).to be <= 100
        expect(influence.relevance).to be >= 0
      end
    end
  end

  def service_test(events, purchases, item)
    adapters = make_adapters events
    InfluenceService.new(TestPurchaseAdapter.new(purchases),adapters).investigate(item)
  end

  it "sees influence lower with fewer interactions" do
    property_of {
            Generators.of(Generators.any_number_of(CustomGenerators.purchase),
                    CustomGenerators.channel_events,
                    CustomGenerators.item,
                    CustomGenerators.channel).sample
    }.check do |(purchases, channel_events, item, channel)|

      unless channel_events[channel].empty?
        original = service_test(channel_events, purchases, item)
        channel_events[channel].pop #mutation
        fewer_interactions = service_test(channel_events, purchases, item)
        relevance = ->(r) {r.channels[channel].relevance}
        expect(relevance.(fewer_interactions)).to be < relevance.(original)
      end
    end
  end
end
