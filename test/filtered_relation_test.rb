require 'test_helper'

class FilteredRelationTest < ActiveSupport::TestCase
  setup do
    create_posts
  end
  
  test "filtro em branco devolve todos os posts" do
    assert_equal Post.all, Post.filtered_relation({}).all
  end
  
  test "given a content and comment filter, gives us filtered records" do 
    @base.update_attribute(:content, "picture") 
    assert_equal @base, Post.filtered_relation(:content => "picture", :comments => true).first 
  end
  
  test "given a date and comment filter, gives us filtered records" do 
    @base.update_attribute(:published_at, 2.years.ago) 
    assert_equal @base, Post.filtered_relation(:published_at => true, :comments => true).first 
  end 

  test "given a date and content filter, gives us filtered records" do 
    @base.update_attribute(:published_at, 2.years.ago) 
    @base.update_attribute(:content, "picture") 
    record = Post.filtered_relation(:published_at => true, :content => "picture").first 
    
    assert_equal @base, record 
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
    @old = Post.create(valid_attribtues.merge(:published_at => 1.year.ago))
  end
end
