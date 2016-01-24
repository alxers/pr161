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
      begin
        # report = PlatformApi.new.get_campaign_report['results'].select {|r| r['campaign_id'] == campaign_id}.first
        report = PlatformApi.new.get_campaign_report(campaign_id)
          raise(::PlatformApiError, 'wrong id') unless report
      rescue ::PlatformApiError => e
        errors.add(:"Platform API error", e.to_s)
      end
    end
end
