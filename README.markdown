#Relata#

Helps poking around with relationships when using ARel. 

## Install ##

	gem install relata

## DSL API ##

If you want to use the DSL, you need to require it first:

	require 'relata/dsl'

Now you are ready to *wherize* everything.
First things first, querying a field:

	Post.where(:body).like?("%caelum%")
	
Proc style querying: select all posts which comment count is >= 2:

	Post.where { comments >= 2 }
	
Between, dsl style, no strings attached:

	Post.where { published_at.between(2.years.ago, 6.months.ago) }

Now querying a relationship count. No joins exposed:

	Post.where(:comments).count.exists?

Coming next, greater and lesser than:

	Post.where(:comments).count.gt(2)

	Post.where(:comments).count.lt(2)

Like:

 	Post.where(:comments).description.like?("%filtered%")

 	Post.where(:comments).subject.like?("%filtered%")

	Post.where(:user).name.like?("anderson")
	
	Post.where(:comments).description.like?("%dsl test%")
	
## Filter Example ##

Create dynamic filters with just one method.

	<% form_tag :action => 'filter' do %>
	  	Title: <%= text_field_tag 'post[title]' %><br />
	  	Only with Comments? 
	        <%= select("post", "comments",   options_for_select({ "false" => "", "true" => "true" })) %> %>

	def filter
	  @posts = Post.filtered_relation(params[:post]).all
	end

You can filter out different and more advanced relations:

	posts = Post.filtered_relation(:comments => true).where(:user_id => 4).limit(3).order("id ASC")    

	posts.each do |post|  
		# records
	end  