class SimpleBlock < ActiveRecord::Base
  
  belongs_to :page
  acts_as_list scope: :page

  styles = { 
    medium: "300x300>", 
    big: "1024x1024#",
    big_standard: "1080x720",
    big_hq: "1600x1200"
  }

  convert_options = {
    medium: '-quality 75 -strip',
    big: '-quality 90 -strip',
    big_standard: '-quality 90 -strip',
    big_hq: '-quality 90 -strip',
  }

  has_attached_file :background_image, styles: styles, convert_options: convert_options
   
  validates_attachment_content_type :background_image, content_type: /\Aimage\/.*\Z/
  
  has_many :links, dependent: :destroy
  has_many :images, dependent: :destroy

  translates :title, :content, :action
  globalize_accessors locales: I18n.available_locales, attributes: [:title, :content]
  validates :custom_type, presence: true, inclusion: { in: %w(products-block text-with-image links-block gallery slider) }
  
  accepts_nested_attributes_for :links, allow_destroy: true
  accepts_nested_attributes_for :images, allow_destroy: true


  def custom_type_label
    map = {
      'products-block' => 'Products',
      'text-with-image' => 'Text',
      'image-block' => 'Images',
      'links-block' => 'Links',
      'gallery' => 'Gallery',
      'slider' => 'Slider'
    }
    "#{map[self.custom_type]} block"
  end

  def name_of_view
    if custom_type.include? '-'
      custom_type.tr!('-', '_')
    else
      custom_type
    end
  end

  def operas
    tag = self.title
    if tag.present?
      tags = tag.split(" ")
      Opera.tagged_with(tags, any: true).where(website: self.page.website).order('archive_index')
    else
      Opera.where(website: self.page.website).order('archive_index')
    end
  end

  def css_class
    css_class_custom = ''
    [
      ['block-background-photo', self.background_image.present?],
      ['block-colors-inverted', self.colors_inverted]
    ].each do |option|
      css_class_custom += "#{option[0]} " if option[1] == true
    end
    css_class_custom
  end

  def get_sliding_full_screen_margin_bottom
    return 0 if self.sliding_full_screen_margin_bottom.blank?
    self.sliding_full_screen_margin_bottom
  end

  # Alias for sliding (used in form _gallery)
  def masonry_selected
    self.sliding
  end
end