class HelpTopicsController < ApplicationController
  before_action :set_locale

  def for_user
    @help_categories_other = HelpCategory.where(parent_id: 1).includes(:children)
    @pre_mail = current_user.pre_mail
  end

  def for_guide
    @help_categories_guide = HelpCategory.where(parent_id: 2).includes(:children)
  end

  protected

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
