class Campaign < AdvertDatum
  belongs_to :report

  def self.create_report(rep)
    report = Auth.new.get_camaign_report['results'].select {|r| r['campaign_id'] == rep.campaign_id}.first
    report['media_spent'] = report['campaign_cost']
    report = apply_defaults_for(report).except('remaining_media_budget', 'campaign_cost', 'anomaly_clicks_filtered')
    rep.create_campaign(report)
  end
end
