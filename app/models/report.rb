class Report < ActiveRecord::Base
  has_one :campaign
  has_many :creatives
  has_many :charts

  after_create :create_relations

  validates :comment, length: { maximum: 160 }
  validate :campaign_id_is_allowed

  private

    def add_campaign
      Campaign.create_report(self)
    end

    def add_creatives
      Creative.create_report(self)
    end

    def add_charts
      Chart.create_report(self)
    end

    def create_relations
      add_campaign
      add_creatives
      add_charts
    end

    def campaign_id_is_allowed
      report = PlatformApi.new.get_camaign_report['results'].select {|r| r['campaign_id'] == campaign_id}.first
      if report.nil?
        self.errors.add(:base, 'Error')
      end
    end
end
