# frozen_string_literal: true

class Swapper < ApplicationRecord
  belongs_to :user
  
  has_many :products, dependent: :destroy
  has_one_attached :avatar

  ACCEPTED_IMAGE_TYPES = [
    'application/pdf', 
    'image/jpeg', 
    'image/png'
  ].freeze

  validates :avatar, attached: true, 
                     content_type: ACCEPTED_IMAGE_TYPES,
                     dimension: { min: 500..200, max: 500..200 },
                     on: :upload_avatar
  
  validates :name,
            :surname,
            :email,
            :date_of_birth,
            :phone_number,
            :address,
            :city,
            :country, presence: true

  enum rating: %w[
    excellent 
    good 
    mediocre 
    poor 
    terrible
  ]

end
