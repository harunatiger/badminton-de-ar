namespace :profile do
  desc "create records to Profile"
  task create: :environment do
    78.upto(93) do |n|
      profile = Profile.create(user_id: n)
      ProfileImage.create(user_id: n, profile_id: profile.id, image: '', caption: '')
    end
  end
end
