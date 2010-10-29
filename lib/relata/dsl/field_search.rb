# = Field Search
# a relation search in a specific field
class Relata::Dsl::FieldSearch
  
  def initialize(rel, field)
    @rel = rel
    @field = field
  end

  # Exactly number of relation or field value
  #  Post.where { body == "CaelumObjects training and inovation" }
  #  Post.where { comments == 2 }
  def ==(value)
    @rel.where("#{@field} == ?", value)
  end

  # All records with different field value
  #  Post.where { comments != 2 }
  # def !=(value)
  #   @rel.where("#{@field} <> ?", value)
  # end

  # All records with higher or equal number of relations
  #  Post.where { comments >= 2 }
  def >=(value)
    @rel.where("#{@field} >= ?", value)
  end
  
  # All records with less or equal number of relations
  #  Post.where { comments <= 2 }  
  def <=(value)
    @rel.where("#{@field} <= ?", value)
  end

  # All records with higher number of relations
  #  Post.where { comments > 2 }    
  def >(value)
    @rel.where("#{@field} > ?", value)
  end

  # All records with lesser number of relations
  #  Post.where { comments < 2 }      
  def <(value)
    @rel.where("#{@field} < ?", value)
  end
  
  # Find records by field value
  #  Post.where(:body).like?("%caelum%")    
  def like?(value)
    @rel.where(@field).like?(value)
  end
  
  # Find record with date between 
  #  Post.where { published_at.between(2.years.ago, 6.months.ago) }
  def between(first, second)
    @rel.where("#{@field} > ? and #{@field} < ?", first, second)
  end

  # Find records by size
  #  Post.where { body.length < 22 }  
  def length
    @field = "length(#{@field})"
    self
  end

  # Your custom relation
  #  Post.where { body "like ?", "%lum%" }
  def custom(*args)
    comparison = args.shift
    @rel.where("#{@field} #{comparison}", args)
  end

end

class Relata::Dsl::FieldSearchMany
  
  def initialize(rel, field)
    @rel = rel
    @field = field
  end

  def ==(value)
    @rel.where(@field).count.eq(value)
  end

  def >=(value)
    @rel.where(@field).count.ge(value)
  end
  
  def <=(value)
    @rel.where(@field).count.le(value)
  end
  
  def >(value)
    @rel.where(@field).count.gt(value)
  end
  
  def <(value)
    @rel.where(@field).count.lt(value)
  end
  
  def exists?
    @rel.where(@field).exists?
  end
  
  def custom(*args)
    comparison = args.shift
    @rel.where("#{@field} #{comparison}", args)
  end

end
