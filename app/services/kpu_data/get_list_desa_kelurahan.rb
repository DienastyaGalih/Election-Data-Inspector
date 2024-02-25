module KpuData
  class GetListDesaKelurahan < ActiveInteraction::Base
    string :provinsi_kode
    string :kabupaten_kota_kode
    string :kecamatan_kode

    def execute
      response = Network::MyClient
                 .new('https://sirekap-obj-data.kpu.go.id')
                 .get_with_retry("/wilayah/pemilu/ppwp/#{provinsi_kode}/#{kabupaten_kota_kode}/#{kecamatan_kode}.json")
      response.parsed_response
    end
  end
end
