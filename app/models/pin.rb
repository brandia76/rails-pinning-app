class Pin < ActiveRecord::Base
  validates_presence_of :title, :url, :text, :category_id
  validates_uniqueness_of :title
  
  belongs_to :category 
  has_many :pinnings
  has_many :users, through: :pinnings
  accepts_nested_attributes_for :pinnings
   
  has_attached_file :image, styles: {medium: "300x300>", thumb: "60x60>" }, default_url: "http://placebear.com/300/300"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


end