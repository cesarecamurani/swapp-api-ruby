# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: %i[show update destroy]
  skip_before_action :authorize_request, only: :create

  def show
    present_user(@user, :ok)
  end

  def create
    @user = User.new(user_params)
    present_user(@user, :created) if @user.save!
  end

  def update
    present_user(@user, :ok) if @user.update!(user_params)
  end

  def destroy 
    @user.destroy!
    head :no_content
  end

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
      password_confirmation: params[:password]
    )
  end
end
