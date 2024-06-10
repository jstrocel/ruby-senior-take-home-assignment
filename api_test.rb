ENV['APP_ENV'] = 'test'

require_relative './server'
require 'test/unit'
require 'rack/test'
require 'json'

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
    get "/patients/#{patient_id}", "CONTENT_TYPE" => "application/json"
    assert last_response.ok?
    assert_equal data.to_h.to_json, last_response.body
  end
end