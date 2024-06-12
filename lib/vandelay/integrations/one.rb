module Vandelay
    module Integrations
            class One < Vandelay::Integrations::Base

                def vendor_name
                    "one"
                end

                def patient_record_url(patient_id)
                    "#{api_base_url}/patients/#{patient_id}"
                end

                def auth_token_url
                    "#{api_base_url}/auth/1"
                end

                def get_patient_record(vendor_id)
                    data = super
                    {
                      province: data['province'],
                      allergies: data['allergies'],
                      num_medical_visits: data['recent_medical_visits']
                    }
                end

            end
    end
end