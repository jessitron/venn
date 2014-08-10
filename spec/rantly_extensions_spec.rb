require_relative 'spec_helper'

describe Rantly do

  context "chunking an array into random bits" do

    it("always returns the same items in the same order") do
      property_of {
        Generators.of_two(
          Generators.any_number_of(Generators.things),
          Generator.new(->() { Generators.rantly.range(1)})
        ).sample
      }.check { |(input,qty)|
        result = Rantly.new.chunk(input, qty)

        expect(result.flatten).to eq(input)
        expect(result.size).to eq(qty)
      }
    end
  end

end

