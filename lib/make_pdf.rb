class MakePDF
  def initialize
    @results = Auth.new.get_report['results'].first
  end

  def generate
    pdf = Prawn::Document.new

    # @results['gross_revenues']
    binding.pry
    pdf.table([
              ['Campaign name', 'Impressions', 'Clicks', 'Ctr', 'Conv.', 'eCPM', 'eCPC', 'eCPA', 'Spent'],
              [@results['campaign_name'], @results['impressions'], @results['clicks'], @results['media_budget'],
               @results['ctr'], @results['conversions']]
          ])
    pdf.text "Hello World"
    pdf.render
  end

  private
    def default_val
      if @results['gross_revenues'].blank?
        @results['gross_revenues'] = 0
      end
    end

    def calculate_vals
    end
end
