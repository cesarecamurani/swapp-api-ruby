# frozen_string_literal: true

class Swapper < ApplicationRecord
  belongs_to :user
  
  has_one_attached :avatar

  with_options dependent: :destroy do |swapper|
    swapper.has_many :auctions
    swapper.has_many :products
    swapper.has_many :swapp_requests
  end

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
            :username,
            :email,
            :date_of_birth,
            :phone_number,
            :address,
            :city,
            :country, 
            presence: true

  enum rating: {
    excellent: 5,
    good: 4,
    mediocre: 3,
    poor: 2,
    terrible: 1
  }

  scope :by_rating, -> (rating) { where(rating: rating) }
  scope :by_username, -> (username) { where(username: username) }
  scope :by_email, -> (email) { where(email: email) }
  scope :by_city, -> (city) { where(city: city) }
  scope :by_country, -> (country) { where(country: country) }
end
