# frozen_string_literal: true

class SwappRequest < ApplicationRecord
  belongs_to :swapper

  validates :status,
            :offered_product_id,
            :requested_product_id,
            :req_product_owner_id,
            presence: true

  scope :by_status, -> (status) { where(status: status) }

  scope :received, -> (swapper_id) do 
    where(req_product_owner_id: swapper_id)
  end

  def initial?
    self.status == 'initial'
  end

  def accepted?
    self.status == 'accepted'
  end

  def rejected?
    self.status == 'rejected'
  end
end
