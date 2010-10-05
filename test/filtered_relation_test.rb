require File.expand_path(File.dirname(__FILE__)) + "/test_helper"

require 'filtered_relation/filter'
require 'schema'

class FilteredRelationTest < ActiveSupport::TestCase
  setup do
    setup_db
    create_posts
  end   
         
       test "given no values to filtered_relation, gives us all records" do
          assert_equal Post.all, Post.filtered_relation({}).all
        end
       
        test "given a content and comment filter, gives us filtered records - generic" do 
          @base.update_attributes(:content => "picture", :comments => [Comment.create]) 
          assert_equal @base, Post.filtered_relation(:content => "picture", :comments => 'true').first 
        end
        
        test "given a content and comment filter, gives us filtered records" do 
          @base.update_attributes(:content => "picture", :comments => [Comment.create]) 
          assert_equal @base, Post.filtered_relation(:content => "picture").related_to(:comments => true).first 
        end
        
        test "given a date and comment filter, gives us filtered records" do 
          @base.update_attributes(:published_at => 2.years.ago, :comments => [Comment.create]) 
          assert_equal @base, Post.filtered_relation(:published_at => true).related_to(:comments => true).first 
        end 
       
        test "given a date and content filter, gives us filtered records" do 
          @base.update_attribute(:published_at, 2.years.ago) 
          @base.update_attribute(:content, "picture") 
          record = Post.filtered_relation(:published_at => true, :content => "picture").first 
          
          assert_equal @base, record 
        end
        
        test "given two dates, gives us filtered records between this date" do 
          assert_equal @base, Post.date_between(:before => 1.year.ago, :after => Time.now).first 
        end 
        
        test "return a post with same title" do 
          @base.update_attributes(:title => "Post Title") 
          assert_equal @base, Post.filtered_relation(:title => "Post Title").first 
        end
        
        test "return a post with same title and body" do 
          @base.update_attributes(:title => "Post Title", :body => "Ruby") 
          assert_equal @base, Post.filtered_relation(:title => "Post Title", :body => "Ruby").first 
        end
      
  
  def create_posts
    valid_attributes = {
      :body => "Hello.",
      :title => "Hi!",
      :content => "text",
      :user_id => 1,
      :published_at => Time.now
    }
    
    @base = Post.create(valid_attributes)
    @quote = Post.create(valid_attributes.merge(:content => "quote"))
    @number2 = Post.create(valid_attributes.merge(:user_id => 2))
    @old = Post.create(valid_attributes.merge(:published_at => 1.year.ago))
  end
  
  teardown do
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end
  
end
