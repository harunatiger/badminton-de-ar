ActiveAdmin.register HelpCategory do
  config.sort_order = 'lft_asc'

  sortable_tree_member_actions

  index do
    sortable_tree_columns

    column :name_ja
    column :name_en
    actions
  end

  filter :name_ja
  filter :name_en

  form do |f|
    inputs 'Details' do
      input :parent_id, as: :select, collection: HelpCategory.all.map { |c| [c.name_ja, c.id] }
      input :name_ja
      input :name_en
    end
    actions
  end

  controller do
    def permitted_params
      params.permit :utf8, :_method, :authenticity_token, :locale, :commit, :id,
                    help_category: [:parent_id, :name_ja, :name_en, :display_order, :lft, :rgt]
    end
  end
end
