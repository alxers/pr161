class Report < ActiveRecord::Base
  has_one :campaign
  has_many :creatives
  has_many :charts

  after_create :add_campaign
  after_create :add_creatives
  after_create :add_charts

  validates :comment, length: { maximum: 160 }
  validate :campaign_id_is_allowed


  def add_campaign
    Campaign.create_report(self)
  end

  def add_creatives
    Creative.create_report(self)
  end

  def add_charts
    Chart.create_report(self)
  end

  def campaign_id_is_allowed
    report = Auth.new.get_camaign_report['results'].select {|r| r['campaign_id'] == campaign_id}.first
    if report.nil?
      self.errors.add(:base, 'Error')
    end
  end
end
