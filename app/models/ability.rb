class Ability #WIPPPPP
  include CanCan::Ability

  def initialize(user)
    # How to use
    # https://github.com/CanCanCommunity/cancancan/wiki/defining-abilities

    user ||= User.new # guest user (not logged in)

    alias_action :index, :show, :search, :to => :read
    alias_action :new, :to => :create
    alias_action :edit, :to => :update
    alias_action :create, :read, :update, :destroy, :to => :crud

    # All
    can [:read, :create], :all

    # Listing Resources
    can :manage, Listing
    cannot [:update, :destroy, :publish, :unpublish, :copy, :manage], Listing do |listing|
      listing.user_id != user.id
    end
    cannot [:show], Listing do |listing|
      listing.user_id != user.id and !listing.open
    end
    
    models = [ ListingImage, ListingDetail ]
    can [:update], models do |related|
      related.listing.user_id == user.id
    end

    # Profile Resources
    models = [ Profile, ProfileImage, ProfileKeyword, ProfileIdentity, ProfileBank ]
    can :manage, models
    cannot [:update, :self_introduction], models do |profile|
      profile.user_id != user.id
    end

    # Two User's Resources
    models = [ Reservation ]
    can [:update], models do |model|;pp model
      ( model.host_id == user.id ) || ( model.guest_id == user.id )
    end

  end
end