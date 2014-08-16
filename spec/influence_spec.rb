require_relative 'spec_helper'
require_relative '../lib/influence'

describe InfluenceService do
  let(:now) { Time.now }
  let(:earlier) { now - 60 }

  def make_adapters(channel_events)
    channel_events.map {|(channel,events)| TestChannelAdapter.new(channel, events)}
  end

  it "example: returns some calculated numbers" do
    purchase_service = TestPurchaseAdapter.new(
      (1..5).map { |i| Purchase.new(when_time: now, customer_id: i)})
    services = make_adapters({
      email: [Event.new(when_time: earlier, who: 1, what: :email_sent )],

      mobile: [Event.new(when_time: earlier, who: 2, what: :mobile_view),
               Event.new(when_time: earlier, who: 3, what: :mobile_view)],

      web: [Event.new(when_time: earlier, who: 4, what: :ad_click),
            Event.new(when_time: earlier, who: 4, what: :ad_show),
            Event.new(when_time: earlier, who: 3, what: :ad_show),
            Event.new(when_time: earlier, who: 5, what: :ad_show)]})

    item = Item.new("Rooster")
    actual = InfluenceService.new(purchase_service, services).investigate(item)
    expected = PurchaseAttribution.new(
      total_purchases = 5,
      channels = { email: ChannelInfluence.new(num_purchases=1, relevance=20),
        mobile: ChannelInfluence.new(num_purchases=2, relevance=30),
        web: ChannelInfluence.new(num_purchases=3, relevance=50)})

    expect(actual).to eq(expected)
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
