module KpuData
  class GetListKabupatenKota < ActiveInteraction::Base
    string :provinsi_kode
    def execute
      response = Network::MyClient
                 .new('https://sirekap-obj-data.kpu.go.id')
                 .get_with_retry("/wilayah/pemilu/ppwp/#{provinsi_kode}.json")
      response.parsed_response
    end
  end
end
