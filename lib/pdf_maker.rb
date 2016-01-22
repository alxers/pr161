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
    campaign_cost_graph

    @pdf.start_new_page
    imp_vs_clicks_graph
    ecpm_ecpc_graph
    ctr_graph

    @pdf.start_new_page
    conversions_graph

    @pdf.render
  end

  private
    # def create_table
    # end

    def create_table(table, title)
        @pdf.table([
          [title.titleize, 'Impressions', 'Clicks', 'Media Budget', 'Ctr', 'Conv.', 'eCPM', 'eCPC', 'eCPA', 'Spent'],
          [table.send(title), table.impressions, table.clicks, table.media_budget,
           table.ctr, table.conversions, table.ecpm, table.ecpc, table.ecpa, table.media_spent]
          ])
    end

    # def create_graph(data, value)
    #   @pdf.chart({ views: data.map {|d| [d['date'], d[value]]}.to_h }, {type: :line})
    # end

    def campaign_cost_graph
      @pdf.chart({ 'Spen per day' => @charts_res.map { |d| [d.date, d.media_spent] }.to_h })
    end

    def imp_vs_clicks_graph
      @pdf.chart({ 'Impressions' => @charts_res.map { |d| [d.date, d.impressions] }.to_h,
      'clicks' => @charts_res.map { |d| [d.date, d.clicks] }.to_h }, { type: :line })
    end

    def ecpm_ecpc_graph
      @pdf.chart({ 'eCPM' => @charts_res.map { |d| [d.date, d.ecpm] }.to_h,
      'eCPC' => @charts_res.map { |d| [d.date, d.ecpc] }.to_h }, { type: :line })
    end

    def ctr_graph
      @pdf.chart({ 'Ctr' => @charts_res.map { |d| [d.date, d.ctr] }.to_h })
    end

    def conversions_graph
      @pdf.chart({ 'Conversions' => @charts_res.map { |d| [d.date, d.conversions] }.to_h })
    end
end
