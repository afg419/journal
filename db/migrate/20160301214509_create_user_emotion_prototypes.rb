class CreateUserEmotionPrototypes < ActiveRecord::Migration
  def change
    create_table :user_emotion_prototypes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :emotion_prototype, index: true, foreign_key: true
      t.string :status, default: "active"

      t.timestamps null: false
    end
  end
end
