class DesaKelurahan < ApplicationRecord
  belongs_to :kecamatan
  has_many :pooling_stations
end
