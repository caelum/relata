module SimpleQuery
  def query
    self
  end
  
  def add_filter *expectation
    base = @relation_search.condition(@current_field.to_s, expectation)
    where("#{base} #{expectation}")
  end
  
end