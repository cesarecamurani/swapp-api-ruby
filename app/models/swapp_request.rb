# frozen_string_literal: true

class SwappRequest < ApplicationRecord
  belongs_to :swapper

  validates :status,
            :offered_product_id,
            :requested_product_id,
            :req_product_owner_id,
            presence: true

  enum status: %w[
    initial
    accepted
    rejected
  ]

  scope :by_status, -> (status) { where(status: status) }

  scope :received, -> (swapper_id) do 
    where(req_product_owner_id: swapper_id)
  end
end
