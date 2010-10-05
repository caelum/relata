# a relation search in a specific field
class Relata::Dsl::FieldSearch
  
  def initialize(rel, field)
    @rel = rel
    @field = field
  end

  def ==(value)
    if @rel.relates_to_many?
      @rel.where(@field).count.eq(value)
    else
      @rel.where("#{@field} == ?", value)
    end
  end

  def >=(value)
    if @rel.relates_to_many?
      @rel.where(@field).count.ge(value)
    else
      @rel.where("#{@field} >= ?", value)
    end
  end
  
  def <=(value)
    if @rel.relates_to_many?
      @rel.where(@field).count.le(value)
    else
      @rel.where("#{@field} <= ?", value)
    end
  end
  
  def >(value)
    if @rel.relates_to_many?
      @rel.where(@field).count.gt(value)
    else
      @rel.where("#{@field} > ?", value)
    end
  end
  
  def <(value)
    if @rel.relates_to_many?
      @rel.where(@field).count.lt(value)
    else
      @rel.where("#{@field} < ?", value)
    end
  end
  
  def like?(value)
    @rel.where(@field).like?(value)
  end
  
  def exists?
    @rel.where(@field).exists?
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
