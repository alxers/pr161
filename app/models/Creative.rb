class Creative < AdvertDatum
  belongs_to :report

  def self.create_report(rep)
    report = Auth.new.get_creative_report['results'].select { |r| r['campaign_id'] == rep.campaign_id }
    report = report.map do |r|
      r['media_spent'] = r['campaign_cost']
      r = apply_defaults_for(r).except('remaining_media_budget', 'campaign_cost', 'anomaly_clicks_filtered', 'creative_id')
    end
    rep.creatives.create(report)
  end
end
