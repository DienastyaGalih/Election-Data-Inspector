class AddIndexToCandidateResults < ActiveRecord::Migration[7.0]
  def change
    add_index :candidate_results, %i[candidate_id result_id], unique: true
  end
end
