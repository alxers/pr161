class Advertiser < ActiveRecord::Base
  belongs_to :report

  FILTERED_FIELDS = %w(remaining_media_budget campaign_cost anomaly_clicks_filtered creative_id gross_revenues)
  START_DATE = 30
  START_DATE_CHARTS = 7

  def self.apply_defaults_for(table)
    if self.name == 'Charts'
      table['start_date'] = START_DATE_CHARTS.days.ago
    else
      table['start_date'] = START_DATE.days.ago
    end
    table['end_date'] = Date.today
    table['media_spent'] = table['campaign_cost']
    table.merge! ecp_fields(table)
    table = table.except(*FILTERED_FIELDS)
    table.each { |key, val| table[key] = 0 if val.nil? }
  end

  def self.calculate_vals(table, val)
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

  def self.ecp_fields(table)
    {
      'ecpm' => calculate_vals(table, 'eCPM'),
      'ecpc' => calculate_vals(table, 'eCPC'),
      'ecpa' => calculate_vals(table, 'eCPA')
    }
  end
end
