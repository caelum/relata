require 'filtered_relation/dsl/conditions'
require 'filtered_relation/dsl/constraints'
require 'filtered_relation/dsl/querys/multiple'
require 'filtered_relation/dsl/querys/simple'

module FilteredRelation
  module Dsl
  end
end

module FilteredRelation::Dsl::CustomRelation
  include Conditions
  include Constraints
  
  def using(record, field)    
    @record = record
    @current_field = field
    @start_field = field
    @select_fields = ["#{table_name}.*"]
    @groups = []
    
    if relates_to_many? field
      self.extend MultipleQuery
    else
      self.extend SimpleQuery
    end
    
    self
  end
    
  def description
    @current_field = "#{@current_field}.description"
    self
  end

  private
  def relates_to_many?(name)
    @record.reflect_on_association @current_field.to_sym
  end

end

module FilteredRelation::Dsl::Relation

  # extended where clause that allows symbol lookup
  def where(*args, &block)
    if args.size==1 && args[0].is_a?(Symbol)
      relation = scoped
      relation.extend FilteredRelation::Dsl::CustomRelation
      relation.using(self, args[0])
    else
      super(*args, &block)
    end
  end
end

class ActiveRecord::Relation
  include FilteredRelation::Dsl::Relation
end
