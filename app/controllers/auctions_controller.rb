# frozen_string_literal: true

class AuctionsController < ApplicationController
  include AuctionsHelper

  before_action :find_auction, only: %i[ show make_bid ]
  before_action :find_auction_for_swapper, only: %i[
    update
    destroy
    accept_bid
  ]
  before_action :find_auctions, only: :index
  before_action :find_auctions_for_swapper, only: :summary

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

  def make_bid
    return unless @auction.in_progress?
    # code here
  end

  def accept_bid
    return unless @auction.in_progress?
    # code here
  end
end
