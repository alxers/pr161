class Chart < AdvertDatum
  belongs_to :report

  def self.create_report(rep)
    report = PlatformApi.new.get_charts_report['results']
    report = report.map do |r|
      r = apply_defaults_for(r)
    end
    rep.charts.create(report)
  end
end
