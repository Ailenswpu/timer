class User < ActiveRecord::Base
  has_many :timers
end
