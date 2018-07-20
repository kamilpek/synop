require 'test_helper'

class GwMeasursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gw_measur = gw_measurs(:one)
  end

  test "should get index" do
    get gw_measurs_url
    assert_response :success
  end

  test "should get new" do
    get new_gw_measur_url
    assert_response :success
  end

  test "should create gw_measur" do
    assert_difference('GwMeasur.count') do
      post gw_measurs_url, params: { gw_measur: { datetime: @gw_measur.datetime, gw_station_id: @gw_measur.gw_station_id, rain: @gw_measur.rain, water: @gw_measur.water, winddir: @gw_measur.winddir, windlevel: @gw_measur.windlevel } }
    end

    assert_redirected_to gw_measur_url(GwMeasur.last)
  end

  test "should show gw_measur" do
    get gw_measur_url(@gw_measur)
    assert_response :success
  end

  test "should get edit" do
    get edit_gw_measur_url(@gw_measur)
    assert_response :success
  end

  test "should update gw_measur" do
    patch gw_measur_url(@gw_measur), params: { gw_measur: { datetime: @gw_measur.datetime, gw_station_id: @gw_measur.gw_station_id, rain: @gw_measur.rain, water: @gw_measur.water, winddir: @gw_measur.winddir, windlevel: @gw_measur.windlevel } }
    assert_redirected_to gw_measur_url(@gw_measur)
  end

  test "should destroy gw_measur" do
    assert_difference('GwMeasur.count', -1) do
      delete gw_measur_url(@gw_measur)
    end

    assert_redirected_to gw_measurs_url
  end
end
