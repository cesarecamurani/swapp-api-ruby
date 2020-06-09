# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :swapper

  validates :category, :title, :description, presence: true

  scope :by_swapper, ->(swapper_id) { where(swapper_id: swapper_id) }
  scope :by_category, ->(category) { where(category: category) }
end
