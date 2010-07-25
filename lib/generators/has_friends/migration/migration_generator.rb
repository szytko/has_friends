require 'generators/has_friends'

module HasFriends
  module Generators
    class MigrationGenerator < Base
      desc "Generate has_friends migration"
      
      def create_migration_file
        migration_template "create_has_friends_tables.rb", File.join('db', 'migrate', "create_has_friends_tables.rb")
      end
      
    end
  end
end