require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatientRecord
        def self.patients_srvc
            @patients_srvc ||= Vandelay::Services::Patients.new
        end
        def self.patients_record_srvc
            @patient_record_srvc ||= Vandelay::Services::PatientRecords.new
        end

        def self.registered(app)
            app.get '/patients/:patient_id/record' do
                patient_id = Integer(params[:patient_id] , exception: false)
                halt 400 if patient_id.nil?
                patient = Vandelay::REST::Patients.patients_srvc.retrieve_one(patient_id)
                vendor_patient_record = Vandelay::REST::PatientsPatientRecord.patients_record_srvc.retrieve_record_for_patient(patient.id, patient.records_vendor, patient.vendor_id)
                halt 404 unless vendor_patient_record
                result = {:patient_id => patient_id}
                result.merge!(vendor_patient_record)
                json(result)
            end
        end
    end
  end
end