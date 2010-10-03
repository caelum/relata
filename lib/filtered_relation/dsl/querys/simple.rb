module SimpleQuery
  def query
    self
  end
  
  def add_filter *expectation
    puts "adding condition"
    base = @relation_search.condition(@current_field.to_s, expectation)
    where("#{base} #{expectation}")
  end
  
end