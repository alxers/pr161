require 'squid'

class PdfMaker
  def initialize
    auth = Auth.new
    @pdf = Prawn::Document.new
    # @results = Auth.new.get_report['results'].first
    @campaign_res = auth.get_camaign_report['results'].first
    @creative_res = auth.get_creative_report['results'].first
    # binding.pry
    @charts_res = auth.get_charts_report['results']
  end

  def generate
    apply_defaults_for([@campaign_res, @creative_res])

    create_table(@campaign_res, 'campaign_name')
    create_table(@creative_res, 'creative_name')
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
    def apply_defaults_for(tables)
      tables.each do |t|
        t.each { |key, val| t[key] = 0 if val.nil? }
      end
    end

    def calculate_vals(table, val)
      table['gross_revenues'] = 0 if table['gross_revenues'].nil?
      case val
      when 'eCPM'
        table['impressions'].nonzero? ? table['gross_revenues'] / table['impressions'] * 1000 : 0
      when 'eCPC'
        table['clicks'].nonzero? ? table['gross_revenues'] / table['clicks'] : 0
      when 'eCPA'
        table['conversions'].nonzero? ? table['gross_revenues'] / table['conversions'] : 0
      end
    end

    def create_table(table, title)
        @pdf.table([
          [title.titleize, 'Impressions', 'Clicks', 'Media Budget', 'Ctr', 'Conv.', 'eCPM', 'eCPC', 'eCPA', 'Spent'],
          [table[title], table['impressions'], table['clicks'], table['media_budget'],
           table['ctr'], table['conversions'], calculate_vals(table, 'eCPM'),
           calculate_vals(table, 'eCPC'), calculate_vals(table, 'eCPA'),
           table['campaign_cost']]
          ])
    end

    # def create_graph(data, value)
    #   @pdf.chart({ views: data.map {|d| [d['date'], d[value]]}.to_h }, {type: :line})
    # end

    def campaign_cost_graph
      @pdf.chart({ 'Spen per day' => @charts_res.map {|d| [d['date'], d['campaign_cost']]}.to_h })
    end

    def imp_vs_clicks_graph
      @pdf.chart({ 'Impressions' => @charts_res.map {|d| [d['date'], d['impressions']]}.to_h,
      'clicks' => @charts_res.map {|d| [d['date'], d['clicks']]}.to_h }, { type: :line })
      # @pdf.chart({ 'clicks' => @charts_res.map {|d| [d['date'], d['clicks']]}.to_h }, { type: :line })
    end

    def ecpm_ecpc_graph
      @pdf.chart({ 'eCPM' => @charts_res.map {|d| [d['date'], calculate_vals(d, 'eCPM')] }.to_h,
      'eCPC' => @charts_res.map {|d| [d['date'], calculate_vals(d, 'eCPC')] }.to_h }, { type: :line })
    end

    def ctr_graph
      @pdf.chart({ 'Ctr' => @charts_res.map {|d| [d['date'], d['ctr'].to_f]}.to_h })
    end

    def conversions_graph
      @pdf.chart({ 'Conversions' => @charts_res.map {|d| [d['date'], d['conversions']]}.to_h })
    end
end
