class KabupatenKota < ApplicationRecord
  belongs_to :provinsi
  has_many :kecamatans
end
