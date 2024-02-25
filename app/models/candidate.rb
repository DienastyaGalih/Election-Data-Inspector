class Candidate < ApplicationRecord
  def self.get_by_kpu_kode(kpu_kode)
    Rails.cache.fetch("candidate_#{kpu_kode}", expires_in: 12.hours) do
      Candidate.find_by(kpu_kode:)
    end
  end
end
