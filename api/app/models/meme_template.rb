class MemeTemplate < ActiveRecord::Base
  def file_path
    Rails.root.join('public', 'images', file_name)
  end
end
