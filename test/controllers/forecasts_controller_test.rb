require 'test_helper'

class ForecastsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forecast = forecasts(:one)
  end

  test "should get index" do
    get forecasts_url
    assert_response :success
  end

  test "should get new" do
    get new_forecast_url
    assert_response :success
  end

  test "should create forecast" do
    assert_difference('Forecast.count') do
      post forecasts_url, params: { forecast: { current: @forecast.current, next: @forecast.next, preasures: @forecast.preasures, precipitations: @forecast.precipitations, situations: @forecast.situations, station_number: @forecast.station_number, temperatures: @forecast.temperatures, times_from: @forecast.times_from, times_to: @forecast.times_to, wind_directs: @forecast.wind_directs, wind_speeds: @forecast.wind_speeds } }
    end

    assert_redirected_to forecast_url(Forecast.last)
  end

  test "should show forecast" do
    get forecast_url(@forecast)
    assert_response :success
  end

  test "should get edit" do
    get edit_forecast_url(@forecast)
    assert_response :success
  end

  test "should update forecast" do
    patch forecast_url(@forecast), params: { forecast: { current: @forecast.current, next: @forecast.next, preasures: @forecast.preasures, precipitations: @forecast.precipitations, situations: @forecast.situations, station_number: @forecast.station_number, temperatures: @forecast.temperatures, times_from: @forecast.times_from, times_to: @forecast.times_to, wind_directs: @forecast.wind_directs, wind_speeds: @forecast.wind_speeds } }
    assert_redirected_to forecast_url(@forecast)
  end

  test "should destroy forecast" do
    assert_difference('Forecast.count', -1) do
      delete forecast_url(@forecast)
    end

    assert_redirected_to forecasts_url
  end
end
