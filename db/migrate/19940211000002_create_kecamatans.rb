class CreateKecamatans < ActiveRecord::Migration[7.0]
  def change
    create_table :kecamatans do |t|
      t.string :kpu_nama
      t.integer :kpu_id
      t.string :kpu_kode
      t.integer :kpu_tingkat
      t.references :kabupaten_kota, null: false, foreign_key: true

      t.timestamps
    end
  end
end
