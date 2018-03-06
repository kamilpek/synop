require 'test_helper'

class MetarRaportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metar_raport = metar_raports(:one)
  end

  test "should get index" do
    get metar_raports_url
    assert_response :success
  end

  test "should get new" do
    get new_metar_raport_url
    assert_response :success
  end

  test "should create metar_raport" do
    assert_difference('MetarRaport.count') do
      post metar_raports_url, params: { metar_raport: { day: @metar_raport.day, hour: @metar_raport.hour, message: @metar_raport.message, metar: @metar_raport.metar, station: @metar_raport.station } }
    end

    assert_redirected_to metar_raport_url(MetarRaport.last)
  end

  test "should show metar_raport" do
    get metar_raport_url(@metar_raport)
    assert_response :success
  end

  test "should get edit" do
    get edit_metar_raport_url(@metar_raport)
    assert_response :success
  end

  test "should update metar_raport" do
    patch metar_raport_url(@metar_raport), params: { metar_raport: { day: @metar_raport.day, hour: @metar_raport.hour, message: @metar_raport.message, metar: @metar_raport.metar, station: @metar_raport.station } }
    assert_redirected_to metar_raport_url(@metar_raport)
  end

  test "should destroy metar_raport" do
    assert_difference('MetarRaport.count', -1) do
      delete metar_raport_url(@metar_raport)
    end

    assert_redirected_to metar_raports_url
  end
end
