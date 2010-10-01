module Constraints
  
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
    @select_fields << "COUNT(#{@current_field}.id) AS count"
    @groups << "#{table_name}.id"
    @relation_search = 'count'
    self
  end

  def like?(value)
    query.where("#{@current_field} like ?", [value])
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