class CreateResultTracker < ActiveRecord::Migration[7.0]
  def change
    create_table :result_trackers do |t|
      t.references :result, foreign_key: true
      t.string :key
      t.text :value
      t.text :old_value
      t.string :status

      t.timestamps
    end
  end
end
