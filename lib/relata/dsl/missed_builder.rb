# a builder ready to collect which field you want to search
class Relata::Dsl::MissedBuilder
  
  def initialize(rel)
    @rel = rel
  end
  
  def method_missing(field, *args)
    relation = @rel.scoped
    relation.extend Relata::Dsl::CustomRelation
    relation.using(@rel, field)
    
    if relation.relates_to_many?
      type = Relata::Dsl::FieldSearchMany
    else
      type = Relata::Dsl::FieldSearch
    end
    
    instance = type.new(relation, field)
    
    if args.size != 0
      instance = instance.custom(*args)
    end
    
    instance
  end
  
end
