class CreateJournalEntries < ActiveRecord::Migration
  def change
    create_table :journal_entries do |t|
      t.string :tag
      t.string :body
      t.string :file_id
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
