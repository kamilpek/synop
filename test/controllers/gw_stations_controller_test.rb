require 'test_helper'

class GwStationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gw_station = gw_stations(:one)
  end

  test "should get index" do
    get gw_stations_url
    assert_response :success
  end

  test "should get new" do
    get new_gw_station_url
    assert_response :success
  end

  test "should create gw_station" do
    assert_difference('GwStation.count') do
      post gw_stations_url, params: { gw_station: { active: @gw_station.active, lat: @gw_station.lat, lng: @gw_station.lng, name: @gw_station.name, no: @gw_station.no, rain: @gw_station.rain, water: @gw_station.water, winddir: @gw_station.winddir, windlevel: @gw_station.windlevel } }
    end

    assert_redirected_to gw_station_url(GwStation.last)
  end

  test "should show gw_station" do
    get gw_station_url(@gw_station)
    assert_response :success
  end

  test "should get edit" do
    get edit_gw_station_url(@gw_station)
    assert_response :success
  end

  test "should update gw_station" do
    patch gw_station_url(@gw_station), params: { gw_station: { active: @gw_station.active, lat: @gw_station.lat, lng: @gw_station.lng, name: @gw_station.name, no: @gw_station.no, rain: @gw_station.rain, water: @gw_station.water, winddir: @gw_station.winddir, windlevel: @gw_station.windlevel } }
    assert_redirected_to gw_station_url(@gw_station)
  end

  test "should destroy gw_station" do
    assert_difference('GwStation.count', -1) do
      delete gw_station_url(@gw_station)
    end

    assert_redirected_to gw_stations_url
  end
end
