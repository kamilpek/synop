require 'test_helper'

class MetarStationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metar_station = metar_stations(:one)
  end

  test "should get index" do
    get metar_stations_url
    assert_response :success
  end

  test "should get new" do
    get new_metar_station_url
    assert_response :success
  end

  test "should create metar_station" do
    assert_difference('MetarStation.count') do
      post metar_stations_url, params: { metar_station: { elevation: @metar_station.elevation, latitude: @metar_station.latitude, longitude: @metar_station.longitude, name: @metar_station.name, number: @metar_station.number, status: @metar_station.status } }
    end

    assert_redirected_to metar_station_url(MetarStation.last)
  end

  test "should show metar_station" do
    get metar_station_url(@metar_station)
    assert_response :success
  end

  test "should get edit" do
    get edit_metar_station_url(@metar_station)
    assert_response :success
  end

  test "should update metar_station" do
    patch metar_station_url(@metar_station), params: { metar_station: { elevation: @metar_station.elevation, latitude: @metar_station.latitude, longitude: @metar_station.longitude, name: @metar_station.name, number: @metar_station.number, status: @metar_station.status } }
    assert_redirected_to metar_station_url(@metar_station)
  end

  test "should destroy metar_station" do
    assert_difference('MetarStation.count', -1) do
      delete metar_station_url(@metar_station)
    end

    assert_redirected_to metar_stations_url
  end
end
