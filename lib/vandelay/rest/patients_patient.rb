require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients/patient/:patient_id' do
          patient_id = Integer(params[:patient_id] , exception: false)
          halt 400 if patient_id.nil?
          result = Vandelay::REST::Patients.patients_srvc.retrieve_one(patient_id)
          halt 404 unless result
          json(result.to_h)
        end
      end
    end
  end
end
