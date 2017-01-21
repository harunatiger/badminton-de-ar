class CountsController < ApplicationController
  def show
    @count = Count.find_by_id(params[:id])
  end
  
  def index
    @counts = Count.all
  end
end