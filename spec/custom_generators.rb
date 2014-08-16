require_relative 'test_source'
require 'generatron'

class CustomGenerators
  class << self

    def item
      Generator.new(->() {
        { item_name: rantly.string(:alpha)}
      })
    end

    def customer_id
      Generators.pos_int
    end

    def purchase
      Generators.time.flat_map(->(whence) {
        customer_id.map(->(customer_id) {
          Purchase.new(when_time: whence, customer_id: customer_id)
        })
      })
    end

    def event_kinds(type)
      possible_kinds = { email: [:email_sent, :read, :click],
                         mobile: [:mobile_view, :click],
                         web: [:ad_show, :ad_click] }
      my_kinds = possible_kinds[type]
      result = Generator.new(->() { rantly.choose(*my_kinds)}, "event kinds for #{type}")
      result
    end

    def event(type)
      Generators.new(->() {
        whence = Generators.time.sample
        customer_id = CustomGenerators.customer_id.sample
        what = CustomGenerators.event_kinds(type).sample
        Event.new(when_time: whence, who: customer_id, what: what)
      })
    end

    @@channels = [:web, :mobile, :email]

    def channel_events
      Generator.new(->() {
        @@channels.map {|c| [c, Generators.any_number_of(event(c)).sample]}.
          to_h
      })
    end

    def channel
      Generator.new(->() { rantly.choose(:email, :web, :mobile)})
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
