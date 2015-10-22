ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers

  public

  def create_user ( name = random_string,options={} )
    user = User.new(options)
    user.email =  "#{ name }@example.com"
    user.password= random_string
    user.permission_type ||= :admin
    user.save!

    user
  end

  def create_pickup_area

  end

  def create_pickup_category

  end

  def create_pickup_tag

  end

  def create_listing(customer = create_customer, uploader = create_user, options = {})
    doctype             = options[:doctype]             || :document
    crowd_source_status = options[:crowd_source_status] || :uploaded
    locked_by           = options[:locked_by]
    unlocked_at         = options[:unlocked_at]
    issuer_id           = options[:issuer_id]
    issuer_branch_id    = options[:issuer_branch_id]
    issue_date          = options[:issue_date]
    amount              = options[:amount]
    created_at          = options[:created_at]

    document = Document.new
    document.id                   = (Document.all.maximum(:id) || 0) + 1
    document.doctype              = doctype
    document.crowd_source_status  = crowd_source_status
    document.customer_id          = customer.id
    document.uploader_id          = uploader.id
    document.crowd_sourcer_id     = locked_by
    document.unlocked_at          = unlocked_at
    document.issuer_id            = issuer_id
    document.issuer_branch_id     = issuer_branch_id
    document.issue_date           = issue_date
    document.amount               = amount
    document.created_at           = created_at
    document.image                = Dragonfly.app.generate(
        :text,
        document.id.to_s,
        'format' => 'jpeg',
        'font-family' => 'Monaco',
        'color' => 'red',
    )
    document.save!

    document
  end
end
