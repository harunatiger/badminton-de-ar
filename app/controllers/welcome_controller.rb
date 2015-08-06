class WelcomeController < ApplicationController
  def index
    @listings = Listing.opened
  end
end
