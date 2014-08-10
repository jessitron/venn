
class Search
  def initialize(sources)
    @sources = sources
  end

  def find_buyers(item, result_qty)
    # boo
    @sources.flat_map{ |s| s.query(item) }
  end
end
