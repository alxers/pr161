class Creative < Advertiser

  def self.create_report(report)
    creatives = PlatformApi.new.get_creative_report(report.campaign_id)
    creatives = creatives.map { |creative| apply_defaults_for(creative) }
    report.creatives.create(creatives)
  end
end
