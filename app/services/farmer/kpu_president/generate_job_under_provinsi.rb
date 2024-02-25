module Farmer
  module KpuPresident
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
              pooling_station_list = desa_kelurahan.pooling_stations
              pooling_station_list.each do |pooling_station|
                FarmingKpuPresidentPoolingStationResultJob.perform_later(
                  {
                    kpu_provinsi_kode: provinsi.kpu_kode,
                    kpu_kabupaten_kota_kode: kabupaten_kota.kpu_kode,
                    kpu_kecamatan_kode: kecamatan.kpu_kode,
                    kpu_kelurahan_desa_kode: desa_kelurahan.kpu_kode,
                    kpu_pooling_station_kode: pooling_station.kpu_kode,
                    pooling_station_id: pooling_station.id,
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
end
# Farmer::KpuPresident::GenerateJobUnderProvinsi.run(provinsi_id: 1,  result_source_id: 1)
