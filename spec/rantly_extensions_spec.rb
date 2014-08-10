require_relative 'spec_helper'

describe Rantly do

  context "chunking an array into random bits" do

    it("always returns the same items in the same order") do
      property_of {
        Generators.any_number_of(Generators.things).sample
      }.check { |input|
        result = Rantly.new.chunk(input)

        expect(result.flatten).to eq(input)
      }
    end
  end

end

