class CreatePoolingStations < ActiveRecord::Migration[7.0]
  def change
    create_table :pooling_stations do |t|
      t.string :kpu_nama
      t.integer :kpu_id
      t.string :kpu_kode
      t.integer :kpu_tingkat
      t.references :desa_kelurahan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
