# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: :create

  def show
    @user = User.find_by(id: params[:id])
    present @user
  end

  def create
    @user = User.new(user_params)
    present @user if @user.save    
  end

  def update
    
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password
    ).merge(
      password_confirmation: params[:password]
    )
  end
end
