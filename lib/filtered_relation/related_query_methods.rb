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
        if value 
          relation.preload(:comments).select("posts.*, COUNT(comments.id) AS comment_count").from("posts, comments").group("posts.id").having("comment_count > 0") 
        else 
          relation 
        end 
      end

      def filter_by_content(value, relation) 
        relation.where(:content => value) 
      end

      def filter_by_published_at(value, relation) 
        value ? relation.where("published_at < ?", 1.month.ago) : relation 
      end

  end
    
end