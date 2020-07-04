# frozen_string_literal: true

class Bid < ApplicationRecord
  belongs_to :auction

  validates :product_id, :state, presence: true

  enum state: {
    initial: 0,
    accepted: 1,
    rejected: 2
  }
end
