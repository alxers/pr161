class Campaign < Advertiser

  def self.create_report(report)
    campaign = PlatformApi.new.get_campaign_report(report.campaign_id)
    campaign = apply_defaults_for(campaign)
    report.create_campaign(campaign)
  end
end
