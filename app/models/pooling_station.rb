class PoolingStation < ApplicationRecord
  belongs_to :desa_kelurahan
  has_many :results
end
