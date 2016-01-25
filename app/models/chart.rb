class Chart < Advertiser
  belongs_to :report

  def self.create_report(rep)
    report = PlatformApi.new.get_charts_report
    report = report.map { |r| r = apply_defaults_for(r) }
    rep.charts.create(report)
  end
end
