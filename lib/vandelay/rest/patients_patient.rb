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
          patient_id = params[:patient_id].to_i
          result = Vandelay::REST::Patients.patients_srvc.retrieve_one(patient_id)
          if result
            json(result.to_h)
          else
            status 404
          end
        end
      end
    end
  end
end
