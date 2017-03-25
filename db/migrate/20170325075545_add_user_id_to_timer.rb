class AddUserIdToTimer < ActiveRecord::Migration
  def change
    add_column :timers, :user_id, :integer
    add_index  :timers, :user_id
  end
end
