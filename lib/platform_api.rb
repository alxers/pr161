class PlatformApi

  def initialize
    unless token = Token.get_active
      token = authenticate['token']
    end
    @headers = {'PFM161-API-AccessToken' => token }
  end

  def authenticate
    uri = URI(Rails.application.secrets.site_url + 'api/v2/access_tokens/')
    res = Net::HTTP.post_form(uri, Rails.application.secrets.credentials)
    if !res.code.in?(['200', '201'])
      raise(::PlatformApiError, res.message)
    else
      Token.create(token: JSON.parse(res.body)['token'], active: true)
    end
  end

  def get_report(type_params)
    res = send_request(type_params)
    json_result = JSON.parse(res.body)
    raise(::PlatformApiError, json_result['error']) if json_result.has_key? 'error'
    json_result
  end

  def get_campaign_report(campaign_id)
    get_report(default_params)['results'].select {|r| r['campaign_id'] == campaign_id}.first
  end

  def get_creative_report(campaign_id)
    get_report(creative_params)['results'].select { |r| r['campaign_id'] == campaign_id }
  end

  def get_charts_report
    get_report(charts_params)['results']
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

    def send_request(type_params)
      uri = URI(Rails.application.secrets.site_url + 'api/v2/advertiser_reports/')
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, @headers)
      req.add_field('Content-Type', 'application/json')
      req.body = type_params.to_json
      https.request(req)
    end
end
