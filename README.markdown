#FilteredRelation#

Making dynamic filters easier with a nice ActiveRecord DSL. 

## Filter Example ##

	posts = Post.filtered_relation(:comments => true).where(:user_id => 4).limit(3).order("id ASC")    

	posts.each do |post|  
		# records
	end  

## DSL API ##

 	Post.where(:comments).description.like?("%dsl test%")