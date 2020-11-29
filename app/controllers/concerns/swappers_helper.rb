# frozen_string_literal: true

module SwappersHelper
  extend ActiveSupport::Concern

  private

  def find_swapper
    @swapper ||= Swapper.find_by(id: params[:id])

    head :not_found unless @swapper
  end

  def find_swappers
    @swappers = Swapper.all
    @swappers = rating_scope(@swappers)
    @swappers = username_scope(@swappers)
    @swappers = email_scope(@swappers)
    @swappers = city_scope(@swappers)
    @swappers = country_scope(@swappers)
    @swappers = @swappers.to_a
  end

  def rating_scope(scope)
    (rating = params[:rating].presence) ? scope.by_rating(rating) : scope
  end

  def username_scope(scope)
    (username = params[:username].presence) ? scope.by_username(username) : scope
  end

  def email_scope(scope)
    (email = params[:email].presence) ? scope.by_email(email) : scope
  end

  def city_scope(scope)
    (city = params[:city].presence) ? scope.by_city(city) : scope
  end

  def country_scope(scope)
    (country = params[:country].presence) ? scope.by_country(country) : scope
  end

  def present_swapper(object, status)
    present(object, status: status, serializer: 'Serializer::Swapper')
  end

  def swapper_params
    params.require(:swapper).permit(
      :name,
      :surname,
      :username,
      :email,
      :phone_number,
      :date_of_birth,
      :address,
      :city,
      :country,
      :rating,
      :avatar,
      :user_id
    )
  end
end
