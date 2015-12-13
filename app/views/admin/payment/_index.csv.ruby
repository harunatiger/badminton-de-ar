require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  # I18n で CSV のカラム名を取得
  cols = {
    'ID' => ->(r){ r.id },
    'リスティング名' => ->(r){ r.listing.title },
    '予約申込日' => ->(r){ l r.created_at },
    '予約日' => ->(r){ l r.schedule },
    'サービス合計金額' => ->(r){ r.amount }
  }

  # header の追加
  csv << cols.keys

  # body の追加
  @reservations.each do |r|
    csv << cols.map{|k, col| col.call(r) }
  end
end
# 文字コード変換
NKF::nkf('--sjis -Lw', csv_str)