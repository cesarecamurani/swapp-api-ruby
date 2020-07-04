# frozen_string_literal: true

class Auction < ApplicationRecord
  belongs_to :swapper

  has_many :bids, dependent: :destroy

  validates :product_id,
            :state,
            :expires_at, 
            presence: true

  scope :by_swapper, -> (swapper_id) { where(swapper_id: swapper_id) }
  scope :by_state, -> (state) { where(state: state) }

  enum state: {
    in_progress: 0,
    closed: 1,
    expired: 2
  }
end
