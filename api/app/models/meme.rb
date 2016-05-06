class Meme < ActiveRecord::Base
  belongs_to :user
  belongs_to :meme_template

  after_save do
    new_file_path = Rails.root.join('public', 'images', 'generated', "#{id}.jpg")
    LeMeme::Meme.new(meme_template.file_path, top: top_text, bottom: bottom_text).to_file(new_file_path)
  end
end
