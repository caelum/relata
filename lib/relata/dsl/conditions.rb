# = Conditions
# A custom set of conditions that can be applied
# to a query
module Relata::Dsl::Conditions

  # Return all objects whith exactly X associated objects
  #  Post.where(:comments).count.eq(2)
  def eq(value)
    add_filter("= #{value}")
  end

  # Return all objects whith more or exactly X associated objects
  #  Post.where(:comments).count.ge(2)
  def ge(value)
    add_filter(">= #{value}")
  end

  # Return all objects whith more or exactly X associated objects
  #  Post.where(:comments).count.greater_or_equals(2)
  def greater_or_equals(value)
    ge(value)
  end
  
  # Return all objects whith more than X associated objects
  #  Post.where(:comments).count.gt(2)
  def gt(value)
    add_filter("> #{value}")
  end

  # Return all objects whith more than X associated objects
  # Alias for "gt"
  #  Post.where(:comments).count.greater_than(2)
  def greater_than(value)
    gt(value)
  end

  # Return all objects whith less or equals X associated objects
  #  Post.where(:comments).count.le(2)
  def le(value)
    add_filter("<= #{value}")
  end

  # Return all objects whith less than X associated objects
  #  Post.where(:comments).count.lt(2)
  def lt(value)
    add_filter("< #{value}")
  end

  # Return all objects whith less than X associated object
  # Alias for "lt"
  #  Post.where(:comments).count.lesser_than(2)
  def lesser_than(value)
    lt value
  end

  # Whether this relation has at least one element.
  #  Post.where(:comments).exists?
  def exists?
    if @relation_search.nil?
      count.exists?
    else
      add_filter("> 0")
    end
  end  
end
