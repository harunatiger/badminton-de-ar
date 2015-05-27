class GettingStartedController < ApplicationController
  def help_started
    @topics = Topic.all
  end
end
