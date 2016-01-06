class Pinning < ActiveRecord::Base
  validates_presence_of :board
  belongs_to :user
  belongs_to :pin
  belongs_to :board
end