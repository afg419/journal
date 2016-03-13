class AddColumnToAppMessages < ActiveRecord::Migration
  def change
    add_column :app_messages, :links, :text
  end
end
