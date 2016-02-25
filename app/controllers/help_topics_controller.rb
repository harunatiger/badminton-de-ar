class HelpTopicsController < ApplicationController
  before_action :set_locale

  def index
    @help_categories_other = HelpCategory.where(parent_id: 1).includes(:children)
    @help_categories_guide = HelpCategory.where(parent_id: 2).includes(:children)
  end

  protected

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
