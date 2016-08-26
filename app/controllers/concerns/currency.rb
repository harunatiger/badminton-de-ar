module Currency
  def self.currency_list
    ['AUD','CAD','CZK','DKK','EUR','HKD','HUF','ILS','JPY','MXN','NOK','NZD','PHP','PLN','GBP','RUB','SGD','SEK','CHF','TWD','THB','USD']
  end
  
  def self.locale_and_currency_hash
    {AU: 'AUD', CA: 'CAD', CZ: 'CZK', DK: 'DKK', EU: 'EUR', HK: 'HKD', HU: 'HUF', IL: 'ILS', JP: 'JPY', MX: 'MXN', NO: 'NOK', NZ: 'NZD', PH: 'PHP', PL: 'PLN', GB: 'GBP', RU: 'RUB', SG: 'SGD', SE: 'SEK', CH: 'CHF', TW: 'TWD', TH: 'THB', US: 'USD'}
  end
  
  def self.currency_code_and_sign_hash
    { 'AUD' => '$', 'CAD' => '$', 'CZK' => 'Kč', 'DKK' => 'kr', 'EUR' => '€', 'HKD' => 'HK$', 'HUF' => 'Ft', 'ILS' => '₪', 'JPY' => '¥', 'MXN' => '$', 'NOK' => 'kr', 'NZD' => '$', 'PHP' => '₱', 'PLN' => 'zł', 'GBP' => '£', 'RUB' => '₽', 'SGD' => '$', 'SEK' => 'kr', 'CHF' => 'S₣', 'TWD' => 'NT$', 'THB' => '฿', 'USD' => '$'}
  end
  
  def self.local_to_currency_code(locale)
    return 'JPY' if locale.blank? or self.locale_and_currency_hash[locale].blank?
    self.locale_and_currency_hash[locale]
  end
  
  def self.get_rate(to_currency_code)
    exchange = PaypalAdaptive::Request.new
    response = exchange.convert_currency({requestEnvelope: {}, baseAmountList: [currency: {amount: 100, code: 'JPY'}], convertToCurrencyList: [{currencyCode: to_currency_code}]})
    p rate = response['estimatedAmountTable']['currencyConversionList'][0]['currencyList']['currency'][0]['amount'].to_f / 100
  end
end