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
    
    if relates_to_many?
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
  
  def relates_to_many?
    @record.reflect_on_association @current_field.to_sym
  end

end

class FilteredRelation::Dsl::MissedBuilder
  
  def initialize(rel)
    @rel = rel
  end
  
  def >=(value)
    @rel.where(@what).count.ge(value)
  end
  
  def like?(value)
    puts "ha #{@what}"
    @rel.where(@what).like?(value)
  end
  
  def exists?
    @rel.where(@what).exists?
  end
  
  # TODO separate constraints from parameters:
  # TODO in this one, parameters are method_missing
  # TODO in another one, contraints are method_missing
  # TODO this way its easier to implement all of them at once
  
  def method_missing(symbol, *args)
    @what = symbol
    self
  end
  
end

module FilteredRelation::Dsl::Relation

  # extended where clause that allows symbol lookup
  def where(*args, &block)
    if args.size==0 && block
      FilteredRelation::Dsl::MissedBuilder.new(self).instance_eval(&block)
    elsif args.size==1 && args[0].is_a?(Symbol)
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
