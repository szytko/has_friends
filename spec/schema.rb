ActiveRecord::Schema.define(:version => 0) do
  begin
    drop_table :users
    drop_table :friendships
    drop_table :friendship_messages
    drop_table :relations_types
    drop_table :friendship_relations
  rescue
  end
  
  create_table :users do |t|
    t.string :login
    t.integer :friends_count, :default => 0, :null => false
  end
  
  create_table :friendships do |t|
    t.references :user, :friend, :friendship_message
    t.string :status
    t.timestamps
  end  
  
  create_table :friendship_messages do |t|
    t.string :body
    t.timestamps
  end
  
  create_table :relation_types do |t|
    t.string :name
    t.timestamps
  end

  create_table :friendship_relation_types do |t|
    t.references :relation, :friendship
    t.timestamps
  end
  
end