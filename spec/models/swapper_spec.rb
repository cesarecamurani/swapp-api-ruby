# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Swapper, type: :model do
  let(:user) { FactoryBot.create(:user) }
  
  subject(:swapper) do 
    described_class.new(
      name: 'John',
      surname: 'Smith',
      email: user.email,
      date_of_birth: '06-06-1966',
      phone_number: '07712345678',
      address: '6, Street',
      city: 'London',
      country: 'UK',
      user_id: user.id
    )
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a username' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without an email' do
      subject.surname = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a password' do
      subject.email = nil
      expect(subject).to_not be_valid
    end
    
    it 'is not valid without a username' do
      subject.date_of_birth = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without an email' do
      subject.address = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a password' do
      subject.city = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a password' do
      subject.country = nil
      expect(subject).to_not be_valid
    end
  end
end
