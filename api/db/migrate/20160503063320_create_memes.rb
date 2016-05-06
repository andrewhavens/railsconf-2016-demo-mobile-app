class CreateMemes < ActiveRecord::Migration
  def change
    create_table :memes do |t|
      t.string :top_text
      t.string :bottom_text
      t.belongs_to :meme_template, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
