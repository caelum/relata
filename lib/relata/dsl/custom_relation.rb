# defines helper methods to deal with custom relation
module Relata::Dsl::CustomRelation
  include Relata::Dsl::Conditions
  include Relata::Dsl::Constraints
  
  def using(record, field)    
    @record = record
    @current_field = field
    @start_field = field
    @select_fields = ["#{table_name}.*"]
    @groups = []
    
    if relates_to_many?
      self.extend MultipleQuery
      self.extend ModelFields      
    elsif relates_belongs_to?
      self.extend BelongsToQuery
      self.extend ModelFields            
    else
      self.extend SimpleQuery
    end
    
    self
  end



  def relates_to_many?
    check_relation "has_many"
  end
  
  def relates_belongs_to?
    check_relation "belongs_to"
  end
  
  private
  def check_relation type
    @record.reflect_on_all_associations.each do |r|
      if r.name.to_sym.eql? @current_field.to_sym 
        return true if r.macro.to_s.eql? type
      end  
    end  
    false
  end

end
