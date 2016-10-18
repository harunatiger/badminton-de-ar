class TagEventsController < ApplicationController
  def create
    if request.xhr?
      return render text: 'success'
    end
  end
end