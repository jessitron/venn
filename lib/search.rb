
class Search
  def initialize(sources)
    @sources = sources
  end

  def find_buyers(item, result_qty)
    # boo
    @sources[0].query(item)
  end
end
