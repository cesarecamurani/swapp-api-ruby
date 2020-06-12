# frozen_string_literal: true

class Auction < ApplicationRecord
  belongs_to :swapper

  validates :product_id,
            :status,
            :expires_at, 
            presence: true

  scope :by_swapper, -> (swapper_id) { where(swapper_id: swapper_id) }
  scope :by_status, -> (status) { where(status: status) }

  def initial?
    self.status == 'initial'
  end

  def closed?
    self.status == 'closed'
  end

  def expired?
    self.status == 'expired'
  end
end
