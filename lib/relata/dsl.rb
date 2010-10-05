# in case you did not require the entire relata plugin
module Relata
  module Dsl
  end
end

require 'relata/dsl/conditions'
require 'relata/dsl/constraints'
require 'relata/dsl/custom_relation'
require 'relata/dsl/field_search'
require 'relata/dsl/missed_builder'
require 'relata/dsl/querys/multiple'
require 'relata/dsl/querys/simple'
require 'relata/dsl/querys/fields'

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
