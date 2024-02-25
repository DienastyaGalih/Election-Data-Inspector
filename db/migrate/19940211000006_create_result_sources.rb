class CreateResultSources < ActiveRecord::Migration[7.0]
  def change
    create_table :result_sources do |t|
      t.string :name

      t.timestamps
    end
  end
end
