class CreateMemeTemplates < ActiveRecord::Migration
  def change
    create_table :meme_templates do |t|
      t.string :name
      t.string :file_name
      t.integer :width
      t.integer :height
      t.timestamps null: false
    end
  end
end
