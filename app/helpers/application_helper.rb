module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper
  require "uri"

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

  def og_description
    if controller_name == 'listings' and action_name == 'show'
      "#{@listing.title}！Make Friend, Start Trip!"
    elsif controller_name == 'profiles' and action_name == 'show'
      "#{@profile.try('first_name')}'s self-Introduction！Make Friend, Start Trip!"
    else
      'Dive into the real Japan! Friendly Locals as Your Guides.'
    end
  end

  def og_image
    if controller_name == 'listings' and action_name == 'show'
      if Rails.env.development?
        @listing.listing_images.present? and @listing.listing_images.first.image.present? ? "#{request.host + @listing.listing_images.first.image.url}" : "http://huber-japan.com/assets/og.png"
      else
        @listing.listing_images.present? and @listing.listing_images.first.image.present? ? @listing.listing_images.first.image.url : "http://huber-japan.com/assets/og.png"
      end
    elsif controller_name == 'profiles' and action_name == 'show'
      if Rails.env.development?
        @profile.thumb_images.present? ? "#{request.host + @profile.thumb_images.first.image.url}" : "http://huber-japan.com/assets/og.png"
      else
        @profile.thumb_images.present? ? @profile.thumb_images.first.image.url : "http://huber-japan.com/assets/og.png"
      end
    else
      "http://huber-japan.com/assets/og.png"
    end
  end

  def listing_cover_image_url(listing_id)
    listing = Listing.find(listing_id)
    if listing.cover.blank?
      return Settings.image.noimage.url
    else
      return listing.cover
    end
  end

  def listing_cover_image_thumb_url(listing_id)
    listing = Listing.find(listing_id)
    if listing.cover.blank?
      return Settings.image.noimage.url
    else
      return listing.cover.thumb
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

  def listing_slider_url(listing_images)
    slider_images = []
    if listing_images.present?
      listing_images.each do |listing_image|
        slide = listing_image.image.url.blank? ? '' : listing_image.image.url
        slider_images << slide
      end
    end

    slider_images
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
      return "#{results[0].profile.first_name} #{results[0].profile.last_name}"
    end
  end

  def user_id_to_firstname(user_id)
    results = User.mine(user_id)
    if results.size.zero?
      return Settings.user.left
    else
      return "#{results[0].profile.first_name}"
    end
  end

  def user_id_to_phone_number(user_id)
    results = User.mine(user_id)
    if results.size.zero?
      return ''
    else
      return results[0].profile.phone
    end
  end

  def user_id_to_profile_id(user_id)
    User.find(user_id).profile.id
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
    profile = Profile.where(user_id: user_id).first
    if profile.present? and profile.thumb_image.present?
      profile.thumb_image.try('image') || Settings.image.noimage2.url
    else
      Settings.image.noimage2.url
    end
  end

  def user_id_to_profile_image_caption(user_id)
    result = ProfileImage.mine(user_id)
    result[0].try('caption') || ''
  end

  def user_id_to_profile_image_thumb(user_id)
    profile = Profile.where(user_id: user_id).first
    if profile.present? and profile.thumb_image.present? and profile.thumb_image.image.present?
      profile.thumb_image.image.thumb.url
    else
      Settings.image.noimage2.url
    end
  end

  def user_id_to_profile_cover_image(user_id)
    profile = Profile.where(user_id: user_id).first
    if profile.present? and profile.cover.present? and profile.cover.image.present?
      profile.cover.image
    else
      Settings.image.noimage.url
    end
  end

  def profile_image
    profile = Profile.where(user_id: current_user.id).first
    if profile.present? and profile.thumb_image.present? and profile.thumb_image.image.present?
      profile.thumb_image.image.url
    else
      Settings.image.noimage2.url
    end
  end

  def profile_image_thumb
    profile = Profile.where(user_id: current_user.id).first
    if profile.present? and profile.thumb_image.present? and profile.thumb_image.image.present?
      profile.thumb_image.image.thumb.url
    else
      Settings.image.noimage2.url
    end
  end

  def profile_cover_image_thumb
    profile = Profile.where(user_id: current_user.id).first
    if profile.present? and profile.cover.present? and profile.cover.image.present?
      profile.cover.image.thumb.url
    else
      Settings.image.noimage.url
    end
  end

  def profile_cover_image_exists?
    profile = Profile.where(user_id: current_user.id).first
    return true if profile.cover.present? and profile.cover.image.present?
    return false
  end

  def profile_to_image(profile)
    if profile.thumb_image.present? and profile.thumb_image.image.present?
      profile.thumb_image.image
    else
      Settings.image.noimage2.url
    end
  end

  def profile_to_cover_image(profile)
    if profile.cover.present? and profile.cover.image.present?
      profile.cover.image
    else
      Settings.image.noimage.url
    end
  end

  def profile_to_image_thumb(profile)
    if profile.thumb_image.present? and profile.thumb_image.image.present?
      profile.thumb_image.image.thumb.url
    else
      Settings.image.noimage2.url
    end
  end

  def profile_to_cover_image_thumb(profile)
    if profile.cover.present? and profile.cover.image.present?
      profile.cover.image.thumb
    else
      Settings.image.noimage.url
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
      current_user.profile.free_field.present?
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
    GuestThread.unread(user_id).count
  end

  def latest_message(message_thread_id)
    Message.message_thread(message_thread_id).last
  end

  def listing_id_to_listing_obj(listing_id)
    Listing.find(listing_id)
  end

  def listing_to_profile(listing)
    Profile.where(user_id: listing.user_id).first
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

  def profile_blank_link
    return edit_profile_path(current_user.profile.id) unless profile_completed?
    profile_identity_link
  end

  def profile_bank_link
    profile_bank = ProfileBank.where(user_id: current_user.id, profile_id: current_user.profile.id).first
    if profile_bank.present?
      return edit_profile_profile_bank_path(current_user.profile.id, profile_bank.id)
    else
      new_profile_profile_bank_path(current_user.profile.id)
    end
  end

  def profile_keyword_link
    profile_keyword = ProfileKeyword.where(user_id: current_user.id, profile_id: current_user.profile.id).first
    if profile_keyword.present?
      return edit_profile_profile_keyword_path(current_user.profile.id, profile_keyword.id)
    else
      new_profile_profile_keyword_path(current_user.profile.id)
    end
  end

  #def profile_image_link
  #  profile_image = ProfileImage.where(user_id: current_user.id, profile_id: current_user.profile.id).first
  #  if profile_image.present?
  #    return edit_profile_profile_image_path(current_user.profile.id, profile_image.id)
  #  else
  #    new_profile_profile_image_path(current_user.profile.id)
  #  end
  #end

  def profile_link
    if current_user
      edit_profile_path(current_user.profile.id, send_message: 'yes')
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

  def language_de?(profile)
    profile.languages.exists?(:name => Settings.languages.de)
  end

  def language_fr?(profile)
    profile.languages.exists?(:name => Settings.languages.fr)
  end

  def language_es?(profile)
    profile.languages.exists?(:name => Settings.languages.es)
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

  def out_put_error_for_modal(target)
    if target.present? and target.errors.present?
      content_tag(:div, class: 'text-red') do
        target.errors.full_messages.each do |msg|
          concat content_tag(:div, '・' + msg)
        end
      end
    end
  end

  def hbr(target)
    target = html_escape(target)
    target.gsub(/\r\n|\r|\n/, "<br />")
  end

  def hbr_noescape(target)
    target.gsub(/\r\n|\r|\n/, "<br />")
  end

  def schedule_span(reservation)
    if reservation.under_construction? and reservation.created_at == reservation.updated_at and reservation.schedule_hour == '00' and reservation.schedule_minute == '00'
      reservation.schedule.to_date.to_s + '〜'
    else
      if reservation.time_required.to_s == '24.5'
        reservation.schedule.to_s + '〜' + reservation.schedule_end.to_s + '/ (24h-)'
      else
        reservation.schedule.to_s + '〜' + (reservation.schedule + reservation.time_required.hour).to_s + '(' + reservation.time_required.to_s + 'h)'
      end
    end
  end

  def meeting_at(reservation)
    if reservation.under_construction? and reservation.created_at == reservation.updated_at and reservation.schedule_hour == '00' and reservation.schedule_minute == '00'
      reservation.schedule.to_date.to_s
    else
      reservation.schedule.to_s
    end
  end

  def select_pick_up_listing(pickup)
    selected_listing = Listing.find(pickup.selected_listing)
    listings = pickup.listings.opened
    if listings.present?
      listing = selected_listing.open ? selected_listing : listings.order("RANDOM()").first
    else
      listing = selected_listing.open ? selected_listing : nil
    end
  end

  def favorite_to_listing(favorite)
    Listing.find(favorite.try('listing_id'))
  end

  def favorite_listing_to_profile(listing)
    Profile.find_by(user_id: listing.try('user_id'))
  end

  def favorite_user_to_profile(user_id)
    Profile.find_by(user_id: user_id)
  end

  def favorite_users_count(user_id)
    FavoriteUser.where(to_user_id: user_id).count
  end

  def favorite_listings_count(listing_id)
    FavoriteListing.where(listing_id: listing_id).count
  end

  def favorite_listing_set(listing, user)
    FavoriteListing.find_by(listing: listing, user: user)
  end

  def favorite_user_set(to_user_id, from_user_id)
    FavoriteUser.find_by(to_user_id: to_user_id, from_user_id: from_user_id)
  end

  def space_options
    ['space_rental']
  end

  def car_options
    ['car_rental', 'gas', 'highway', 'parking']
  end

  def bicycle_options
    ['bicycle_rental']
  end

  def other_options
    ['other_cost']
  end

  def pickup_area_from_listing(listing)
    listing.pickups.where(type: 'PickupArea')
  end

  def time_ago(message)
    now = Time.zone.now
    updated = message.updated_at
    second = (now - updated).to_i
    if second >= 86400
      unreply_time = '24時間以上'
    else
      day = second.to_i / 86400
      if second >= 3600
        unreply_time = ((Time.parse("1/1") + (second - day * 86400)).strftime("%H").to_i).to_s + '時間'
      else
        unreply_time = ((Time.parse("1/1") + (second - day * 86400)).strftime("%M").to_i).to_s + '分'
      end
    end
  end

  def set_time_required
    time_required_hash = Hash.new()
    0.step(24.5,0.5) do |i|
      if i == 24.5
        time_required_hash.store('24.0以上', i)
      else
        time_required_hash.store(i, i)
      end
    end
    time_required_hash
  end

  def format_time_required(str_time, str_style = '')
    if str_time == '24.5'
      time_required = '24h-'
    else
      time_required = str_style.blank? ? str_time + 'h' : str_time + str_style
    end
    time_required
  end

  def notice_format(text)
    return text if text.blank?
    sanitize text.gsub(/\r\n|\r|\n/, "<br />"), :tag => %w(br)
  end

  def has_reservation_as_guest
    current_user.comming_reservations_as_guest.present?
  end

  def has_reservation_as_guide
    current_user.comming_reservations_as_guide.present?
  end

  def users_to_guide_thread(to_user_id, from_user_id)
    if mt = GuideThread.exists_thread_for_pair_request?(to_user_id, from_user_id)
      mt
    else
      GuideThread.create_thread(to_user_id, from_user_id)
    end
  end

  def disp_friends_request_block?(mt, counterpart_id)
    mt.guide_thread? and current_user.friend_requested?(counterpart_id)
  end

  def text_url_to_link(text)
    URI.extract(text, ['http','https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"
      text.gsub!(url, sub_text)
    end
    return text
  end

  def listing_image_to_pickup_tag(listing_image)
    PickupTag.find(listing_image.pickup_id) if listing_image.pickup_id.present?
  end

  def image_categories_limited_six(listing)
    all_categories = []
    result = []
    listing.listing_images.each do |listing_image|
      all_categories << PickupTag.find(listing_image.pickup_id) if listing_image.pickup_id.present?
    end
    return [] if all_categories.blank?
    all_categories.shuffle!
    result = all_categories.group_by{|e| e}.sort_by{|_,v|-v.size}.map(&:first)
    result.present? ? result[0..5] : []
  end

  def pair_guide_profiles(host_id)
    host = User.find(host_id)
    host.friends_profiles.order("RANDOM()")
  end

  def pair_user(reservation)
    if reservation.pg_completion?
      pair_user = current_user.id == reservation.pair_guide_id ? User.find(reservation.host_id) : User.find(reservation.pair_guide_id)
    else
      return false
    end
  end

  def guide_type_str(reservation)
    current_user.id != reservation.host_id ? 'Main guide' : 'Supporting guide'
  end

  def current_user_is_host?(reservation)
    current_user.id == reservation.host_id
  end

  def send_update_pair_guide_notification_body(status, from_user)
    body = ""
    if status == Settings.reservation.pair_guide_status.offer
      body = I18n.t('mailer.send_update_pair_guide_notification.body.offer', user_name: user_obj_to_name(from_user))
    elsif status == Settings.reservation.pair_guide_status.accepted
      body = I18n.t('mailer.send_update_pair_guide_notification.body.accepted', user_name: user_obj_to_name(from_user))
    elsif status == Settings.reservation.pair_guide_status.canceled
      body = I18n.t('mailer.send_update_pair_guide_notification.body.canceled', user_name: user_obj_to_name(from_user))
    end
    body
  end

  def pair_guide_thread_to_reservation(mt)
    Reservation.find(mt.reservation_id)
  end

  def feature_guides_profile
    if Rails.env.production?
      ids = [20,25,39,59,109,116]
      profiles = Profile.find(ids)
      ordered_profiles = ids.collect {|id| profiles.detect {|x| x.id == id.to_i}}
      return ordered_profiles
    else
      ids = Profile.without_soft_destroyed.ids.sample(6)
      return Profile.find(ids)
    end
  end

  def feature_listing(id)
    listing = Listing.where(id: id).first
  end

  def pickup_tag_to_placeholder(pickup_tag)
    if pickup_tag.short_name == 'Spa and Relaxation'
      'Eg. Massage, yoga, etc'
    elsif pickup_tag.short_name == 'Cultural Sites'
      'Eg. Temples, Japanese gardens,Kamakura-bori, etc.'
    elsif pickup_tag.short_name == 'Food and Drink'
      'Eg. Sake, soba noodles, cooking, etc.'
    elsif pickup_tag.short_name == 'Shopping'
      'Eg. Harajuku, fashion, household appliances, etc.'
    elsif pickup_tag.short_name == 'Outdoors'
      'Eg. Cycling, hiking, BBQ, etc.'
    elsif pickup_tag.short_name == 'Sports'
      'Eg. Baseball games, football, etc.'
    elsif pickup_tag.short_name == 'Gardens'
      'Eg. Botan-en, gardening, etc.'
    elsif pickup_tag.short_name == 'Tourist Hotspots'
      'Eg. Daibutsu, Tokyo Tower, Yanaka Ginza Shopping Street, etc.'
    elsif pickup_tag.short_name == 'Art'
      'Eg. Oil paintings, Ueno Royal Museum, Picasso, etc.'
    elsif pickup_tag.short_name == 'Manga and Anime'
      'Eg. Dragonball-Z, Akihabara, etc.'
    elsif pickup_tag.short_name == 'Onsen'
      'Eg. Open-air onsen, Hakone, etc.'
    elsif pickup_tag.short_name == 'Theme Parks'
      'Eg. Disneyland, planetarium, zoos, etc.'
    elsif pickup_tag.short_name == 'Entertainment'
      'Eg. The Beatles, movies, karaoke, etc.'
    elsif pickup_tag.short_name == 'Experiences'
      'Eg. Pottery, rafting, etc.'
    elsif pickup_tag.short_name == 'Night Life'
      'Eg. Bars, clubs, night views, etc.'
    end
  end

  def profile_pickup_to_pickup_tag(profile_pickup)
    pickup_tag = PickupTag.find(profile_pickup.pickup_id)
  end

  def exist_profile_blank?
    current_user.profile.enable_strict_validation = true
    !current_user.profile.valid? or !profile_identity_authorized?(current_user.id)
  end

  def display_news?
    Announcement.display.present?
  end

  def profile_completed?
    current_user.profile.enable_strict_validation = true
    current_user.profile.valid?
  end

  def message_thread_link(to_user_id, from_user_id)
    message_thread_path(GuestThread.get_message_thread_id(to_user_id, from_user_id))
  end
  
  def disabled_language_id
    Language.where(name: 'English').first.id
  end
  
  def checked_language_ids(profile)
    profile.language_ids.index(disabled_language_id) ? @profile.language_ids : @profile.language_ids.push(disabled_language_id)
  end
  
  def what_talk_about_contents
    [
      {name: 'Spots', image: 'what_talk_about/ttm_spots.png'},
      {name: 'Food', image: 'what_talk_about/ttm_food.png'},
      {name: 'Activities', image: 'what_talk_about/ttm_activities.png'},
      {name: 'Others', image: 'what_talk_about/ttm_others.png'}
    ]
  end
  
  def what_talk_about_message?(message)
    what_talk_about_contents.each do |content|
      return true if message == Settings.message.what_talk_about.to_guide + content[:name].downcase! + '.'
      return true if message == Settings.message.what_talk_about.to_guide_other + '.'
    end
    return false
  end
  
  def favorite_listing?(history)
    history.model_name == 'FavoriteListing'
  end

  def report_reasons
    ['Spam/advertising.', 'They are using TOMODACHI GUIDE as a dating site.', 'They are causing trouble.', 'Other']
  end
end
