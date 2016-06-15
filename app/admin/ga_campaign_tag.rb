ActiveAdmin.register GaCampaignTag do
  permit_params :default_url, :source, :medium, :term, :content, :name, :short_url, :long_url
  
  index do
    GaCampaignTag.column_names.each do |col|
      if col == 'short_url'
        column :short_url do |ga_campaign_tag|
          link_to ga_campaign_tag_url(ga_campaign_tag.short_url), ga_campaign_tag_url(ga_campaign_tag.short_url), :target => ["_blank"]
        end
      else
        column col
      end
    end
    actions
  end
  
  form do |f|
    f.inputs do
      GaCampaignTag.column_names.each do |col|
        if col != 'id' and col != 'long_url' and col != 'short_url' and col != 'created_at' and col != 'updated_at'
          if col == 'default_url'
            f.input col, placeholder: "EX) " + root_url
          else
            f.input col
          end
        end
      end
      f.actions
    end
  end
  
  show do
    attributes_table do
      GaCampaignTag.column_names.each do |col|
        if col == 'short_url'
          row :short_url do |ga_campaign_tag|
            link_to ga_campaign_tag_url(ga_campaign_tag.short_url), ga_campaign_tag_url(ga_campaign_tag.short_url), :target => ["_blank"]
          end
        else
          row col
        end
      end
    end
  end
  
end
