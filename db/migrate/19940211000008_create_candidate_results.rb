class CreateCandidateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :candidate_results do |t|
      t.integer :total
      t.references :candidate, null: false, foreign_key: true
      t.references :result, null: false, foreign_key: true

      t.timestamps
    end
  end
end
