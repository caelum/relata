# defines helper methods to deal with custom relation
module Relata::Dsl::CustomRelation
  include Conditions
  include Constraints
  
  def using(record, field)    
    @record = record
    @current_field = field
    @start_field = field
    @select_fields = ["#{table_name}.*"]
    @groups = []
    if relates_to_many?
      self.extend MultipleQuery
      self.extend ModelFields      
    else
      self.extend SimpleQuery
    end
    
    self
  end

  def relates_to_many?
    @record.reflect_on_association @current_field.to_sym
  end

end
