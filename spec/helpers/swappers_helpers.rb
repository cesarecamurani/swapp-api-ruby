# frozen_string_literal => true

module SwappersHelpers

  def swapper_create_params
    {
      swapper: {
        name: 'Nomen',
        surname: 'Nescio',
        email: 'nomennescio@email.com',
        date_of_birth: '06-06-1966',
        phone_number: '07712345678',
        address: '6, Street',
        city: 'Rome',
        country: 'Italy',
        user_id: user.id
      }
    }
  end

  def swapper_update_params
    {
      swapper: {
        name: 'Settimio',
        surname: 'Severo',
        email: 'settimio@email.com',
        date_of_birth: '06-06-1966',
        phone_number: '07712345678',
        address: '6, Street',
        city: 'Rome',
        country: 'Italy',
        user_id: user.id
      }
    }
  end

  def swapper_missing_params
    {
      swapper: {
        name: '',
        surname: '',
        email: user.email,
        date_of_birth: '06-06-1966',
        phone_number: '07712345678',
        address: '6, Street',
        city: 'Rome',
        country: 'Italy',
        user_id: user.id
      }
    }
  end
  
  def swappers_show_response
    {
      'object' => {
        'id' => swapper.id,
        'name' => 'John',
        'surname' => 'Smith',
        'email' => user.email,
        'phone_number' => '07712345678',
        'date_of_birth' => '06-06-1966',
        'address' => '6, Street',
        'city' => 'London',
        'country' => 'UK',
        'user_id' => user.id
      }
    }
  end

  def swappers_create_response
    {
      'object' => {
        'id' => Swapper.last.id,
        'name' => 'Nomen',
        'surname' => 'Nescio',
        'email' => 'nomennescio@email.com',
        'phone_number' => '07712345678',
        'date_of_birth' => '06-06-1966',
        'address' => '6, Street',
        'city' => 'Rome',
        'country' => 'Italy',
        'user_id' => user.id
      }
    }
  end

  def swappers_update_response
    {
      'object' => {
        'id' => swapper.id,
        'name' => 'Settimio',
        'surname' => 'Severo',
        'email' => 'settimio@email.com',
        'phone_number' => '07712345678',
        'date_of_birth' => '06-06-1966',
        'address' => '6, Street',
        'city' => 'Rome',
        'country' => 'Italy',
        'user_id' => user.id
      }
    }
  end
end
