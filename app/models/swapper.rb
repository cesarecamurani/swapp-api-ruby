# frozen_string_literal: true

class Swapper < ApplicationRecord
  belongs_to :user
  has_many :products

  validates :name,
            :surname,
            :email,
            :date_of_birth,
            :phone_number,
            :address,
            :city,
            :country, presence: true

end
