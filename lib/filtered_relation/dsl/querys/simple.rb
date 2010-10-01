module SimpleQuery
  def query
    self
  end
  
  def add_filter expectation
    where("#{@relation_search.condition(@current_field.to_s)} #{expectation}")
  end
end