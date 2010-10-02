require File.expand_path(File.dirname(__FILE__)) + "/test_helper"
require 'schema'
require 'filtered_relation/dsl'

class DSLTest < ActiveSupport::TestCase
  
  setup do
    setup_db
    @caelum = Post.create :body => "CaelumObjects training and inovation"
    @guilherme = Post.create :body => "Guilherme Silveira"
    @base = Post.create
    @second = Post.create
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
  
  test "exists posts with comments" do
    @base.update_attributes(:comments => [Comment.create]) 
    posts = Post.where(:comments).count.exists?
    assert_equal @base, posts[0]
    assert_equal 1, posts.size
  end
  
  test "exists posts with comments can be shortcuted with exists?" do
    @base.update_attributes(:comments => [Comment.create]) 
    posts = Post.where(:comments).exists?
    assert_equal @base, posts[0]
    assert_equal 1, posts.size
  end
  
  test "exists posts with more than 2 comments" do
    @base.update_attributes(:comments => [Comment.create, Comment.create, Comment.create]) 
    posts = Post.where(:comments).count.gt(2)
    assert_equal @base, posts.first
    assert_equal 3, posts.first.comments.size
  end
  
  test "exists posts with less than 2 comments" do
    @base.update_attributes(:comments => [Comment.create]) 
    posts = Post.where(:comments).count.lt(2)
    assert_equal @base, posts.first
    assert_equal 1, posts.first.comments.size
  end
  
  test "exists posts with more than or equals 2 comments" do
    @base.update_attributes(:comments => [Comment.create, Comment.create]) 
    @second.update_attributes(:comments => [Comment.create, Comment.create, Comment.create])
    posts = Post.where(:comments).count.ge(2)
    assert_equal @base, posts[0]
    assert_equal @second, posts[1]
    assert_equal 2, posts.size
  end
   
  test "all post which commits has some description" do
    comment = Comment.create :description => "dsl test"
    @base.update_attributes :comments => [comment]
    posts = Post.where(:comments).description.like?("%dsl test%")
    assert_equal @base, posts[0]
    assert_equal 1, posts.size
  end

  test "exists posts using strict extended methods" do
    @base.update_attributes(:comments => [Comment.create, Comment.create]) 
    @second.update_attributes(:comments => [Comment.create, Comment.create, Comment.create])
    posts = Post.where { comments >= 2 }
    assert_equal @base, posts[0]
    assert_equal @second, posts[1]
    assert_equal 2, posts.size
  end
   
  def pending
     # posts = posts.and(:authors).count.lt(3)
     # Post.where(:comments_count => >2)
     # Post.where("name.size > 2")
     # r = Post.where(:body).size.gt(2)
     # r = Post.where(:body).like("%a%")
     # r = Post.where(:comments).description.like("%a%")
     # r = Post.where(:comments).name.gt(2)
     # Author.where(:posts).comments.count.gt(2)
   end
end