class Report < ActiveRecord::Base
  before_create :make_report
  validates :comment, length: { maximum: 160 }
  validate :campaign_id_is_allowed

  def make_report
    report = Auth.new.get_camaign_report['results'].select {|r| r['campaign_id'] == campaign_id}.first
    report = apply_defaults_for(report)
    assign_attributes(campaign_name: report['campaign_name'], start_date: report['start_date'],
                      end_date: report['end_date'], media_budget: report['media_budget'],
                      media_spent: report['campaign_cost'], impressions: report['impressions'],
                      clicks: report['clicks'], ctr: report['ctr'], conversions: report['conversions'],
                      ecpm: calculate_vals(report, 'eCPM'), ecpc: calculate_vals(report, 'eCPC'),
                      ecpa: calculate_vals(report, 'eCPA'))
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

  def apply_defaults_for(table)
    table.each { |key, val| table[key] = 0 if val.nil? }
    table
  end

  def campaign_id_is_allowed
    report = Auth.new.get_camaign_report['results'].select {|r| r['campaign_id'] == campaign_id}.first
    if report.nil?
      self.errors.add(:base, 'Error')
    end
  end
end
