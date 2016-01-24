class Campaign < Advertiser
  belongs_to :report

  def self.create_report(rep)
    report = PlatformApi.new.get_campaign_report['results'].select {|r| r['campaign_id'] == rep.campaign_id}.first
    report = apply_defaults_for(report)
    rep.create_campaign(report)
  end
end
