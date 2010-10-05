# A custom set of conditions that can be applied
# to a query
module Conditions
  def ge(value)
    add_filter(">= #{value}")
  end

  def greater_or_equals(value)
    ge(value)
  end
  
  def gt(value)
    add_filter("> #{value}")
  end

  def greater_than(value)
    gt(value)
  end

  def le(value)
    add_filter("<= #{value}")
  end

  def lt(value)
    add_filter("< #{value}")
  end

  def lesser_than(value)
    lt value
  end

  # whether this relation has at least one element.
  def exists?
    if @relation_search.nil?
      count.exists?
    else
      add_filter("> 0")
    end
  end  
end
