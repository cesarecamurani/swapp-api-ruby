# frozen_string_literal: true

class BidsController < ApplicationController
  include BidsHelper

  before_action :find_bid, only: %i[show accept_bid]
  before_action :find_bids, only: :summary

  def summary
    present_bid(@bids, :ok)
  end

  def show
    present_bid(@bid, :ok)
  end

  def create
    @bid = Bid.new(bid_params)
    present_bid(@bid, :created) if @bid.save!
  end

  def accept_bid
    return unless @bid.initial?
    present_bid(@bid, :ok) if @bid.accepted!
  end
end
