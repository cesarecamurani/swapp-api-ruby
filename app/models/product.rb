# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :swapper
  
  has_many_attached :images

  validate :accepted_images

  validates :category, :title, :description, presence: true

  scope :by_swapper, -> (swapper_id) { where(swapper_id: swapper_id) }
  scope :by_category, -> (category) { where(category: category) }

  ACCEPTED_IMAGE_TYPES = ['image/jpeg', 'image/png'].freeze

  def accepted_images
    return unless images.attached?
  
    unless images.byte_size <= 10.megabyte
      errors.add(:images, 'Image size is too big')
    end
  
    unless ACCEPTED_IMAGE_TYPES.include?(images.content_type)
      errors.add(:images, 'Image must be a JPEG or PNG type')
    end
  end
end
