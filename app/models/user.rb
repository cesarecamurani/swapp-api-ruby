# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :swapper, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 8 },
            if: -> { new_record? || !password.nil? }
end
