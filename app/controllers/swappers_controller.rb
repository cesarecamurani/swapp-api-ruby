# frozen_string_literal: true

class SwappersController < ApplicationController
  before_action :find_swapper, only: %i[show update destroy upload_avatar]

  def index
    @swappers = Swapper.all.to_a
    present_swapper(@swappers, :ok)
  end

  def show
    present_swapper(@swapper, :ok)
  end

  def create
    @swapper = Swapper.new(swapper_params)
    present_swapper(@swapper, :created) if @swapper.save!
  end

  def update
    present_swapper(@swapper, :ok) if @swapper.update!(swapper_params)
  end

  def destroy 
    @swapper.destroy!
    head :no_content
  end

  def upload_avatar
    return unless params[:avatar].presence
    @swapper.avatar.attach(params[:avatar])
  end

  private

  def find_swapper
    @swapper = Swapper.find_by(id: params[:id])
    head :not_found unless @swapper
  end

  def present_swapper(object, status)
    present(object, status: status, serializer: 'Serializer::Swapper')
  end

  def swapper_params
    params.require(:swapper).permit(
      :name,
      :surname,
      :email,
      :phone_number,
      :date_of_birth,
      :address,
      :city,
      :country,
      :avatar,
      :user_id
    )
  end 
end
