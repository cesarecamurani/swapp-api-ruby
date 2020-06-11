# frozen_string_literal: true

class Swapper < ApplicationRecord
  belongs_to :user
  
  has_one_attached :avatar
  has_many :products, dependent: :destroy
  has_many :swapp_requests, dependent: :destroy

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

  scope :by_rating, -> (rating) { where(rating: rating) }
  scope :by_name, -> (name) { where(name: name) }
  scope :by_surname, -> (surname) { where(surname: surname) }
  scope :by_email, -> (email) { where(email: email) }
  scope :by_city, -> (city) { where(city: city) }
  scope :by_country, -> (country) { where(country: country) }

end
