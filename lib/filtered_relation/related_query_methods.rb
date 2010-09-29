module RelatedQueryMethods
  
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

      def filter_by_has_many(facet, value, relation) 
        
        table_name = self.table_name

        if !value.empty?
          relation.preload(facet).select("#{table_name}.*, COUNT(#{facet}.id) AS count").from("#{table_name}, #{facet}").where("#{table_name}.id = #{facet}.post_id").group("#{table_name}.id").having("count > 0") 
        else 
          relation 
        end 
      end

      def filter_by_related(facet, value, relation) 
        if value 
          relation.preload(facet).select("posts.*, COUNT(#{facet}.id) AS comment_count").from("posts, #{facet}").group("posts.id").having("comment_count > 0") 
        else 
          relation 
        end 
      end

      def filter_by_content(value, relation) 
        !value.empty? ? relation.where(:content => value) : relation
      end

      def filter_by_published_at(value, relation) 
        value ? relation.where("published_at < ?", 1.month.ago) : relation 
      end
      
      def filter_by_date_between(params, relation) 
        relation.where("published_at < ?", params[:before])
        relation.where("published_at > ?", params[:after])
        relation
      end

  end
    
end