# frozen_string_literal: true

class SwappRequest < ApplicationRecord
  belongs_to :swapper

  validates :state,
            :offered_product_id,
            :requested_product_id,
            :req_product_owner_id,
            presence: true

  scope :by_state, -> (state) { where(state: state) }

  scope :received, -> (swapper_id) do 
    where(req_product_owner_id: swapper_id)
  end

  enum state: {
    initial: 0,
    accepted: 1,
    rejected: 2
  }
end
