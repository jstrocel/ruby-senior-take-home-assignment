require 'vandelay/integrations/base'
require 'vandelay/integrations/one'
require 'vandelay/integrations/two'
require 'vandelay/models/patient'
require 'redis'

module Vandelay
  module Services
    class PatientRecords
      def retrieve_record_for_patient(patient_id, records_vendor, vendor_id)
        cache = Vandelay::Util::Cache.new
        cached_record = cache.get("#{patient_id}")

        return cached_record if cached_record

        if records_vendor == "one"
          vendor_class = Vandelay::Integrations::One.new
        elsif records_vendor == "two"
          vendor_class = Vandelay::Integrations::Two.new
        else
          return
        end
        
        vendor_record = vendor_class.get_patient_record(vendor_id)
        cache.set("#{patient_id}", vendor_record) if vendor_record
        vendor_record
      end
    end
  end
end