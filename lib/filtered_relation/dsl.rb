module MyConditions
  def gt(value)
    add_filter("> #{value}")
  end
  def greater_than(value)
    gt(value)
  end

  def lt(value)
    add_filter("< #{value}")
  end
  def lesser_than(value)
    lt value
  end

  def exists?
    add_filter("> 0")
  end
  
end

module MyConstraints
  
  def length
    @relation_search = LengthManager
    self
  end
  
  class LengthManager
    def self.condition(field)
      "len(field)"
    end
  end

  def count
    @relation_search = CountManager
    self
  end

  def like?(value)
    where("#{@current_field} like ?", [value])
  end
  
  class RangeManager
    def self.select_fields(facet)
      "COUNT(#{facet}.id) AS count"
    end
    def self.having(expectation)
      "count #{expectation}"
    end
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
  def using(record, field)
    @record = record
    @current_field = field
    self
  end
  
  include MyConditions
  include MyConstraints

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
    table_name = self.table_name
    if relates_to_many?(@current_field)
      facet = @current_field
      fields = @relation_search.select_fields(facet)
      fields = "#{table_name}.*, #{fields}"
      having = @relation_search.having(expectation)
      preload(@current_field).select(fields).from("#{table_name}, #{facet}").where("#{table_name}.id = #{facet}.post_id").group("#{table_name}.id").having(having) 
    else
      where("#{@relation_search.condition(@current_field.to_s)} #{expectation}")
    end
    # remember to delegate to super
  end
end

class ActiveRecord::Relation
  def where(*args, &block)
    if args.size==1 && args[0].is_a?(Symbol)
      relation = scoped
      relation.extend MyRelation
      relation.using(self, args[0])
    else
      super(*args, &block)
    end
  end
end