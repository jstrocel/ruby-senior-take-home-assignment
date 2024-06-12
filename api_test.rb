ENV['APP_ENV'] = 'test'

require_relative './server'
require 'test/unit'
require 'rack/test'
require 'json'
require 'rest-client'

class VandelayTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    @app = RESTServer
  end

  def test_it_returns_service_name
    data = '{"service_name":"Vandelay Industries"}'
    get '/', "CONTENT_TYPE" => "application/json"
    assert last_response.ok?
    assert_equal JSON.parse(data.to_json), last_response.body
  end

  def test_it_returns_all_patients
    data = Vandelay::REST::Patients.patients_srvc.retrieve_all
    get '/patients', "CONTENT_TYPE" => "application/json"
    assert last_response.ok?
    assert_equal data.to_json, last_response.body
  end

  def test_it_returns_existing_patient
    patient_id = 1
    data = Vandelay::Models::Patient.with_id(patient_id)
    get "/patients/patient/#{patient_id}", "CONTENT_TYPE" => "application/json"
    assert last_response.ok?
    assert_equal data.to_h.to_json, last_response.body
  end

  def test_single_patient_returns_404
    get "/patients/patient/500", "CONTENT_TYPE" => "application/json"
    assert_equal 404, last_response.status
  end

  def test_single_patient_returns_400
    get "/patients/patient/friday", "CONTENT_TYPE" => "application/json"
    assert_equal 400, last_response.status
  end

  def test_vendor_one_existing_patient
    get "/patients/2/record", "CONTENT_TYPE" => "application/json"
    assert last_response.ok?
    result = JSON.parse(last_response.body)

    assert result.keys.include?('patient_id')
    assert result.keys.include?('province')
    assert result.keys.include?('allergies')
    assert result.keys.include?('num_medical_visits')
    assert_equal 2, result["patient_id"]
    assert_equal "QC", result["province"]
    assert_equal ["work", "conformity", "paying taxes"], result["allergies"] 
    assert_equal 1, result["num_medical_visits"]
  end

  def test_vendor_two_existing_patient
    get "/patients/3/record", "CONTENT_TYPE" => "application/json"
    assert last_response.ok?

    result = JSON.parse(last_response.body)
    assert result.keys.include?('patient_id')
    assert result.keys.include?('province')
    assert result.keys.include?('allergies')
    assert result.keys.include?('num_medical_visits')
    assert_equal 3, result["patient_id"]
    assert_equal "ON", result["province"]
    assert_equal ["hair", "mean people", "paying the bill"], result["allergies"] 
    assert_equal 17, result["num_medical_visits"]
  end

  def test_patient_record_null_vendor
    get "/patients/1/record", "CONTENT_TYPE" => "application/json"
    assert_equal last_response.status, 404
  end

  def test_patient_record_bad_id
    get "/patients/friday/record", "CONTENT_TYPE" => "application/json"
    assert_equal last_response.status, 400
  end
end