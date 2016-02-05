class Image < ActiveRecord::Base
  has_attached_file :url, styles: { _100x100c: "100x100", _1150x850d: "1150x850>" }, 
                          convert_options: { _100x100c: "-quality 90",_1150x850d: '-quality 90' }
  crop_attached_file :url
  validates_attachment_content_type :url, content_type: /\Aimage\/.*\Z/
  belongs_to :simple_block
end