class CreateLog < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
  end
end
