class AddFolderIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :folder_id, :string, default: "No Folder"
  end
end
