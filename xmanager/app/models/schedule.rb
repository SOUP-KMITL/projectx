require 'active_record'

module XM
  module Models
    class Schedule < ActiveRecord::Base
      ActiveRecord::Base.establish_connection adapter: 'sqlite3',
        database: File.expand_path('../../../schedules/schedules.db', __FILE__)

      self.inheritance_column = nil
    end
  end
end
