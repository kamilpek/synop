require 'test_helper'

class MeasurementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @measurement = measurements(:one)
  end

  test "should get index" do
    get measurements_url
    assert_response :success
  end

  test "should get new" do
    get new_measurement_url
    assert_response :success
  end

  test "should create measurement" do
    assert_difference('Measurement.count') do
      post measurements_url, params: { measurement: { date: @measurement.date, et: @measurement.et, hour: @measurement.hour, humidity: @measurement.humidity, preasure: @measurement.preasure, rainfall: @measurement.rainfall, temperature: @measurement.temperature, wind_direct: @measurement.wind_direct, wind_speed: @measurement.wind_speed } }
    end

    assert_redirected_to measurement_url(Measurement.last)
  end

  test "should show measurement" do
    get measurement_url(@measurement)
    assert_response :success
  end

  test "should get edit" do
    get edit_measurement_url(@measurement)
    assert_response :success
  end

  test "should update measurement" do
    patch measurement_url(@measurement), params: { measurement: { date: @measurement.date, et: @measurement.et, hour: @measurement.hour, humidity: @measurement.humidity, preasure: @measurement.preasure, rainfall: @measurement.rainfall, temperature: @measurement.temperature, wind_direct: @measurement.wind_direct, wind_speed: @measurement.wind_speed } }
    assert_redirected_to measurement_url(@measurement)
  end

  test "should destroy measurement" do
    assert_difference('Measurement.count', -1) do
      delete measurement_url(@measurement)
    end

    assert_redirected_to measurements_url
  end
end
