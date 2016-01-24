class RenameAdvertDataToAdvertiser < ActiveRecord::Migration
  def change
    rename_table :advert_data, :advertisers
  end
end
