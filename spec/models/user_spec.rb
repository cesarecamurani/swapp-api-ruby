# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  subject(:user) do 
    described_class.new(
      username: 'johndoe',
      email: 'johndoe@email.com',
      password: '@Password1'
    )  
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a username' do
      subject.username = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a password' do
      subject.password = nil
      expect(subject).to_not be_valid
    end 
  end
end
