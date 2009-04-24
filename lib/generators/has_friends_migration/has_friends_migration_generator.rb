class HasFriendsMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template "create_has_friends_tables.rb", "db/migrate"
    end
  end
  
  def file_name
    "create_has_friends_tables"
  end
end