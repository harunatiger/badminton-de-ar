namespace :update_identity_status do
  desc 'do updating message thread'
  task do: :environment do
    begin
      ActiveRecord::Base.transaction do
        ProfileIdentity.all.each do |profile_identity|
          if profile_identity.authorized
            profile_identity.update!(status: 'authorized')
          else
            profile_identity.update!(status: 'uploaded')
          end
        end
      end
    rescue ActiveRecord::Rollback
    end
  end
end
