class Campaign < Advertiser

  def self.create_report(rep)
    report = PlatformApi.new.get_campaign_report(rep.campaign_id)
    report = apply_defaults_for(report)
    rep.create_campaign(report)
  end
end
