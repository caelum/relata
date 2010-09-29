require File.expand_path(File.dirname(__FILE__)) + "/test_helper"
require 'schema'
require 'filtered_relation/dsl'

class DSLTest < ActiveSupport::TestCase
  
  setup do
    setup_db
    @caelum = Post.create :body => "CaelumObjects training and inovation"
    @guilherme = Post.create :body => "Guilherme Silveira"
  end
  
  test "given an attribute and expectation, gives the results" do
    posts = Post.where(:body).like?("%caelum%").all
    assert_equal @caelum, posts[0]
    assert_equal 1, posts.size
  end

  # test "given an attribute and constraint expectation, gives the results" do
  #   posts = Post.where(:body).length.lesser_than(22).all
  #   assert_equal @guilherme, posts[0]
  # end
  
  def custom

     posts = Post.filtered_relation.where(:comments).exists?
     posts = posts.and(:authors).count.lt(3)


     # Post.filtered_relation(:comments_count => >2)
     Post.where("name.size > 2")
   
     r = Post.where(:comments).count.exists?
     r = Post.where(:comments).count.gt(2)
     r = Post.where(:comments).count.gt(2)
     r = Post.where(:body).size.gt(2)
     r = Post.where(:body).like("%a%")
     r = Post.where(:comments).name.like("%a%")
     r = Post.where(:comments).name.gt(2)
     # Author.where(:posts).comments.count.gt(2)
   
   end
end