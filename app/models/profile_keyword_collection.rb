class ProfileKeywordCollection < Form::Base
  DEFAULT_ITEM_COUNT = 5
  attr_accessor :profile_keywords
  attr_accessor :user_id
  attr_accessor :profile_id

  def initialize(attributes = {}, user_id, profile_id)
    profiles = ProfileKeyword.where(user_id: user_id, profile_id: profile_id).keyword_limit
    super attributes
    unless profile_keywords.present?
      self.profile_keywords = profiles.present? ? profiles + (DEFAULT_ITEM_COUNT - profiles.count).times.map { ProfileKeyword.new(user_id: user_id, profile_id: profile_id) } : DEFAULT_ITEM_COUNT.times.map { ProfileKeyword.new(user_id: user_id, profile_id: profile_id) }
    end
  end

  def profile_keywords_attributes=(attributes)
    self.profile_keywords = attributes.map do |_, profile_keyword_attributes|
      ProfileKeyword.new(profile_keyword_attributes)
    end
  end

  def valid?
    valid_profile_keywords = self.profile_keywords.map(&:valid?).all?
    super && valid_profile_keywords
  end

  def keyword_present?
    target_profile_keywords.present?
  end

  def save
    return false unless valid?
    ProfileKeyword.transaction {
      target_profile_keywords.each_with_index do |target_profile_keyword, i|
        if target_profile_keyword.id.present?
          profile_keyword = ProfileKeyword.find(target_profile_keyword.id)
          profile_keyword.update_attributes!(keyword: target_profile_keyword.keyword, level: target_profile_keyword.level)
        else
          target_profile_keyword.save!
        end
      end
    }
    true
  end

  def target_profile_keywords
    self.profile_keywords.select { |v| v.id.present? or v.keyword.present? or v.level.present?}
  end

end
