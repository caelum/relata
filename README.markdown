#FilteredRelation#

Making dynamic filters easier with a nice ActiveRecord DSL. 

## Filter Example ##

	Create dynamic filters with just onde method.
	
	<% form_tag :action => 'filter' do %>
	  	Title: <%= text_field_tag 'post[title]' %><br />
	  	Body: <%= text_field_tag 'post[body]' %><br />
	  	Content: <%= text_field_tag 'post[content]' %><br />
	  	Only with Comments? 
	        <%= select("post", "comments",   options_for_select({ "false" => "", "true" => "true" })) %>
	%>

	def filter
	  @posts = Post.filtered_relation(params[:post]).all
	end

	Create more advanced relations.
	
	posts = Post.filtered_relation(:comments => true).where(:user_id => 4).limit(3).order("id ASC")    

	posts.each do |post|  
		# records
	end  

## DSL API ##

 	Post.where(:comments).description.like?("%dsl test%")