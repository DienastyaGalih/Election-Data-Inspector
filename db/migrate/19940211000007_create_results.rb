class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.json :data
      t.json :backup_images_with_hash
      t.string :screenshoot_url
      t.references :pooling_station, null: false, foreign_key: true
      t.references :result_source, null: false, foreign_key: true

      t.timestamps
    end
  end
end
