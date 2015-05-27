class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailer.from.default
  #layout 'mailer'
end
