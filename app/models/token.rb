class Token < ActiveRecord::Base

  def self.get_active
    Token.where(active: true).first.try(:token)
  end
end
