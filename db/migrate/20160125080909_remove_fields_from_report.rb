class RemoveFieldsFromReport < ActiveRecord::Migration
  def up
    remove_columns :reports, :campaign_name, :start_date, :end_date,
                             :media_budget, :media_spent, :impressions,
                             :clicks, :ctr, :conversions, :ecpm, :ecpc,
                             :ecpa
  end

  def down
    add_column :reports, :campaign_name, :string
    add_column :reports, :start_date, :date
    add_column :reports, :end_date, :date
    add_column :reports, :media_budget, :float, default: 0, null: false
    add_column :reports, :media_spent, :float, default: 0, null: false
    add_column :reports, :impressions, :integer, default: 0, null: false
    add_column :reports, :clicks, :initeger, default: 0, null: false
    add_column :reports, :ctr, :float, default: 0, null: false
    add_column :reports, :conversions, :integer, default: 0, null: false
    add_column :reports, :ecpm, :float, default: 0, null: false
    add_column :reports, :ecpc, :float, default: 0, null: false
    add_column :reports, :ecpa, :float, default: 0, null: false
  end
end
