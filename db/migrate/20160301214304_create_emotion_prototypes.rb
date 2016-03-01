class CreateEmotionPrototypes < ActiveRecord::Migration
  def change
    create_table :emotion_prototypes do |t|
      t.string :name
      t.string :description
      t.string :color

      t.timestamps null: false
    end
  end
end
