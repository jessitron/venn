require_relative 'generators'
require_relative 'test_source'
require 'rantly'

class CustomGenerators
  class << self

    def item
      Generator.new(->() {
        { item_name: rantly.string(:alpha)}
      })
    end

    def record
      Generator.new(->() {
        { customer: rantly.string(:alpha) }
      })
    end

    def number_of_sources; 5; end

    def sources_of(records)
      #TODO: chunk these randomly
      Generator.new(->() {
        [source_of(records).sample] + source_of([]).sample_n(number_of_sources - 1)
      })
    end

    def source_of(records)
      Generator.new(->() { TestSource.new(records)})
    end


    def rantly
      Rantly.singleton
    end
  end
end
