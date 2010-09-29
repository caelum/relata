module RelatedQueryMethods
  
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

      def filter_by_related(facet, value, relation) 
        if value 
          relation.preload(facet).select("posts.*, COUNT(#{facet}.id) AS comment_count").from("posts, #{facet}").group("posts.id").having("comment_count > 0") 
        else 
          relation 
        end 
      end

      def filter_by_comments(value, relation) 
        p "comments => #{value.to_s} \o/"
        
        if !value.empty?
          relation.preload(:comments).select("posts.*, COUNT(comments.id) AS comment_count").from("posts, comments").where("posts.id = comments.post_id").group("posts.id").having("comment_count > 0") 
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