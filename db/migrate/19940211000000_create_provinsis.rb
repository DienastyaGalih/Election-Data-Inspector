class CreateProvinsis < ActiveRecord::Migration[7.0]
  def change
    create_table :provinsis do |t|
      t.string :kpu_nama
      t.integer :kpu_id
      t.string :kpu_kode
      t.integer :kpu_tingkat

      t.timestamps
    end
  end
end
