namespace :profile do
  desc "create records to Profile"
  task createstg: :environment do
    18.upto(19) do |n|
      profile = Profile.create(user_id: n)
      ProfileImage.create(user_id: n, profile_id: profile.id, image: '', caption: '')
    end
  end
end
