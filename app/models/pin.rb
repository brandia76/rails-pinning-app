class Pin < ActiveRecord::Base
  validates_presence_of :title, :url, :slug, :text, :category_id, :image
  validates_uniqueness_of :slug
  
  has_attached_file :image, styles: {medium: "300x300>", thumb: "60x60>" }, default_url: "http://placebear.com/300/300"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  #validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]
  #do_not_validate_attachment_file_type :image

  belongs_to :category
end