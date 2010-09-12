require 'filtered_relation'
require 'rails'

module FilteredRelation
  class Railtie < Rails::Railtie
    railtie_name :filtered_relation

    class ActiveRecord::Base
      class << self
        def self.filtered_relation(params) 
          relation = scoped 

          params.each do |facet, value| 
            relation = send("filter_by_#{facet}", value, relation) 
          end
          relation
        end
        
        def filter_by_content(value, relation) 
          relation.where(:content => value) 
        end
        
        def filter_by_published_at(value, relation) 
          value ? relation.where("published_at < ?", 1.month.ago) : relation 
        end
        
        def self.filter_by_comments(value, relation) 
          if value 
            relation.preload(:comments).select("posts.*, COUNT(comments.id) AS comment_count").from("posts, comments").having("comment_count > 0") 
          else 
            relation 
          end 
        end
      end  
    end
    
  end
end
