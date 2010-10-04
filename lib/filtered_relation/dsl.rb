require 'filtered_relation/dsl/conditions'
require 'filtered_relation/dsl/constraints'
require 'filtered_relation/dsl/querys/multiple'
require 'filtered_relation/dsl/querys/simple'
require 'filtered_relation/dsl/querys/fields'

module MyRelation
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
      self.extend ModelFields      
    else
      self.extend SimpleQuery
    end
    
    self
  end

  private
  def relates_to_many?(name)
    @record.reflect_on_association @current_field.to_sym
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