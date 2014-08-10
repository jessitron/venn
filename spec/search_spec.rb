require_relative 'spec_helper'
require_relative '../lib/search.rb'

describe Search do

  it "returns everything when fewer than requested are sent in" do
    property_of {
      result_qty = Generators.rantly.range(0, 10)
      records = CustomGenerators.record.sample_n(Generators.rantly.range(0, result_qty))
      sources = CustomGenerators.sources_of(records).sample
      item = CustomGenerators.item.sample
      [records, sources, item, result_qty]
    }.check do |(records, sources, item, result_qty)|

      result_set = Search.new(sources).find_buyers(item, result_qty)

      expect(result_set).to eq(records)
    end
  end
end
