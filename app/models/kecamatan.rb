class Kecamatan < ApplicationRecord
  belongs_to :kabupaten_kota
  has_many :desa_kelurahans
end
