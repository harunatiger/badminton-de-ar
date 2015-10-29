module ApplicationHelper
  def full_title(page_title)
    base_title = Settings.site_info.base_title
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def full_description(page_description)
    base_description = Settings.site_info.base_description
    if page_description.empty?
      base_description
    else
      "#{page_description}"
    end
  end

  def full_words(page_words)
    base_words = Settings.site_info.base_words
    if page_words.empty?
      base_words
    else
      "#{page_words}"
    end
  end

  def listing_cover_image_url(listing_id)
    ci = Listing.find(listing_id)
    if ci.blank?
      return ''
    else
      return ci.cover_image
    end
  end

  def listing_cover_image_thumb_url(listing_id)
    ci = Listing.find(listing_id)
    if ci.blank?
      return ''
    else
      return ci.cover_image.thumb
    end
  end

  def listing_name(listing_id)
    ci = Listing.find(listing_id)
    if ci.blank?
      return ''
    else
      return ci.title
    end
  end

  def unread_messages
    Message.unread_messages(current_user.id).count
  end

  def user_id_to_user_obj(user_id)
    users = User.mine(user_id)
    if users.size.zero?
      return false # todo
    else
      users[0]
    end
  end

  def user_obj_to_name(user)
    "#{user.profile.last_name} #{user.profile.first_name}"
  end

  def user_id_to_name(user_id)
    results = User.mine(user_id)
    if results.size.zero?
      return Settings.user.left
    else
      return "#{results[0].profile.last_name} #{results[0].profile.first_name}"
    end
  end

  def review_count_of_host(host_id)
    results = Listing.mine(host_id).pluck('review_count')
    review_count = 0
    results.each do |result|
      review_count += result
    end
    review_count
  end

  def user_id_to_profile_image(user_id)
    result = ProfileImage.mine(user_id)
    result[0].try('image') || Settings.image.noimage2.url
  end

  def user_id_to_profile_image_caption(user_id)
    result = ProfileImage.mine(user_id)
    result[0].try('caption') || ''
  end

  def user_id_to_profile_image_thumb(user_id)
    result = ProfileImage.mine(user_id)
    if result.present?
      result[0].try('image').thumb || Settings.image.noimage2.url
    else
      Settings.image.noimage2.url
    end
  end
  
  def user_id_to_profile_cover_image(user_id)
    result = ProfileImage.mine(user_id)
    if result.present?
      result[0].try('cover_image') || Settings.image.noimage.url
    else
      Settings.image.noimage.url
    end
  end

  def host_image(host_image_obj)
    host_image_obj.try('image') || Settings.image.noimage2.url
  end

  def profile_image
    if profile_image = ProfileImage.where(user_id: current_user.id).first
      profile_image.try('image') || Settings.image.noimage2.url
    else
      return Settings.image.noimage2.url
    end
  end

  def profile_image_thumb
    if profile_image = ProfileImage.where(user_id: current_user.id).first
      profile_image.try('image').thumb || Settings.image.noimage2.url
    else
      return Settings.image.noimage2.url
    end
  end
  
  def profile_cover_image_thumb
    if profile_image = ProfileImage.where(user_id: current_user.id).first
      profile_image.try('cover_image').thumb || Settings.image.noimage.url
    else
      return Settings.image.noimage.url
    end
  end

  def profile_image_exists?
    profile_image = ProfileImage.where(user_id: current_user.id, profile_id: current_user.profile.id).first
    if profile_image.present?
      profile_image.image.present? ? true : false
    else
      false
    end
  end
  
  def profile_cover_image_exists?
    profile_image = ProfileImage.where(user_id: current_user.id, profile_id: current_user.profile.id).first
    if profile_image.present?
      profile_image.cover_image.present? ? true : false
    else
      false
    end
  end
  
  def profile_to_image(profile)
    if profile.profile_image.present?
      profile.profile_image.try('image') || Settings.image.noimage2.url
    else
      Settings.image.noimage2.url
    end
  end
  
  def profile_to_cover_image(profile)
    if profile.profile_image.present?
      profile.profile_image.try('cover_image') || Settings.image.noimage2.url
    else
      Settings.image.noimage2.url
    end
  end
  
  def profile_to_image_thumb(profile)
    if profile.profile_image.present? and profile.profile_image.image.present?
      profile.profile_image.image.try('thumb') || Settings.image.noimage2.url
    else
      Settings.image.noimage2.url
    end
  end
  
  def profile_to_cover_image_thumb(profile)
    if profile.profile_image.present? and profile.profile_image.cover_image.present?
      profile.profile_image.cover_image.try('thumb') || Settings.image.noimage2.url
    else
      Settings.image.noimage2.url
    end
  end

  def user_id_to_profile_identity(user_id)
    result = ProfileIdentity.mine(user_id)
    result[0].try('image') || Settings.image.noimage2.url
  end

  def user_id_to_profile_identity_thumb(user_id)
    result = ProfileIdentity.mine(user_id)
    result[0].try('image').thumb || Settings.image.noimage2.url
  end

  def profile_identity
    if profile_identity = ProfileIdentity.where(user_id: current_user.id).first
      profile_identity.try('image') || Settings.image.noimage2.url
    else
      return Settings.image.noimage2.url
    end
  end

  def profile_identity_thumb
    if profile_identity = ProfileIdentity.where(user_id: current_user.id).first
      profile_identity.try('image').thumb || Settings.image.noimage2.url
    else
      return Settings.image.noimage2.url
    end
  end

  def profile_identity_exists?
    ProfileIdentity.exists?(user_id: current_user.id, profile_id: current_user.profile.id)
  end

  def profile_identity_authorized?(user_id)
    profile_identity = ProfileIdentity.where(user_id: user_id, profile_id: Profile.where(user_id: user_id).first.id).first
    profile_identity.present? ? profile_identity.authorized : false
  end

  def profile_self_introduction_exists?
    if current_user.present? and current_user.profile.present?
      current_user.profile.self_introduction.present?
    else
      false
    end
  end

  def new_or_edit_path(obj)
    obj ? edit_listing_path(obj) : new_listing_path(obj)
  end

  def left_step_count_and_elements(listing)
    listing.left_step_count_and_elements
  end

  def reservation_to_listing(reservation)
    Listing.find(reservation.listing_id)
  end

  def reservation_to_host(reservation)
    User.find(reservation.host_id)
  end

  def reservation_to_guest(reservation)
    User.find(reservation.guest_id)
  end

  def listing_id_to_weekly_pv(listing_id)
    ListingPv.weekly_pv(listing_id)
  end

  def new_reservations_came(user_id)
    Reservation.new_requests(user_id).count
  end

  def new_messages_came(user_id)
    MessageThread.unread(user_id).count
  end

  def counterpart_user_id(message_thread_id)
    MessageThreadUser.counterpart_user(message_thread_id, current_user.id)
  end

  def counterpart_user_obj(message_thread_id)
    user_id = MessageThreadUser.counterpart_user(message_thread_id, current_user.id)
    User.find(user_id)
  end

  def latest_message(message_thread_id)
    Message.message_thread(message_thread_id).last
  end

  def listing_id_to_listing_obj(listing_id)
    Listing.find(listing_id)
  end

  def reservation_id_to_reservation_obj(reservation_id)
    Reservation.find(reservation_id)
  end

  def reservation_id_to_messages(reservation_id)
    Message.reservation(reservation_id)
  end
  
  def message_to_listing(message)
    Listing.find(message.try('listing_id'))
  end

  def profile_identity_link
    profile_identity = ProfileIdentity.where(user_id: current_user.id, profile_id: current_user.profile.id).first
    if profile_identity.present?
      return edit_profile_profile_identity_path(current_user.profile.id, profile_identity.id)
    else
      new_profile_profile_identity_path(current_user.profile.id)
    end
  end
  
  def profile_bank_link
    profile_bank = ProfileBank.where(user_id: current_user.id, profile_id: current_user.profile.id).first
    if profile_bank.present?
      return edit_profile_profile_bank_path(current_user.profile.id, profile_bank.id)
    else
      new_profile_profile_bank_path(current_user.profile.id)
    end
  end

  def profile_image_link
    profile_image = ProfileImage.where(user_id: current_user.id, profile_id: current_user.profile.id).first
    if profile_image.present?
      return edit_profile_profile_image_path(current_user.profile.id, profile_image.id)
    else
      new_profile_profile_image_path(current_user.profile.id)
    end
  end

  def profile_link
    if current_user
      self_introduction_profile_path(current_user.profile.id, send_message: 'yes')
    else
      new_user_session_path
    end
  end

  def each_manager_link(reservation)
    if current_user.id == reservation.host_id
      return dashboard_host_reservation_manager_path
    else current_user.id == reservation.guest_id
      dashboard_guest_reservation_manager_path
    end
  end

  def string_of_read(read)
    if read == true
      return Settings.message.read.string
    else
      Settings.message.unread.string
    end
  end

  def review_id_to_review_reply_msg(review_id)
    rr = ReviewReply.where(review_id: review_id).select('msg').first
    if rr.present?
      return rr.msg
    else
      return ''
    end
  end

  def category_food?(profile)
    profile.categories.exists?(:name => Settings.categories.food)
  end

  def category_alcohol?(profile)
    profile.categories.exists?(:name => Settings.categories.alcohol)
  end

  def category_car?(profile)
    profile.categories.exists?(:name => Settings.categories.car)
  end

  def category_cruising?(profile)
    profile.categories.exists?(:name => Settings.categories.cruising)
  end

  def category_shopping?(profile)
    profile.categories.exists?(:name => Settings.categories.shopping)
  end

  def category_accommodation?(profile)
    profile.categories.exists?(:name => Settings.categories.accommodation)
  end

  def category_business?(profile)
    profile.categories.exists?(:name => Settings.categories.business)
  end

  def category_sport?(profile)
    profile.categories.exists?(:name => Settings.categories.sport)
  end

  def language_ja?(profile)
    profile.languages.exists?(:name => Settings.languages.ja)
  end

  def language_en?(profile)
    profile.languages.exists?(:name => Settings.languages.en)
  end

  def language_zh?(profile)
    profile.languages.exists?(:name => Settings.languages.zh)
  end

  def out_put_error(target)
    if target.errors.present?
      content_tag(:div, class: 'alert alert-error') do
        target.errors.full_messages.each do |msg|
          concat content_tag(:div, msg)
        end
      end
    end
  end
end
