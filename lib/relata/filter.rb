require 'filtered_relation/related_query_methods'
ActiveRecord::Base.send :include, RelatedQueryMethods


# = Filtered Relation
# Create dynamic filters with just onde method.

#  <% form_tag :action => 'filter' do %>
#  Title: <%= text_field_tag 'post[title]' %><br />
#  Only with Comments? 
#  <%= select("post", "comments",   options_for_select({ "false" => "", "true" => "true" })) %> %>
#  
#  def filter
#  @posts = Post.filtered_relation(params[:post]).all
#  end

# Create more advanced relations with DSL.

#  posts = Post.filtered_relation(:comments => true).where(:user_id => 4).limit(3).order("id ASC")    

#  posts.each do |post|  
#  # records
#  end  
module FilteredRelation

  class ::ActiveRecord::Base

    def self.filtered_relation(params) 
      relation = scoped 

      columns = self.columns.map do |c|
         c.name if [:string, :text].include? c.type
      end  
                  
      params.each do |facet, value| 
        if self.reflect_on_association facet.to_sym
          relation = send("filter_by_has_many", facet, value, relation)           
        elsif columns.include? facet.to_s
          relation = send("filter_by_exact", facet, value, relation)
        else    
          relation = send("filter_by_#{facet}", value, relation)         
        end
      end

      relation
    end

    def self.related_to(params) 
      relation = scoped 

      params.each do |facet, value| 
        relation = send("filter_by_related", facet, value, relation) 
      end
      relation
    end

    def self.date_between(params) 
      relation = scoped 
      relation = send("filter_by_date_between", params, relation) 
      relation
    end


  end

end
