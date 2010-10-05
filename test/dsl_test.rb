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

    posts = Post.where { body.like? "%caelum%" }
    assert_equal @caelum, posts[0]
    assert_equal 1, posts.size
  end
  
  # test "given an attribute and constraint expectation, gives the results" do
  #   posts = Post.where { body < 22 }
  #   assert_equal @guilherme, posts[0]
  #   assert_equal 1, posts.size
  # end
  
  test "exists posts with comments" do
    @caelum.update_attributes(:comments => [Comment.create]) 
    posts = Post.where(:comments).count.exists?
    assert_equal @caelum, posts[0]
    assert_equal 1, posts.size
  end
  
  test "exists posts with comments can be shortcuted with exists?" do
    @caelum.update_attributes(:comments => [Comment.create]) 
    posts = Post.where(:comments).exists?
    assert_equal @caelum, posts[0]
    assert_equal 1, posts.size

    posts = Post.where { comments.exists? }
    assert_equal @caelum, posts[0]
    assert_equal 1, posts.size
  end
  
  test "exists posts with more than 2 comments" do
    @caelum.update_attributes(:comments => [Comment.create, Comment.create, Comment.create]) 
    posts = Post.where(:comments).count.gt(2)
    assert_equal @caelum, posts.first
    assert_equal 3, posts.first.comments.size
  end
  
  test "exists posts with less than 2 comments" do
    @caelum.update_attributes(:comments => [Comment.create]) 
    posts = Post.where(:comments).count.lt(2)
    assert_equal @caelum, posts.first
    assert_equal 1, posts.first.comments.size
  end
  
  test "exists posts with more than or equals 2 comments" do
    @caelum.update_attributes(:comments => [Comment.create, Comment.create]) 
    @guilherme.update_attributes(:comments => [Comment.create, Comment.create, Comment.create])

    posts = Post.where(:comments).count.ge(2).all
    assert_equal 2, posts.size
    assert_equal @caelum, posts[0]
    assert_equal @guilherme, posts[1]
  end
   
  test "dsl query supports first" do
    @caelum.update_attributes(:comments => [Comment.create, Comment.create]) 
    @guilherme.update_attributes(:comments => [Comment.create, Comment.create, Comment.create])

    posts = Post.where(:comments).count.ge(2).first
    assert_equal @caelum, posts
  end
   
  test "all post which commits has some description" do
    comment = Comment.create :description => "dsl test"
    @caelum.update_attributes :comments => [comment]

    posts = Post.where(:comments).description.like?("%dsl test%")
    assert_equal @caelum, posts[0]
    assert_equal 1, posts.size

  end

  test "exists posts using strict extended methods" do
    @caelum.update_attributes(:comments => [Comment.create, Comment.create]) 
    @guilherme.update_attributes(:comments => [Comment.create, Comment.create, Comment.create])
    posts = Post.where { comments >= 2 }
    assert_equal @caelum, posts[0]
    assert_equal 2, posts.size
    assert_equal @guilherme, posts[1]
  end

  test "strict block supports first" do
    @caelum.update_attributes(:comments => [Comment.create, Comment.create]) 
    @guilherme.update_attributes(:comments => [Comment.create, Comment.create, Comment.create])
    post = Post.where { comments >= 2 }.first
    assert_equal @caelum, post
  end

  test "exists posts using range expectations" do
    @caelum.update_attributes :published_at => 1.year.ago
    
    posts = Post.where { published_at.between(2.years.ago, 6.months.ago) }
    assert_equal @caelum, posts[0]
    assert_equal 1, posts.size
  end

  test "all post which commits has some subject" do
    comment = Comment.create :subject => "dsl subject"
    @caelum.update_attributes :comments => [comment]
    posts = Post.where(:comments).subject.like?("%dsl subject%")
    assert_equal @caelum, posts[0]
    assert_equal 1, posts.size
  end
  
  test "accepts two conditions inline" do
    @caelum.update_attributes :published_at => 1.year.ago
    @guilherme.update_attributes :published_at => 1.year.ago
    
    posts = Post.where { 
      published_at.between(2.years.ago, 6.months.ago)
      body.like?("%lum%")
    }
    assert_equal @caelum, posts[0]
    assert_equal 1, posts.size
  end

  test "supports two conditions in dsl mixing everything together" do
    @caelum.update_attributes(:comments => [Comment.create, Comment.create]) 
    @guilherme.update_attributes(:comments => [Comment.create, Comment.create, Comment.create])
    posts = Post.where { comments >= 1 }.where(:body).like?("%lum%")
    assert_equal @caelum, posts[0]
    assert_equal 1, posts.size
  end

  test "supports ==" do
    @caelum.update_attributes(:comments => [Comment.create, Comment.create]) 
    posts = Post.where { comments == 2 }
    assert_equal @caelum, posts[0]
    assert_equal 1, posts.size
  end



  # def pending
    # posts = Post.where { comments.description.like?("%dsl test%") }
    # posts = posts.and(:authors).count.lt(3)
    # Author.where(:posts).comments.count.gt(2)
    
    # support range to numbers
    # support string length
    
   # end

end