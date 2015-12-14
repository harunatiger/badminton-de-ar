require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  # I18n で CSV のカラム名を取得
  cols = {
    'id' => ->(host_profit_info){ host_profit_info[:id] },
    'host_id' => ->(host_profit_info){ host_profit_info[:host_id] },
    'guest_id' => ->(host_profit_info){ host_profit_info[:guest_id] },
    'listing_id' => ->(host_profit_info){ host_profit_info[:listing_id] },
    'schedule' => ->(host_profit_info){ host_profit_info[:schedule] },
    'num_of_people' => ->(host_profit_info){ host_profit_info[:num_of_people] },
    'msg' => ->(host_profit_info){ host_profit_info[:msg] },
    'progress' => ->(host_profit_info){ host_profit_info[:progress] },
    'reason' => ->(host_profit_info){ host_profit_info[:reason] },
    'review_mail_sent_at' => ->(host_profit_info){ host_profit_info[:review_mail_sent_at] },
    'review_expiration_date' => ->(host_profit_info){ host_profit_info[:review_expiration_date] },
    'review_landed_at' => ->(host_profit_info){ host_profit_info[:review_landed_at] },
    'reviewed_at' => ->(host_profit_info){ host_profit_info[:reviewed_at] },
    'reply_mail_sent_at' => ->(host_profit_info){ host_profit_info[:reply_mail_sent_at] },
    'reply_landed_at' => ->(host_profit_info){ host_profit_info[:reply_landed_at] },
    'replied_at' => ->(host_profit_info){ host_profit_info[:replied_at] },
    'review_opened_at' => ->(host_profit_info){ host_profit_info[:review_opened_at] },
    'time_required' => ->(host_profit_info){ host_profit_info[:time_required] },
    'price' => ->(host_profit_info){ host_profit_info[:price] },
    'option_price' => ->(host_profit_info){ host_profit_info[:option_price] },
    'place' => ->(host_profit_info){ host_profit_info[:place] },
    'description' => ->(host_profit_info){ host_profit_info[:description] },
    'schedule_end' => ->(host_profit_info){ host_profit_info[:schedule_end] },
    'option_price_per_person' => ->(host_profit_info){ host_profit_info[:option_price_per_person] },
    'place_memo' => ->(host_profit_info){ host_profit_info[:place_memo] },
    'campaign_id' => ->(host_profit_info){ host_profit_info[:campaign_id] },
    'price_other' => ->(host_profit_info){ host_profit_info[:price_other] },
    'created_at' => ->(host_profit_info){ host_profit_info[:created_at] },
    'updated_at' => ->(host_profit_info){ host_profit_info[:updated_at] },
    'remarks' => ->(host_profit_info){ host_profit_info[:remarks] },
  }

  # header の追加
  csv << cols.keys

  # body の追加
  if @host_profit_infos.present?
    @host_profit_infos.each do |host_profit_info|
      csv << cols.map{|k, col| col.call(host_profit_info) }
    end
  end
end
# 文字コード変換
NKF::nkf('--sjis -Lw', csv_str)
