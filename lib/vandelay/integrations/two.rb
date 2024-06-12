module Vandelay
    module Integrations
            class Two < Vandelay::Integrations::Base

                def vendor_name
                    "two"
                end

                def patient_record_url(patient_id)
                    "#{api_base_url}/records/#{patient_id}"
                end

                def auth_token_url
                    "#{api_base_url}/auth_tokens/1"
                end

                def get_patient_record(vendor_id)
                    data = super
                    {
                      province: data['province_code'],
                      allergies: data['allergies_list'],
                      num_medical_visits: data['medical_visits_recently']
                    }
                end
            end
    end
end