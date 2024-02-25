module InitData
  class InitTingkatKpu < ActiveInteraction::Base
    def execute
      provinsi_list = KpuData::GetListProvinsi.run!

      total_thread = 19
      puts("Total Thread: #{total_thread}")
      sliced_array = provinsi_list.each_slice((provinsi_list.size / total_thread).ceil).to_a
      threads = []

      sliced_array.each do |slice|
        threads << Thread.new do
          slice.each do |provinsi|
            sync_kpu_provinsi(provinsi)
          end
        end
      end

      #   Wait for each thread to finish execution
      threads.each(&:join)
      puts('All threads have finished execution')
    end

    def sync_kpu_provinsi(provinsi)
      ActiveRecord::Base.connection_pool.with_connection do
        ActiveRecord::Base.transaction do
          provinsi_db = Provinsi.create!(
            kpu_nama: provinsi['nama'],
            kpu_kode: provinsi['kode'],
            kpu_tingkat: provinsi['tingkat'],
            kpu_id: provinsi['id']
          )
          kabupaten_kota_list = KpuData::GetListKabupatenKota.run!(
            provinsi_kode: provinsi['kode']
          )
          kabupaten_kota_list.each do |kabupaten|
            kabupaten_kota_db = KabupatenKota.create!(
              kpu_nama: kabupaten['nama'],
              kpu_kode: kabupaten['kode'],
              kpu_tingkat: kabupaten['tingkat'],
              kpu_id: kabupaten['id'],
              provinsi: provinsi_db
            )
            kecamatan_list = KpuData::GetListKecamatan.run!(
              kabupaten_kota_kode: kabupaten['kode'],
              provinsi_kode: provinsi['kode']
            )
            kecamatan_list.each do |kecamatan|
              kecamatan_db = Kecamatan.create!(
                kpu_nama: kecamatan['nama'],
                kpu_kode: kecamatan['kode'],
                kpu_tingkat: kecamatan['tingkat'],
                kpu_id: kecamatan['id'],
                kabupaten_kota: kabupaten_kota_db
              )
              desa_kelurahan_list = KpuData::GetListDesaKelurahan.run!(
                kecamatan_kode: kecamatan['kode'],
                kabupaten_kota_kode: kabupaten['kode'],
                provinsi_kode: provinsi['kode']
              )
              desa_kelurahan_list.each do |desa|
                desa_kelurahan_db = DesaKelurahan.create!(
                  kpu_nama: desa['nama'],
                  kpu_kode: desa['kode'],
                  kpu_tingkat: desa['tingkat'],
                  kpu_id: desa['id'],
                  kecamatan: kecamatan_db
                )
                pooling_station_list = KpuData::GetListPoolingStation.run!(
                  kelurahan_desa_kode: desa['kode'],
                  kecamatan_kode: kecamatan['kode'],
                  kabupaten_kota_kode: kabupaten['kode'],
                  provinsi_kode: provinsi['kode']
                )
                pooling_station_list.each do |pooling_station|
                  PoolingStation.create!(
                    kpu_nama: pooling_station['nama'],
                    kpu_kode: pooling_station['kode'],
                    kpu_tingkat: pooling_station['tingkat'],
                    kpu_id: pooling_station['id'],
                    desa_kelurahan: desa_kelurahan_db
                  )
                  print(provinsi_db.id)
                end
              end
            end
          end
        end
      end
    end
  end
end
