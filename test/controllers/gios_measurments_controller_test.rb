require 'test_helper'

class GiosMeasurmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gios_measurment = gios_measurments(:one)
  end

  test "should get index" do
    get gios_measurments_url
    assert_response :success
  end

  test "should get new" do
    get new_gios_measurment_url
    assert_response :success
  end

  test "should create gios_measurment" do
    assert_difference('GiosMeasurment.count') do
      post gios_measurments_url, params: { gios_measurment: { c6h6_date: @gios_measurment.c6h6_date, c6h6_index: @gios_measurment.c6h6_index, c6h6_value: @gios_measurment.c6h6_value, calc_date: @gios_measurment.calc_date, co_date: @gios_measurment.co_date, co_index: @gios_measurment.co_index, co_value: @gios_measurment.co_value, no2_date: @gios_measurment.no2_date, no2_index: @gios_measurment.no2_index, no2_value: @gios_measurment.no2_value, o3_date: @gios_measurment.o3_date, o3_index: @gios_measurment.o3_index, o3_value: @gios_measurment.o3_value, pm10_date: @gios_measurment.pm10_date, pm10_index: @gios_measurment.pm10_index, pm10_value: @gios_measurment.pm10_value, pm25_date: @gios_measurment.pm25_date, pm25_index: @gios_measurment.pm25_index, pm25_value: @gios_measurment.pm25_value, so2_date: @gios_measurment.so2_date, so2_index: @gios_measurment.so2_index, so2_value: @gios_measurment.so2_value, st_index: @gios_measurment.st_index, station: @gios_measurment.station } }
    end

    assert_redirected_to gios_measurment_url(GiosMeasurment.last)
  end

  test "should show gios_measurment" do
    get gios_measurment_url(@gios_measurment)
    assert_response :success
  end

  test "should get edit" do
    get edit_gios_measurment_url(@gios_measurment)
    assert_response :success
  end

  test "should update gios_measurment" do
    patch gios_measurment_url(@gios_measurment), params: { gios_measurment: { c6h6_date: @gios_measurment.c6h6_date, c6h6_index: @gios_measurment.c6h6_index, c6h6_value: @gios_measurment.c6h6_value, calc_date: @gios_measurment.calc_date, co_date: @gios_measurment.co_date, co_index: @gios_measurment.co_index, co_value: @gios_measurment.co_value, no2_date: @gios_measurment.no2_date, no2_index: @gios_measurment.no2_index, no2_value: @gios_measurment.no2_value, o3_date: @gios_measurment.o3_date, o3_index: @gios_measurment.o3_index, o3_value: @gios_measurment.o3_value, pm10_date: @gios_measurment.pm10_date, pm10_index: @gios_measurment.pm10_index, pm10_value: @gios_measurment.pm10_value, pm25_date: @gios_measurment.pm25_date, pm25_index: @gios_measurment.pm25_index, pm25_value: @gios_measurment.pm25_value, so2_date: @gios_measurment.so2_date, so2_index: @gios_measurment.so2_index, so2_value: @gios_measurment.so2_value, st_index: @gios_measurment.st_index, station: @gios_measurment.station } }
    assert_redirected_to gios_measurment_url(@gios_measurment)
  end

  test "should destroy gios_measurment" do
    assert_difference('GiosMeasurment.count', -1) do
      delete gios_measurment_url(@gios_measurment)
    end

    assert_redirected_to gios_measurments_url
  end
end
