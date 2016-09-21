namespace :create_feature do
  desc "create kamakura feature"
  task do: :environment do
    Feature.create!(title: 'kamakura', url: '/features', order_number: 1, image: Rails.root.join("app/assets/images/feature/welcome-kamakura.png").open, image_sp: Rails.root.join("app/assets/images/feature/welcome-kamakura--sp.png").open)
  end
end
