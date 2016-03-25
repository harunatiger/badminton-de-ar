class AddListingInterviewToListing < ActiveRecord::Migration
  def change
    add_column :listings, :interview1, :string, default: ''
    add_column :listings, :interview2, :string, default: ''
    add_column :listings, :interview3, :string, default: ''

    Listing.all.each do |l|
      listing_id = l.id
      if listing_id.present?
        in_case_of_rain = ListingDetail.where(listing_id: listing_id).pluck(:in_case_of_rain).first
        notes = l.notes
        m_notes = ''
        if notes.blank?
          notes = ''
        end
        if in_case_of_rain.present?
          m_notes = "\r\n\r\n" + '[In the case of rainy weather]' + "\r\n" + in_case_of_rain
        end
        m_notes = notes + m_notes

        overview = l.overview
        recommend1 = l.recommend1
        recommend2 = l.recommend2
        recommend3 = l.recommend3
        description = l.description

        m_overview = ''
        if overview.blank?
          overview = ''
        end

        m_recommend = ''
        if recommend1.present?
          m_recommend = m_recommend + '1: ' + recommend1 + "\r\n"
        end
        if recommend2.present?
          m_recommend = m_recommend + '2: ' + recommend2 + "\r\n"
        end
        if recommend3.present?
          m_recommend = m_recommend + '3: ' + recommend3 + "\r\n"
        end

        if m_recommend.present?
          m_recommend =  "\r\n\r\n" + '[Best features of My Tour]' + "\r\n" + m_recommend
        end

        m_description = ''
        if description.present?
          m_description = description
        end

        m_overview = overview + m_recommend + m_description

        l.update!(notes: m_notes, overview: m_overview)
      end
    end
  end
end
