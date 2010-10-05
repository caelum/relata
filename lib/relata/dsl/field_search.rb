# a relation search in a specific field
class Relata::Dsl::FieldSearch
  
  def initialize(rel, field)
    @rel = rel
    @field = field
  end

  def ==(value)
    @rel.where("#{@field} == ?", value)
  end

  def >=(value)
    @rel.where("#{@field} >= ?", value)
  end
  
  def <=(value)
    @rel.where("#{@field} <= ?", value)
  end
  
  def >(value)
    @rel.where("#{@field} > ?", value)
  end
  
  def <(value)
    @rel.where("#{@field} < ?", value)
  end
  
  def like?(value)
    @rel.where(@field).like?(value)
  end
  
  def between(first, second)
    @rel.where("#{@field} > ? and #{@field} < ?", first, second)
  end
  
  def length
    @field = "length(#{@field})"
    self
  end
  
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
