# in case you did not require the entire relata plugin
module Relata
  module Dsl
  end
end

require 'relata/dsl/conditions'
require 'relata/dsl/constraints'
require 'relata/dsl/field_search'
require 'relata/dsl/querys/multiple'
require 'relata/dsl/querys/simple'
require 'relata/dsl/querys/fields'

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

# a builder ready to collect which field you want to search
class Relata::Dsl::MissedBuilder
  
  def initialize(rel)
    @rel = rel
  end
  
  def method_missing(field, *args)
    if args.size != 0
      relation = @rel.scoped
      relation.extend Relata::Dsl::CustomRelation
      relation.using(@rel, field)
      Relata::Dsl::FieldSearch.new(relation, field).custom(*args)
    else
      relation = @rel.scoped
      relation.extend Relata::Dsl::CustomRelation
      relation.using(@rel, field)
      Relata::Dsl::FieldSearch.new(relation, field)
    end
  end
  
end

module Relata::Dsl::Relation

  # extended where clause that allows symbol and custom dsl lookup
  #
  # examples:
  # where(:body).like?("%guilherme%")
  # where { body.like?("%guilherme%")
  #
  # While the last will delegate to the MissedBuilder component
  # the symbol based query will delegate query builder to CustomRelation.
  def where(*args, &block)
    if args.size==0 && block
      Relata::Dsl::MissedBuilder.new(self).instance_eval(&block)
    elsif args.size==1 && args[0].is_a?(Symbol)
      relation = scoped
      relation.extend Relata::Dsl::CustomRelation
      relation.using(self, args[0])
    else
      super(*args, &block)
    end
  end
end

class ActiveRecord::Relation
  include Relata::Dsl::Relation
end
