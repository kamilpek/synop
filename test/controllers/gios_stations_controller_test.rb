require 'test_helper'

class GiosStationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gios_station = gios_stations(:one)
  end

  test "should get index" do
    get gios_stations_url
    assert_response :success
  end

  test "should get new" do
    get new_gios_station_url
    assert_response :success
  end

  test "should create gios_station" do
    assert_difference('GiosStation.count') do
      post gios_stations_url, params: { gios_station: { address: @gios_station.address, city: @gios_station.city, latitude: @gios_station.latitude, longitude: @gios_station.longitude, name: @gios_station.name, number: @gios_station.number } }
    end

    assert_redirected_to gios_station_url(GiosStation.last)
  end

  test "should show gios_station" do
    get gios_station_url(@gios_station)
    assert_response :success
  end

  test "should get edit" do
    get edit_gios_station_url(@gios_station)
    assert_response :success
  end

  test "should update gios_station" do
    patch gios_station_url(@gios_station), params: { gios_station: { address: @gios_station.address, city: @gios_station.city, latitude: @gios_station.latitude, longitude: @gios_station.longitude, name: @gios_station.name, number: @gios_station.number } }
    assert_redirected_to gios_station_url(@gios_station)
  end

  test "should destroy gios_station" do
    assert_difference('GiosStation.count', -1) do
      delete gios_station_url(@gios_station)
    end

    assert_redirected_to gios_stations_url
  end
end
