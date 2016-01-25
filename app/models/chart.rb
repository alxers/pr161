class Chart < Advertiser

  def self.create_report(report)
    charts = PlatformApi.new.get_charts_report
    charts = charts.map { |chart| apply_defaults_for(chart) }
    report.charts.create(charts)
  end
end
