# = Constraints
# A custom set of constraints that can be applied
# to a query
module Relata::Dsl::Constraints
  
  # Return all objects which fields by size
  #  Post.where { body.length < 22 }
  def length
    @relation_search = LengthManager
    self
  end
  
  def count
    @select_fields << "COUNT(#{@current_field}.id) AS count"
    @groups << "#{table_name}.id"
    @relation_search = 'count'
    self
  end

  # Return all objects which match with parameter
  #  Post.where(:body).like?("%caelum%")
  def like?(value)
    query.where("#{@current_field} like ?", [value])
  end
 
  # Return all objects whith nil value fields
  #  Post.where(:body).is_null
  def is_null
    query.where("#{@current_field} is NULL")
  end
  
  # def between(first, second)
  #   @relation_search = SimpleRangeCondition
  #   self
  #   # query.where("#{@current_field} like ?", [value])
  #   # add_filter("> #{first}").add_filter("< #{second}")
  # end
  
  class LengthManager
    def self.condition(field, *args)
      "len(field)"
    end
  end
  
  class SimpleCondition
    def self.condition(field, *args)
      "#{field}"
    end
  end

  class SimpleRangeCondition
    def self.condition(field, *args)
      "#{field} > #{args[0]} AND #{field} < #{args[1]}"
    end
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