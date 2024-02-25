module KpuData
  class GetListProvinsi < ActiveInteraction::Base
    def execute
      response = Network::MyClient
                 .new('https://sirekap-obj-data.kpu.go.id')
                 .get_with_retry('/wilayah/pemilu/ppwp/0.json')
      response.parsed_response
    end
  end
end
