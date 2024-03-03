module Farmer
  module KawalPemiluOrgPresident
    class DesaKelurahanResult < ActiveInteraction::Base
      string :kpu_kelurahan_desa_kode

      # source type in database KAWAL_PEMILU_ORG
      integer :result_source_id

      def execute
        response = HTTParty.get("https://kp24-fd486.et.r.appspot.com/h?id=#{kpu_kelurahan_desa_kode}")
        result_json = response.parsed_response
        pooling_stations = PoolingStation.joins(:desa_kelurahan).where(desa_kelurahan: { kpu_kode: kpu_kelurahan_desa_kode })

        # agregated is list result in pooling station.
        # looping over pooling station
        # name is pooling station name just number 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 etc
        result_json['result']['aggregated'].each do |key, pooling_station_results|
          # assume index 0 is global status result and all important conclution
          # information store in this for kawalpemilu.org website
          current_result_json = pooling_station_results[0]
          total_jaga_tps = current_result_json['totalJagaTps']
          total_completed_tps = current_result_json['totalCompletedTps']
          if total_jaga_tps.present? && total_completed_tps.present?
            # assume total jaga tps is 1 mean it mean status Terjaga in kawalpemilu.org website display
            # and total completed tps is 1 mean it mean this tps is completed
            if total_jaga_tps == 1 && total_completed_tps == 1
              pas_1 = current_result_json['pas1']
              pas_2 = current_result_json['pas2']
              pas_3 = current_result_json['pas3']

              pooling_station_db = get_pooling_station_by_kpu_kode(
                "#{kpu_kelurahan_desa_kode}#{key.to_s.rjust(3, '0')}", pooling_stations
              )

              last_result_json = Result.where(
                pooling_station_id: pooling_station_db.id,
                result_source_id:
              ).order(id: :desc)&.first&.data

              last_result_json = {} if last_result_json.nil?

              # full compare json
              differences = Hashdiff.best_diff(
                Farmer::Utill::FlattenHash.run!(hash_data: last_result_json),
                Farmer::Utill::FlattenHash.run!(hash_data: current_result_json)
              )
              next if differences.empty?

              ActiveRecord::Base.connection_pool.with_connection do
                ActiveRecord::Base.transaction do
                  result = Result.create!(
                    pooling_station_id: pooling_station_db.id,
                    result_source_id:,
                    data: current_result_json
                  )

                  # formating diff
                  # result like this ["totalJagaTps", 1, null]
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
                        total_vote: pas_1
                      },
                      {
                        result:,
                        candidate: Candidate.get_by_kpu_kode('100026'),
                        total_vote: pas_2
                      },
                      {
                        result:,
                        candidate: Candidate.get_by_kpu_kode('100027'),
                        total_vote: pas_3
                      }
                    ]
                  )
                end
              end
            else
              # log something wrong assume
              Log.create!(
                key: "anomaly_error_kpu_kelurahan_desa_kode_#{kpu_kelurahan_desa_kode}_pooling_station_#{key}",
                value: "total_jaga_tps: #{total_jaga_tps}, total_completed_tps: #{total_completed_tps}"
              )
            end
          end
        end
      end

      def get_pooling_station_by_kpu_kode(kpu_kode, pooling_stations)
        pooling_stations.find { |pooling_station| pooling_station.kpu_kode == kpu_kode }
      end
    end
  end
end
# Colling under rails console
# https://kp24-fd486.et.r.appspot.com/h?id=1904011001
# Farmer::KawalPemiluOrgPresident::DesaKelurahanResult.run!(kpu_kelurahan_desa_kode: '1904011001', result_source_id: 4)
# Stored data in database like this:
# {
#     "pendingUploads": {},
#     "totalKpuTps": 1,
#     "totalLaporTps": 0,
#     "idLokasi": "190401100117",
#     "pas2": 114,
#     "totalTps": 1,
#     "pas3": 57,
#     "totalCompletedTps": 1,
#     "dpt": 250,
#     "totalJagaTps": 1,
#     "totalPendingTps": 0,
#     "totalSamBotErrorTps": 0,
#     "uid": "kpu_uid",
#     "ouid": "kpu_uid",
#     "name": "17",
#     "totalErrorTps": 0,
#     "pas1": 43,
#     "updateTs": 1708168297292
# }
