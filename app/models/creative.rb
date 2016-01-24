class Creative < Advertiser
  belongs_to :report

  def self.create_report(rep)
    # report = PlatformApi.new.get_creative_report['results'].select { |r| r['campaign_id'] == rep.campaign_id }
    report = PlatformApi.new.get_creative_report(rep.campaign_id)
    report = report.map do |r|
      r = apply_defaults_for(r)
    end
    rep.creatives.create(report)
  end
end
