module BelongsToQuery
  def query
    preload(@start_field).select(@select_fields.join ',').from("#{table_name}, #{@start_field.to_s.pluralize}").where("#{table_name}.#{@start_field}_id = #{@start_field.to_s.pluralize}.id")
  end
  def add_filter expectation
    query.group(@groups.first).having("#{@relation_search} #{expectation}") 
  end
end