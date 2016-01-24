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
    uri = URI(Rails.application.secrets.site_url + 'api/v2/advertiser_reports/')
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, @headers)
    req.add_field('Content-Type', 'application/json')
    req.body = type_params.to_json
    res = https.request(req)
    puts "Response #{res.code} #{res.message}: #{res.body}"
    JSON.parse(res.body)
  end

  def get_advert_report(type, campaign_id = nil)
    case type
    when :campaign
      # Advertiser.new.apply_defaults_for(get_campaign_report['results'].select {|r| r['campaign_id'] == campaign_id}.first)
      get_campaign_report
    when :creative
      get_creative_report
    when :charts
      get_charts_report
    end
  end

  def get_campaign_report(campaign_id)
    report = get_report(default_params)['results'].select {|r| r['campaign_id'] == campaign_id}.first
    report.apply_defaults
  end

  def get_creative_report(campaign_id)
    report = get_report(creative_params)['results'].select { |r| r['campaign_id'] == campaign_id }
    report.apply_defaults
  end

  def get_charts_report
    report = get_report(charts_params)['results']
    report.apply_defaults
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
