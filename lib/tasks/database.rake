require 'active_record/connection_adapters/postgresql_adapter'
module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter < AbstractAdapter
      def drop_database(name)
        raise "Nah, I won't drop the production database" if Rails.env.production?
        execute <<-SQL
          UPDATE pg_catalog.pg_database
          SET datallowconn=false WHERE datname='#{name}'
        SQL
        puts self.postgresql_version
        if self.postgresql_version > 90300
        execute <<-SQL
          SELECT pg_terminate_backend(pg_stat_activity.pid)
          FROM pg_stat_activity
          WHERE pg_stat_activity.datname = '#{name}';
        SQL
        else
        execute <<-SQL
          SELECT pg_terminate_backend(pg_stat_activity.procpid)
          FROM pg_stat_activity
          WHERE pg_stat_activity.datname = '#{name}';
        SQL
        end
        execute "DROP DATABASE IF EXISTS #{quote_table_name(name)}"
      end
    end
  end
end