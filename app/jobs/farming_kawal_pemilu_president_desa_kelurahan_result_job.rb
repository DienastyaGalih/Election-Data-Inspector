class FarmingKawalPemiluPresidentDesaKelurahanResultJob < ApplicationJob
  queue_as :farming_kawal_pemilu_president_desa_kelurahan_result_job

  def perform(params)
    Farmer::KawalPemiluOrgPresident::DesaKelurahanResult.run(
      kpu_kelurahan_desa_kode: params[:kpu_kelurahan_desa_kode],
      result_source_id: params[:result_source_id]
    )
  end
end

# FarmingKawalPemiluPresidentDesaKelurahanResultJob.perform_later(kpu_kelurahan_desa_kode: '1904011001', result_source_id: 4)