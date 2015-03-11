class OptInController < ApplicationController
  before_action :find_opt_in
  before_action :find_subscription, only: [:confirm]

  def confirm
    # FIXME: check blacklist

    if @opt_in.confirmed?
      # FIXME: thanks, but already confirmed
      return
    end

    @opt_in.confirmed_at = DateTime.now
    @opt_in.confirmed_ip = request.remote_ip
    @opt_in.save!

    @subscription.active = true
    @subscription.save!
    # FIXME: thanks page
  end

  def report
    # FIXME: add user to email blacklist
    # FIXME: set every subscription from email to active=0
    # FIXME: notify admin
    # FIXME: thanks page
  end

  private

  def find_opt_in
    @opt_in = OptIn.find_by_confirmation_token(params[:confirmation_token])
    render :'error/confirmation_token' if @opt_in.nil? # FIXME: page
  end

  def find_subscription
    @subscription = Subscription.find_by_hash(params[:subscription])
    render :'error/subscription' if @subscription.nil? # FIXME: page
  end
end
