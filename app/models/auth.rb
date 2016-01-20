class Auth

  def initialize
    unless token = Token.where(active: true).first.try(:token)
      token = authenticate['token']
    end
    @headers = {'PFM161-API-AccessToken' => token }
  end

  def authenticate
    uri = URI(Rails.application.secrets.site_url + 'api/v2/access_tokens/')

    res = Net::HTTP.post_form(uri, Rails.application.secrets.credentials)
    Token.create(token: JSON.parse(res.body)['token'], active: true)
  end

  def get_report
    grouping = [:campaigns]
    params = {
      advertiser_report: {
      groupings: grouping,
      period: :last_30_days,
      interval: :daily
    }
    }

    uri = URI(Rails.application.secrets.site_url + 'api/v2/advertiser_reports/')
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, @headers)
    req.set_form_data(params)
    res = https.request(req)
    puts "Response #{res.code} #{res.message}: #{res.body}"
    JSON.parse(res.body)
  end
end
