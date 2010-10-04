module ModelFields
  
  def self.extended(base)
    # now...get from ActiveRecord::Associations
    @fields = ['description']
    
    @fields.each do |field|
      include_method field
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