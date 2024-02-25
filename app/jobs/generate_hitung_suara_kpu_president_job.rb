# For generate job kpu president result
class GenerateHitungSuaraKpuPresidentJob < ApplicationJob
  queue_as :default
  def perform
    sidekiq_queue = Sidekiq::Queue.new('farming_kpu_president_pooling_station_result_job')

    # Check if the job is already in queue
    return if sidekiq_queue.size.positive?

    # Generate job under provinsi
    # Farmer::Kpu::GenerateJobUnderProvinsi.run(provinsi_id: 1, result_source_id: 1)
    # result source id 1 is KPU_HITUNG_SUARA
    Provinsi.all.each do |provinsi|
      Farmer::KpuPresident::GenerateJobUnderProvinsi.run(provinsi_id: provinsi.id, result_source_id: 1)
    end
  end
end
