require File.expand_path(File.dirname(__FILE__)) + "/test_helper"
require 'filtered_relation/dsl'

class DSLTest < ActiveSupport::TestCase
  def custom

     posts = Post.filtered_relation.where(:comments).exists?
     posts = posts.and(:authors).count.lt(3)


     # Post.filtered_relation(:comments_count => >2)
     Post.where("name.size > 2")
   
     r = Post.where(:comments).count.exists?
     r = Post.where(:comments).count.gt(2)
     r = Post.where(:comments).count.gt(2)
     r = Post.where(:name).size.gt(2)
     r = Post.where(:name).like("%a%")
     r = Post.where(:comments).name.like("%a%")
     r = Post.where(:comments).name.gt(2)
     # Author.where(:posts).comments.count.gt(2)
   
   end
end