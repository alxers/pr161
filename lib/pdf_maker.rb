require 'squid'

class PdfMaker
  def initialize(report)
    @pdf = Prawn::Document.new
    @campaign_res = report.campaign
    @creative_res = report.creatives
    @charts_res = report.charts
  end

  def generate
    create_table_header(@campaign_res, 'campaign_name')
    @pdf.move_down 50
    create_table([@campaign_res], 'campaign_name')
    @pdf.move_down 50
    create_table(@creative_res, 'creative_name')

    @pdf.start_new_page
    create_bar_graph('Spen per day', 'media_spent')
    create_line_graph('Impressions', 'Clicks', 'impressions', 'clicks')
    create_line_graph('eCPM', 'eCPC', 'ecmp', 'ecpc')

    @pdf.start_new_page
    create_bar_graph('Ctr', 'ctr')
    create_bar_graph('Conversions', 'conversions')

    @pdf.render
  end

  private
    def create_table_header(table, title)
      @pdf.table([
        [title.titleize, 'Start date', 'End date', 'Media budget', 'Media spent'],
        [table.campaign_name.titleize, table.start_date, table.end_date, table.media_budget, table.media_spent]
        ])
    end

    def create_table(table, title)
      d = []
      d[0] = [title.titleize, 'Impressions', 'Clicks', 'Media Budget', 'Ctr', 'Conv.', 'eCPM', 'eCPC', 'eCPA', 'Spent']
      table.map { |t| d << [t.send(title).titleize, t.impressions, t.clicks, t.media_budget,
       t.ctr, t.conversions, t.ecpm, t.ecpc, t.ecpa, t.media_spent]}

      @pdf.table(d)
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
