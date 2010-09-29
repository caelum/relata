
module MyConditions
  def gt(value)
    add_filter("> #{value}")
  end

  def exists?
    add_filter("> 0")
  end
end

module MyConstraints
  
  def count
    @relation_search = CountManager
    self
  end
  
  class CountManager
    def self.select_fields(facet)
      "COUNT(#{facet}.id) AS count"
    end
    def self.having(expectation)
      "count #{expectation}"
    end
  end

end

module MyRelation
  def current_field=(x)
    @current_field = x
  end
  
  include MyConditions
  
  private
  def relates_to_many?(name)
    facet = @current_field
    if @record.reflect_on_association facet.to_sym
      true
    else
      false
    end
  end

  def add_filter(expectation)
    if relates_to_many?(@current_field)
      facet = @current_field
      table_name = self.table_name
      fields = @relation_search.select_fields(facet)
      fields = "#{table_name}.*, #{fields}"
      having = @relation_search.having(expectation)
      preload(@current_field).select(fields).from("#{table_name}, #{facet}").where("#{table_name}.id = #{facet}.post_id").group("#{table_name}.id").having(having) 
    else
      where("#{@current_field}.#{@relation_search} #{name} #{args[0]}")
    end
    # remember to delegate to super
  end
end

class Relation
  def where(*args)
    if args.size==1
      other = scoped
      other.extend MyRelation
      other.current_field = args[0]
      other
    else
      super(args)
      # mind the block
    end
  end
end