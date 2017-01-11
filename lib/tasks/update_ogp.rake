namespace :update_ogp do
  require ENV['PWD'] + "/app/controllers/concerns/ogp_setting"
  include OgpSetting
  
  desc 'do update_ogp'
  task do: :environment do
  end
end
