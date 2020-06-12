# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :swapper
  
  has_many_attached :images

  ACCEPTED_IMAGE_TYPES = [
    'application/pdf', 
    'image/jpeg', 
    'image/png'
  ].freeze

  validates :images, attached: true, 
                     content_type: ACCEPTED_IMAGE_TYPES,
                     dimension: { min: 1500..500, max: 1500..500 },
                     on: :upload_images

  validates :category, :title, :description, :department, presence: true

  scope :by_swapper, -> (swapper_id) { where(swapper_id: swapper_id) }
  scope :by_category, -> (category) { where(category: category) }
  scope :by_department, -> (department) { where(department: department) }
end
