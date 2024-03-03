# For generate job kawal pemilu president result
class GenerateKawalPemiluPresidentJob < ApplicationJob
  queue_as :default
  def perform
    sidekiq_queue = Sidekiq::Queue.new('farming_kawal_pemilu_president_desa_kelurahan_result_job')

    # Check if the job is already in queue
    return if sidekiq_queue.size.positive?

    # Generate job under provinsi
    # result source id 4 is KAWAL_PEMILU
    Provinsi.all.each do |provinsi|
      Farmer::KawalPemiluOrgPresident::GenerateJobUnderProvinsi.run(
        provinsi_id: provinsi.id,
        result_source_id: 4
      )
    end
  end
end
