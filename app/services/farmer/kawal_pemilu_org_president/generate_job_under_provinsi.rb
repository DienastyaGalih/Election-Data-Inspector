module Farmer
  module KawalPemiluOrgPresident
    class GenerateJobUnderProvinsi < ActiveInteraction::Base
      integer :provinsi_id
      integer :result_source_id
      def execute
        provinsi = Provinsi.find(provinsi_id)
        kabupaten_kota_list = provinsi.kabupaten_kotas
        kabupaten_kota_list.each do |kabupaten_kota|
          kecamatan_list = kabupaten_kota.kecamatans
          kecamatan_list.each do |kecamatan|
            desa_kelurahan_list = kecamatan.desa_kelurahans
            desa_kelurahan_list.each do |desa_kelurahan|
              FarmingKawalPemiluPresidentDesaKelurahanResultJob.perform_later(
                {
                  kpu_kelurahan_desa_kode: desa_kelurahan.kpu_kode,
                  result_source_id:
                }
              )
            end
          end
        end
      end
    end
  end
end
# Farmer::KawalPemiluOrgPresident::GenerateJobUnderProvinsi.run(provinsi_id: 1,  result_source_id: 4)
