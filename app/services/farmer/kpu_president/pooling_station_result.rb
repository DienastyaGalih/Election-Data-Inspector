module Farmer
  module KpuPresident
    class PoolingStationResult < ActiveInteraction::Base
      string :kpu_provinsi_kode
      string :kpu_kabupaten_kota_kode
      string :kpu_kecamatan_kode
      string :kpu_kelurahan_desa_kode
      string :kpu_pooling_station_kode

      integer :pooling_station_id
      # source type in database KPU_HITUNG_SUARA KPU_REKAPITULASI_HASIL_PEMILU]
      integer :result_source_id

      def execute
        response = HTTParty.get("https://sirekap-obj-data.kpu.go.id/pemilu/hhcw/ppwp/#{kpu_provinsi_kode}/#{kpu_kabupaten_kota_kode}/#{kpu_kecamatan_kode}/#{kpu_kelurahan_desa_kode}/#{kpu_pooling_station_kode}.json")
        current_result_json = response.parsed_response

        last_result_json = Result.where(
          pooling_station_id:,
          result_source_id:
        ).order(id: :desc)&.first&.data

        last_result_json = {} if last_result_json.nil?

        # some time diff if child value changed as hash (json object)
        # we need to flatten it for easy to analyze in database
        differences = Hashdiff.best_diff(
          Farmer::Utill::FlattenHash.run!(hash_data: last_result_json),
          Farmer::Utill::FlattenHash.run!(hash_data: current_result_json)
        )

        # do nothing if no differences
        return if differences.empty?

        ActiveRecord::Base.connection_pool.with_connection do
          ActiveRecord::Base.transaction do
            result = Result.create!(
              result_source_id:,
              pooling_station_id:,
              data: current_result_json
            )

            # formating diff
            # result like this ["chart.100025", 10200, 102]
            # we can analyze it in database as string key, old_value, new_value
            differences.each do |diff|
              case diff[0]
              when '~'
                ResultTracker.create!(
                  result:,
                  key: diff[1],
                  value: diff[3],
                  old_value: diff[2],
                  status: 'modified'
                )
              when '+'
                ResultTracker.create!(
                  result:,
                  key: diff[1],
                  value: diff[2],
                  old_value: nil,
                  status: 'added'
                )
              when '-'
                ResultTracker.create!(
                  result:,
                  key: diff[1],
                  value: nil,
                  old_value: diff[2],
                  status: 'removed'
                )
              end
            end

            CandidateResult.create!(
              [
                {
                  result:,
                  candidate: Candidate.get_by_kpu_kode('100025'),
                  total_vote: current_result_json.dig('chart', '100025')
                },
                {
                  result:,
                  candidate: Candidate.get_by_kpu_kode('100026'),
                  total_vote: current_result_json.dig('chart', '100026')
                },
                {
                  result:,
                  candidate: Candidate.get_by_kpu_kode('100027'),
                  total_vote: current_result_json.dig('chart', '100027')
                }
              ]
            )
          end
        end
      end
    end
  end
end
# https://sirekap-obj-data.kpu.go.id/pemilu/hhcw/ppwp/31/3175/317503/3175031005/3175031005003.json
# # Farmer::Kpu::PoolingStationResult.run( kpu_provinsi_kode: '31', kpu_kabupaten_kota_kode: '3175', kpu_kecamatan_kode: '317503', kpu_kelurahan_desa_kode: '3175031005', kpu_pooling_station_kode: '3175031005003', pooling_station_id: 1, result_source_id: 1 )
