# a builder ready to collect which field you want to search
class Relata::Dsl::MissedBuilder
  
  def initialize(rel)
    @rel = rel
  end
  
  def method_missing(field, *args)
    relation = @rel.scoped
    relation.extend Relata::Dsl::CustomRelation
    relation.using(@rel, field)
    if args.size != 0
      Relata::Dsl::FieldSearch.new(relation, field).custom(*args)
    else
      Relata::Dsl::FieldSearch.new(relation, field)
    end
  end
  
end
