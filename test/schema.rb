require 'active_record'

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
