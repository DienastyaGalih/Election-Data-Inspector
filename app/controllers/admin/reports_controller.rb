module Admin
  class ReportsController < Admin::ApplicationController
    def api_total_votes
      query = "
        SELECT
            candidate_results.candidate_id as candidate_id,
            candidates.name as candidate_name,
            result_sources.id as result_source_id,
            result_sources.name as result_source_name,
            SUM(candidate_results.total_vote) as total_votes
        FROM
            candidate_results
        INNER JOIN
            candidates ON candidate_results.candidate_id = candidates.id
        INNER JOIN
            results ON candidate_results.result_id = results.id
        INNER JOIN
            result_sources ON results.result_source_id = result_sources.id
        INNER JOIN
            pooling_stations ON results.pooling_station_id = pooling_stations.id
        INNER JOIN
            desa_kelurahans ON pooling_stations.desa_kelurahan_id = desa_kelurahans.id
        INNER JOIN
            kecamatans ON desa_kelurahans.kecamatan_id = kecamatans.id
        INNER JOIN
            kabupaten_kotas ON kecamatans.kabupaten_kota_id = kabupaten_kotas.id
        INNER JOIN
            provinsis ON kabupaten_kotas.provinsi_id = provinsis.id
        INNER JOIN
            (
                SELECT
                    pooling_station_id,
                    MAX(created_at) as latest_date
                FROM
                    results
                GROUP BY
                    pooling_station_id
            ) AS latest_results ON latest_results.pooling_station_id = results.pooling_station_id
                                AND latest_results.latest_date = results.created_at
        WHERE
            (:result_source_id is null or result_sources.id = :result_source_id) AND
            (:provinsi_id is null or provinsis.id = :provinsi_id) AND
            (:kabupaten_kota_id is null or kabupaten_kotas.id = :kabupaten_kota_id) AND
            (:kecamatan_id is null or kecamatans.id = :kecamatan_id) AND
            (:desa_kelurahan_id is null or desa_kelurahans.id = :desa_kelurahan_id) AND
            (:pooling_station_id is null or pooling_stations.id = :pooling_station_id) AND
            (:created_at is null or DATE(results.created_at) <= :created_at)
        GROUP BY
            candidate_results.candidate_id,
            candidates.name,
            result_sources.id,
            result_sources.name;
      "
      result_source_id = params[:result_source_id].presence
      provinsi_id = params[:provinsi_id].presence
      kabupaten_kota_id = params[:kabupaten_kota_id].presence
      kecamatan_id = params[:kecamatan_id].presence
      desa_kelurahan_id = params[:desa_kelurahan_id].presence
      pooling_station_id = params[:pooling_station_id].presence
      created_at = params[:created_at].presence

      result = ActiveRecord::Base.connection.execute(
        ActiveRecord::Base.send(
          :sanitize_sql_array,
          [
            query,
            {
              result_source_id:,
              provinsi_id:,
              kabupaten_kota_id:,
              kecamatan_id:,
              desa_kelurahan_id:,
              pooling_station_id:,
              created_at:
            }
          ]
        )
      )

      render json: result.map { |val|
                     { candidate_id: val[0],
                       candidate_name: val[1],
                       result_source_id: val[2],
                       result_source_name: val[3],
                       total_votes: val[4] }
                   }
    end

    def summary; end
  end
end
