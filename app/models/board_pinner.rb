class BoardPinner < ActiveRecord::Base
  belongs_to :user
  belongs_to :board
  
  validates_presence_of :user_id, :board_id
end
