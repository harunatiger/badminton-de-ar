require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  # I18n で CSV のカラム名を取得
  cols = {
    '決済ID' => ->(host_profit_info){ host_profit_info[:id] },
    'メインガイドID' => ->(host_profit_info){ host_profit_info[:host_id] },
    'メインガイド名' => ->(host_profit_info){ host_profit_info[:host_name] },
    'サポートガイドID' => ->(host_profit_info){ host_profit_info[:support_guide_id] },
    'サポートガイド名' => ->(host_profit_info){ host_profit_info[:support_guide_name] },
    'ゲストID' => ->(host_profit_info){ host_profit_info[:guest_id] },
    'ゲスト名' => ->(host_profit_info){ host_profit_info[:guest_name] },
    'プラン実施日' => ->(host_profit_info){ host_profit_info[:schedule] },
    'キャンセル日' => ->(host_profit_info){ host_profit_info[:cancel_date] },
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
    'ガイドの収入' => ->(host_profit_info){ host_profit_info[:listing_price] },
    'サポートメンバーの収入' => ->(host_profit_info){ host_profit_info[:listing_price_for_support] },
    'オプション費用' => ->(host_profit_info){ host_profit_info[:listing_option_amount] },
    'ガイド料金' => ->(host_profit_info){ host_profit_info[:guide_amount] },
    'サービス料金（ゲスト）' => ->(host_profit_info){ host_profit_info[:service_fee_guest] },
    'CPディスカウント金額' => ->(host_profit_info){ host_profit_info[:campaign_discount] },
    '決済金額' => ->(host_profit_info){ host_profit_info[:reservation_price] },
    'キャンセル事由' => ->(host_profit_info){ host_profit_info[:refund_reason] },
    '確定ガイド料金' => ->(host_profit_info){ host_profit_info[:fixed_amount] },
    'サービス料金（ガイド）' => ->(host_profit_info){ host_profit_info[:service_fee_guide] },
    'メインガイド支払' => ->(host_profit_info){ host_profit_info[:guide_payment] },
    'サポートガイド支払' => ->(host_profit_info){ host_profit_info[:support_guide_payment] },
    'ゲスト返金' => ->(host_profit_info){ host_profit_info[:guest_refund] },
    '自動返金' => ->(host_profit_info){ host_profit_info[:refund_complete] },
    'Paypal決済トランID' => ->(host_profit_info){ host_profit_info[:payment_transaction_id] },
    'CPコード' => ->(host_profit_info){ host_profit_info[:campaign_code] },
    'ゲストPaypalID' => ->(host_profit_info){ host_profit_info[:guest_paypal_id] },
    'ReservationID' => ->(host_profit_info){ host_profit_info[:reservation_id] },
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
