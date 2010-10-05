module ModelFields
  
  def self.extended(base)
    
    base.reflect_on_all_associations.each do |r|
      @fields = r.klass.columns.map do |c|
        c.name if [:string, :text].include? c.type
      end  
    end  
    
    @fields.each do |field|
      include_method field if field != nil
    end  
     
  end
 
  private
  def self.include_method(field)
    define_method field do 
      @current_field = "#{@current_field}.#{field}"
      self
    end
  end
  
end