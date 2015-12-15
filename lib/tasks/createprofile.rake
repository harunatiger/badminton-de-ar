namespace :profile do
  desc "create records to Profile"
  task create: :environment do
    79.upto(94) do |n|
      profile = Profile.create(user_id: n)
      ProfileImage.create(user_id: n, profile_id: profile.id, image: '', caption: '')
    end
  end
end
