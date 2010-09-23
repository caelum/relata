require File.expand_path(File.dirname(__FILE__)) + "/test_helper"

require 'active_record'
require 'filtered_relation/filter'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "test.sqlite3")

def setup_db
  
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
    
    
  ActiveRecord::Schema.define(:version => 1) do

     create_table :posts do |t|
        t.string :body
        t.string :title
        t.text :content
        t.integer :user_id
        t.datetime :published_at
        t.timestamps
      end

      create_table :users do |t|
        t.timestamps
      end
      
      create_table :comments do |t|
        t.text :description
        t.integer :post_id
        t.timestamps
      end
      
  end
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
end

class User < ActiveRecord::Base
  has_many :posts
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class FilteredRelationTest < ActiveSupport::TestCase
  setup do
    setup_db
    create_posts
  end
  
  test "given no values to filtered_relation, gives us all records" do
     assert_equal Post.all, Post.filtered_relation({}).all
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
