class Creative < Advertiser

  def self.create_report(rep)
    report = PlatformApi.new.get_creative_report(rep.campaign_id)
    report = report.map { |r| r = apply_defaults_for(r) }
    rep.creatives.create(report)
  end
end
