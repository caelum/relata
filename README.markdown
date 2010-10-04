#FilteredRelation#

Making dynamic filters easier with a nice ActiveRecord DSL. 

## Filter Example ##

Create dynamic filters with just onde method.
	
	<% form_tag :action => 'filter' do %>
	  	Title: <%= text_field_tag 'post[title]' %><br />
	  	Only with Comments? 
	        <%= select("post", "comments",   options_for_select({ "false" => "", "true" => "true" })) %> %>

	def filter
	  @posts = Post.filtered_relation(params[:post]).all
	end

Create more advanced relations.
	
	posts = Post.filtered_relation(:comments => true).where(:user_id => 4).limit(3).order("id ASC")    

	posts.each do |post|  
		# records
	end  

## DSL API ##

	Post.where(:body).like?("%caelum%")

	Post.where(:comments).count.exists?

	Post.where(:comments).count.gt(2)

	Post.where(:comments).count.lt(2)

 	Post.where(:comments).description.like?("%filtered%")

 	Post.where(:comments).subject.like?("%filtered%")

	Post.where { comments >= 2 }
	
	Post.where { published_at.between(2.years.ago, 6.months.ago) }
    