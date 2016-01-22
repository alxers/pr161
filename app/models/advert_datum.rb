class AdvertDatum < ActiveRecord::Base
  belongs_to :report

  def self.apply_defaults_for(table)
    table.each { |key, val| table[key] = 0 if val.nil? }
    table
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
end
