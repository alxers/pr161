class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :campaign_name
      t.date :start_date
      t.date :end_date
      t.float :media_budget, default: 0, null: false
      t.float :media_spent, default: 0, null: false
      t.integer :impressions, default: 0, null: false
      t.integer :clicks, default: 0, null: false
      t.float :ctr, default: 0, null: false
      t.integer :conversions, default: 0, null: false
      t.integer :campaign_id
      t.string :comment
      t.float :ecpm, default: 0, null: false
      t.float :ecpc, default: 0, null: false
      t.float :ecpa, default: 0, null: false

      t.timestamps null: false
    end
  end
end
