class CreateAppMessages < ActiveRecord::Migration
  def change
    create_table :app_messages do |t|
      t.text :message
      t.references :user, index: true, foreign_key: true
      t.integer :status

      t.timestamps null: false
    end
  end
end
