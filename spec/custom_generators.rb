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

    def purchase
      Generators.time.flat_map(->(whence) {
        Generators.pos_int.map(->(customer_id) {
          Purchase.new(when_time: whence, customer_id: customer_id)
        })
      })
    end

    def channel_events
      []
    end

    def channel
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
        rantly.chunk(records, number_of_sources).map do |r|
          TestSource.new(r)
        end
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
