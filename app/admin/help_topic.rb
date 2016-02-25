ActiveAdmin.register HelpTopic do
  index do
    column :help_category
    column :title_ja
    column :body_ja
    column :title_en
    column :body_en
    actions
  end

  filter :title_ja
  filter :body_ja
  filter :title_en
  filter :body_en

  form do |f|
    inputs 'Details' do
      input :help_category_id, as: :select, collection: HelpCategory.all.map { |c| [c.name_ja, c.id] }
      input :title_ja
      input :body_ja
      input :title_en
      input :body_en
    end
    actions
  end

  controller do
    def scoped_collection
      case action_name
        when 'index'
          HelpTopic.includes(:help_category)
        else
          super
      end
    end

    def permitted_params
      params.permit :utf8, :_method, :authenticity_token, :locale, :commit, :id,
                    help_topic: [:help_category_id, :title_ja, :body_ja, :title_en, :body_en]
    end
  end
end
