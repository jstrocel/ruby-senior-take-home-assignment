require 'rest-client'

module Vandelay
    module Integrations
        class Base
            def api_base_url
                'http://' + Vandelay.config.dig('integrations', 'vendors', vendor_name, 'api_base_url')
            end
            

            def get_patient_record(vendor_id)
                uri = URI.parse(patient_record_url(vendor_id))
                headers = {}
                headers.merge({'Authorization' => "Bearer #{get_auth_token}"})
                request = RestClient.get(patient_record_url(vendor_id), headers)
                JSON.parse(request.body)
            end

            private

            def get_auth_token
                request = RestClient.get(auth_token_url)
                JSON.parse(request.body)
            end
        end
    end
end