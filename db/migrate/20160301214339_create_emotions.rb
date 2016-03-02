class CreateEmotions < ActiveRecord::Migration
  def change
    create_table :emotions do |t|
      t.integer :score
      t.references :journal_entry, index: true, foreign_key: true
      t.references :emotion_prototype, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
