# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :find_product, only: %i[show update destroy upload_images]

  def index
    @products = if (swapper_id = params[:swapper_id].presence)
      Product.by_swapper(swapper_id).to_a
    elsif (category = params[:category].presence)
      Product.by_category(category).to_a
    else
      Product.all.to_a
    end

    present_product(@products, :ok)
  end

  def show
    present_product(@product, :ok)
  end

  def create
    @product = Product.new(product_params)
    present_product(@product, :created) if @product.save!
  end

  def update
    present_product(@product, :ok) if @product.update!(product_params)
  end

  def destroy 
    @product.destroy!
    head :no_content
  end

  def upload_images
    binding.pry
    @product.images.attach(params[:images])
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end

  def present_product(object, status)
    present(object, status: status, serializer: 'Serializer::Product')
  end

  def product_params
    params.require(:product).permit(
      :category,
      :title,
      :description,
      :swapper_id,
      images: [] 
    )
  end 
end
