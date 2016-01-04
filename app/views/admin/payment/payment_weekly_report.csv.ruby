require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  # I18n で CSV のカラム名を取得
  cols = {
    '決済ID' => ->(host_profit_info){ host_profit_info[:id] },
    'ガイドユーザーID' => ->(host_profit_info){ host_profit_info[:host_id] },
    'ゲストユーザーID' => ->(host_profit_info){ host_profit_info[:guest_id] },
    'プラン実施日' => ->(host_profit_info){ host_profit_info[:schedule] },
    '参加人数' => ->(host_profit_info){ host_profit_info[:num_of_people] },
    'ガイド銀行名称' => ->(host_profit_info){ host_profit_info[:host_bank_name] },
    'ガイド銀行支店名' => ->(host_profit_info){ host_profit_info[:host_bank_branch] },
    '口座種別' => ->(host_profit_info){ host_profit_info[:host_bank_account_type] },
    '口座名義人' => ->(host_profit_info){ host_profit_info[:host_bank_user_name] },
    '口座番号' => ->(host_profit_info){ host_profit_info[:host_bank_user_number] },
    'ガイドEmailアドレス' => ->(host_profit_info){ host_profit_info[:host_email] },
    'ゲストEmailアドレス' => ->(host_profit_info){ host_profit_info[:guest_email] },
    'プランID' => ->(host_profit_info){ host_profit_info[:listing_id] },
    'プランタイトル' => ->(host_profit_info){ host_profit_info[:listing_title] },
    'ペアガイド基本料金' => ->(host_profit_info){ host_profit_info[:listing_price] },
    'ペアガイド諸経費' => ->(host_profit_info){ host_profit_info[:listing_price_other] },
    '諸経費（グループ）' => ->(host_profit_info){ host_profit_info[:listing_option_price] },
    '諸経費（ゲスト）' => ->(host_profit_info){ host_profit_info[:listing_option_price_per_person] },
    '決済確定総金額' => ->(host_profit_info){ host_profit_info[:reservation_price] },
    'キャンセル後確定金額' => ->(host_profit_info){ host_profit_info[:refund_price] },
    'キャンセル事由' => ->(host_profit_info){ host_profit_info[:refund_reason] },
    'Paypal決済トランID' => ->(host_profit_info){ host_profit_info[:payment_transaction_id] },
    'CPコード' => ->(host_profit_info){ host_profit_info[:campaign_code] },
    'CPディスカウント金額' => ->(host_profit_info){ host_profit_info[:campaign_discount] },
    'ゲストPaypalID' => ->(host_profit_info){ host_profit_info[:guest_paypal_id] },
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
