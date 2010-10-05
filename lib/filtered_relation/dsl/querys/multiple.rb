module MultipleQuery
  def query
    preload(@start_field).select(@select_fields.join ',').from("#{table_name}, #{@start_field}").where("#{table_name}.id = #{@start_field}.post_id")
  end
  def add_filter expectation
    query.group(@groups.first).having("#{@relation_search} #{expectation}") 
  end
end
