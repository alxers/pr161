class Campaign < AdvertDatum
  belongs_to :report

  def self.create_report(rep)
    report = Auth.new.get_camaign_report['results'].select {|r| r['campaign_id'] == rep.campaign_id}.first
    report = apply_defaults_for(report)
    rep.create_campaign(report)
  end
end
