module Currency
  def self.currency_list
    #['AUD','CAD','CZK','DKK','EUR','HKD','HUF','ILS','JPY','MXN','NOK','NZD','PHP','PLN','GBP','RUB','SGD','SEK','CHF','TWD','THB','USD']
    ['EUR','JPY','USD']
  end
  
  def self.language_and_currency_hash
    #{'en-AU' => 'AUD', 'en-CA' => 'CAD', 'fr-CA' => 'CAD', 'cs' => 'CZK', 'da' => 'DKK', "ga" => 'EUR', "it" => 'EUR', "et" => 'EUR', "de" => 'EUR', "nl" => 'EUR', "el" => 'EUR', "es" => 'EUR', "sk" => 'EUR', "sl" => 'EUR', "fi" => 'EUR', "fr" => 'EUR', "pt" => 'EUR', "mt" => 'EUR', "lv" => 'EUR', "lt" => 'EUR', "zh" => 'HKD', "zh-HK" => 'HKD', "hu" => 'HUF', "he" => 'ILS', "ar" => 'ILS', 'ja' => 'JPY', "es-MX" => 'MXN', "no" => 'NOK', "en-NZ" => 'NZD', "fil" => 'PHP', "pl" => 'PLN', "en-GB" => 'GBP', "ru" => 'RUB', "sv" => 'SEK', "th" => 'THB', "en-US" => 'USD', "en" => 'USD'}
    {'en-AU' => 'USD', 'en-CA' => 'USD', 'fr-CA' => 'USD', 'cs' => 'USD', 'da' => 'USD', "ga" => 'EUR', "it" => 'EUR', "et" => 'EUR', "de" => 'EUR', "nl" => 'EUR', "el" => 'EUR', "es" => 'EUR', "sk" => 'EUR', "sl" => 'EUR', "fi" => 'EUR', "fr" => 'EUR', "pt" => 'EUR', "mt" => 'EUR', "lv" => 'EUR', "lt" => 'EUR', "zh" => 'USD', "zh-HK" => 'USD', "hu" => 'USD', "he" => 'USD', "ar" => 'USD', 'ja' => 'JPY', "es-MX" => 'USD', "no" => 'USD', "en-NZ" => 'USD', "fil" => 'USD', "pl" => 'USD', "en-GB" => 'USD', "ru" => 'USD', "sv" => 'USD', "th" => 'USD', "en-US" => 'USD', "en" => 'USD'}
  end
  
  def self.currency_code_and_sign_hash
    { 'AUD' => '$', 'CAD' => '$', 'CZK' => 'Kč', 'DKK' => 'kr', 'EUR' => '€', 'HKD' => 'HK$', 'HUF' => 'Ft', 'ILS' => '₪', 'JPY' => '¥', 'MXN' => '$', 'NOK' => 'kr', 'NZD' => '$', 'PHP' => '₱', 'PLN' => 'zł', 'GBP' => '£', 'RUB' => '₽', 'SGD' => '$', 'SEK' => 'kr', 'CHF' => 'S₣', 'TWD' => 'NT$', 'THB' => '฿', 'USD' => '$'}
  end
  
  def self.language_to_currency_code(language)
    return 'JPY' if language.blank?
    language_and_currency_hash[language]
  end
  
  def self.get_rate(to_currency_code)
    exchange = PaypalAdaptive::Request.new
    response = exchange.convert_currency({requestEnvelope: {}, baseAmountList: [currency: {amount: 100, code: 'JPY'}], convertToCurrencyList: [{currencyCode: to_currency_code}]})
    p rate = response['estimatedAmountTable']['currencyConversionList'][0]['currencyList']['currency'][0]['amount'].to_f / 100
  end
  
  def self.available_locales
      ['en-AU', 'en-CA', 'fr-CA', 'cs', 'da', "ga", "it", "et", "de", "nl", "el", "es", "sk", "sl", "fi", "fr", "pt", "mt", "lv", "lt", "zh", "zh-HK", "hu", "he", "ar", "ja", "es-MX", "no", "en-NZ", "fil", "pl", "en-GB",'en', "ru", "sv", "th", "en-US"]
  end
end