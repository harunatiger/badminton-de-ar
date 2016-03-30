class HelpTopicsController < ApplicationController
  before_action :set_locale

  def for_user
    @help_categories_other = HelpCategory.where(parent_id: 1).includes(:children)
  end

  def for_guide
    @help_categories_guide = HelpCategory.where(parent_id: 2).includes(:children)
  end

  def search
    keyword = params[:keyword]
    help_type = params[:help_type]
    if keyword.present?
      @search_result = HelpTopic.search(keyword)
      render :search_result, locals: {help_type: help_type, keyword: keyword ,search_result: @search_result}
    else
      if help_type == 'user'
        redirect_to for_user_help_topics_path(:locale => @locale.to_s)
      else
        redirect_to for_guide_help_topics_path(:locale => @locale.to_s)
      end
    end
  end

  def search_result
  end

  protected
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    @locale = I18n.locale
  end
end
