require 'squid'

class PdfMaker
  def initialize(report)
    @pdf = Prawn::Document.new
    @campaign_res = report.campaign
    @creative_res = report.creatives
    @charts_res = report.charts
  end

  def generate
    create_table(@campaign_res, 'campaign_name')
    @creative_res.each do |res|
      create_table(res, 'creative_name')
    end

    create_bar_graph('Spen per day', 'media_spent')

    @pdf.start_new_page
    create_line_graph('Impressions', 'Clicks', 'impressions', 'clicks')
    create_line_graph('eCPM', 'eCPC', 'ecmp', 'ecpc')
    create_bar_graph('Ctr', 'ctr')

    @pdf.start_new_page
    create_bar_graph('Conversions', 'conversions')

    @pdf.render
  end

  private
    def create_table(table, title)
        @pdf.table([
          [title.titleize, 'Impressions', 'Clicks', 'Media Budget', 'Ctr', 'Conv.', 'eCPM', 'eCPC', 'eCPA', 'Spent'],
          [table.send(title), table.impressions, table.clicks, table.media_budget,
           table.ctr, table.conversions, table.ecpm, table.ecpc, table.ecpa, table.media_spent]
          ])
    end

    def prepare_chart_data(field_name)
      @charts_res.map { |d| [d.date, d[field_name]] }.to_h
    end

    def create_bar_graph(title, field_name)
      @pdf.chart({ title => prepare_chart_data(field_name) })
    end

    def create_line_graph(title1, title2, field_name1, field_name2)
      @pdf.chart({ title1 => prepare_chart_data(field_name1),
      title2 => prepare_chart_data(field_name2) }, { type: :line })
    end
end
