require 'test_helper'

class RadarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @radar = radars(:one)
  end

  test "should get index" do
    get radars_url
    assert_response :success
  end

  test "should get new" do
    get new_radar_url
    assert_response :success
  end

  test "should create radar" do
    assert_difference('Radar.count') do
      post radars_url, params: { radar: { cappi: @radar.cappi, cmaxdbz: @radar.cmaxdbz, eht: @radar.eht, hshear: @radar.hshear, pac: @radar.pac, zhail: @radar.zhail } }
    end

    assert_redirected_to radar_url(Radar.last)
  end

  test "should show radar" do
    get radar_url(@radar)
    assert_response :success
  end

  test "should get edit" do
    get edit_radar_url(@radar)
    assert_response :success
  end

  test "should update radar" do
    patch radar_url(@radar), params: { radar: { cappi: @radar.cappi, cmaxdbz: @radar.cmaxdbz, eht: @radar.eht, hshear: @radar.hshear, pac: @radar.pac, zhail: @radar.zhail } }
    assert_redirected_to radar_url(@radar)
  end

  test "should destroy radar" do
    assert_difference('Radar.count', -1) do
      delete radar_url(@radar)
    end

    assert_redirected_to radars_url
  end
end
