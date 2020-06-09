# frozen_string_literal: true

module UsersHelpers

  def user_create_params
    {
      user: {
        username: 'testuser',
        email: 'testuser@email.com',
        password: '@Password1'
      }
    }
  end

  def user_update_params
    {
      user: {
        username: 'anotheruser',
        email: 'anotheruser@email.com',
        password: '@Password1'
      }
    }
  end

  def user_missing_params
    {
      user: {
        username: '',
        email: 'testuser@email.com',
        password: '@Password1'
      }
    }
  end

  def users_show_response
    {
      'object' => {
        'id' => user.id,
        'username' => 'johnsmith',
        'email' => 'johnsmith@email.com'
      }
    }
  end

  def users_create_response
    {
      'object' => {
        'id' => User.last.id,
        'username' => 'testuser',
        'email' => 'testuser@email.com'
      }
    }
  end

  def users_update_response
    {
      'object' => {
        'id' => user.id,
        'username' => 'anotheruser',
        'email' => 'anotheruser@email.com'
      }
    }
  end
end
