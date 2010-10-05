require File.expand_path(File.dirname(__FILE__)) + "/test_helper"
require 'schema'
require 'relata/dsl'

class DSLTest < ActiveSupport::TestCase
  
  setup do
    setup_db
    @caelum = Post.create :body => "CaelumObjects training and inovation"
    @guilherme = Post.create :body => "Guilherme Silveira"
  end

  test "all post which commits has some subject" do
      comment = Comment.create :subject => "dsl subject"
      @caelum.update_attributes :comments => [comment]
      posts = Post.where(:comments).subject.like?("%dsl subject%")
      assert_equal @caelum, posts[0]
      assert_equal 1, posts.size
    end

    test "all post which commits has some description" do
      comment = Comment.create :description => "dsl test"
      @caelum.update_attributes :comments => [comment]

      posts = Post.where(:comments).description.like?("%dsl test%")
      assert_equal @caelum, posts[0]
      assert_equal 1, posts.size

    end

    test "all post which commits has some subject and another has_many relation" do
      reader = Reader.create :name => "anderson"
      comment = Comment.create :subject => "dsl subject"
      @caelum.update_attributes :comments => [comment], :readers => [reader]
      posts = Post.where(:comments).subject.like?("%dsl subject%")
      assert_equal @caelum, posts[0]
      assert_equal 1, posts.size
    end

    test "exists posts for a specific reader name" do
      user = User.create :name => "anderson"
      @caelum.update_attributes(:user => user) 
      posts = Post.where(:user).name.like?("anderson")
      assert_equal @caelum, posts[0]
      assert_equal 1, posts.size
    end

end  