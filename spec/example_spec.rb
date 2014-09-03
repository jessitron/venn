require_relative 'spec_helper'
require_relative '../lib/influence'

describe "Stuff" do
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
end
