class RenameTotalToTotalVoteInCandidateResult < ActiveRecord::Migration[7.0]
  def change
    rename_column :candidate_results, :total, :total_vote
  end
end
