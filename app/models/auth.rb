class Auth

  def initialize
    unless token = Token.get_active
      token = authenticate['token']
    end
    @headers = {'PFM161-API-AccessToken' => token }
  end

  def authenticate
    uri = URI(Rails.application.secrets.site_url + 'api/v2/access_tokens/')

    res = Net::HTTP.post_form(uri, Rails.application.secrets.credentials)
    Token.create(token: JSON.parse(res.body)['token'], active: true)
  end

  def get_report(type_params)
    uri = URI(Rails.application.secrets.site_url + 'api/v2/advertiser_reports/')
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, @headers)
    # req.set_form_data(type_params)
    req.add_field('Content-Type', 'application/json')
    req.body = type_params.to_json
    res = https.request(req)
    puts "Response #{res.code} #{res.message}: #{res.body}"
    JSON.parse(res.body)
  end

  def get_camaign_report
    get_report(default_params)
  end

  def get_creative_report
    get_report(creative_params)
  end

  def get_charts_report
    get_report(charts_params)
  end

  private
    def default_params
      {
        advertiser_report: {
          period: :last_30_days,
          interval: :daily
        }
      }
    end

    def creative_params
      default_params.deep_merge({
        advertiser_report: {
          groupings: [:campaign, :creative]
        }
      })
    end

    def charts_params
      default_params.deep_merge({
        advertiser_report: {
          groupings: [:date],
          period: :last_7_days
        }
      })
    end
end
