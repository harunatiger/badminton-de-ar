module OgpSetting
  def self.update(url)
    uri = URI.parse('https://graph.facebook.com/?scrape=true&id=' + url)
   
    response = nil
    
    request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
    #request.body = {name: "web", config: {url: "hogehogehogehoge"}}.to_json
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    http.set_debug_output $stderr
    
    http.start do |h|
      p response = h.request(request)
    end
  end
end