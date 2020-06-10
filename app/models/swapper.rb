# frozen_string_literal: true

class Swapper < ApplicationRecord
  belongs_to :user
  
  has_many :products
  has_one_attached :avatar

  validate :accepted_avatar
  
  validates :name,
            :surname,
            :email,
            :date_of_birth,
            :phone_number,
            :address,
            :city,
            :country, presence: true

  enum rating: %w[excellent good mediocre poor terrible]

  ACCEPTED_IMAGE_TYPES = ['image/jpeg', 'image/png'].freeze

  def accepted_avatar
    return unless avatar.attached?
  
    unless avatar.byte_size <= 10.megabyte
      errors.add(:avatar, 'Image size is too big')
    end
  
    unless ACCEPTED_IMAGE_TYPES.include?(avatar.content_type)
      errors.add(:avatar, 'Image must be a JPEG or PNG type')
    end
  end
end
