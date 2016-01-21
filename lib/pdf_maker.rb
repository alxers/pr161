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
    # pdf.table([
    #           ['Campaign name', 'Impressions', 'Clicks', 'Media Budget', 'Ctr', 'Conv.', 'eCPM', 'eCPC', 'eCPA', 'Spent'],
    #           [@campaign_res['campaign_name'], @campaign_res['impressions'], @campaign_res['clicks'], @campaign_res['media_budget'],
    #            @campaign_res['ctr'], @campaign_res['conversions'], calculate_vals(@campaign_res, 'eCPM'),
    #            calculate_vals(@campaign_res, 'eCPC'), calculate_vals(@campaign_res, 'eCPA'),
    #            @campaign_res['campaign_cost']]
    #       ])
    create_table(@campaign_res, 'campaign_name')
    create_table(@creative_res, 'creative_name')
    create_graph(@charts_res)
    # pdf.text "Hello World"
    @pdf.render
  end

  private
    def apply_defaults_for(tables)
      tables.each do |t|
        t['gross_revenues'] = 0 if t['gross_revenues'].nil?
        t.each { |key, val| t[key] = 0 if val.nil? }
      end
    end

    def calculate_vals(table, val)
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

    def create_graph(data)
      @pdf.chart views: data.map {|d| [d['date'], d['campaign_cost']]}.to_h
    end
end
