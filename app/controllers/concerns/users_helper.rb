# frozen_string_literal: true

module UsersHelper
  extend ActiveSupport::Concern

  private

  def find_user
    @user ||= User.find_by(id: params[:id])
    head :not_found unless @user
  end

  def present_user(object, status)
    present(object, status: status, serializer: 'Serializer::User')
  end

  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :password
    ).merge(
      password_confirmation: params[:user][:password]
    )
  end
end
