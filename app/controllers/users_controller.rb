# frozen_string_literal: true

class UsersController < ApplicationController
  include UsersHelper

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
    head :no_content if @user.destroy!
  end
end
