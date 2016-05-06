class AddUserIdToMemes < ActiveRecord::Migration
  def change
    add_reference :memes, :user, index: true, foreign_key: true
  end
end
