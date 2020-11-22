# frozen_string_literal: true

class AuctionsController < ApplicationController
  include AuctionsHelper

  before_action :find_auction, only: :show
  before_action :find_swapper_auction, only: %i[update destroy]
  before_action :find_auctions, only: :index
  before_action :find_swapper_auctions, only: :summary

  def index
    present_auction(@auctions, :ok)
  end

  def summary
    present_auction(@auctions, :ok)
  end

  def show
    present_auction(@auction, :ok)
  end

  def create
    @auction = Auction.new(auction_params)

    present_auction(@auction, :created) if @auction.save!
  end

  def update
    present_auction(@auction, :ok) if @auction.update!(auction_params)
  end

  def destroy
    head :no_content if @auction.destroy!
  end
end
