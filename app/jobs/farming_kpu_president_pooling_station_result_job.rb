class FarmingKpuPresidentPoolingStationResultJob < ApplicationJob
  queue_as :farming_kpu_president_pooling_station_result_job

  def perform(params)
    Farmer::KpuPresident::PoolingStationResult.run(
      kpu_provinsi_kode: params[:kpu_provinsi_kode],
      kpu_kabupaten_kota_kode: params[:kpu_kabupaten_kota_kode],
      kpu_kecamatan_kode: params[:kpu_kecamatan_kode],
      kpu_kelurahan_desa_kode: params[:kpu_kelurahan_desa_kode],
      kpu_pooling_station_kode: params[:kpu_pooling_station_kode],
      pooling_station_id: params[:pooling_station_id],
      result_source_id: params[:result_source_id]
    )
  end
end
