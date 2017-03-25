class AddDescToTimer < ActiveRecord::Migration
  def change
    add_column :timers, :desc, :text, default: ''
  end
end
