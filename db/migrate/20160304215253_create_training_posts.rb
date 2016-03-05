class CreateTrainingPosts < ActiveRecord::Migration
  def change
    create_table :training_posts do |t|
      t.text :entry
      t.string :classification

      t.timestamps null: false
    end
  end
end
