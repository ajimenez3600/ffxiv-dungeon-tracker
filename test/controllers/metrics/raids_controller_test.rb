require "test_helper"

class Metrics::RaidsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metrics_raid = metrics_raids(:one)
  end

  test "should get index" do
    get metrics_raids_url
    assert_response :success
  end

  test "should get new" do
    get new_metrics_raid_url
    assert_response :success
  end

  test "should create metrics_raid" do
    assert_difference('Metrics::Raid.count') do
      post metrics_raids_url, params: { metrics_raid: {  } }
    end

    assert_redirected_to metrics_raid_url(Metrics::Raid.last)
  end

  test "should show metrics_raid" do
    get metrics_raid_url(@metrics_raid)
    assert_response :success
  end

  test "should get edit" do
    get edit_metrics_raid_url(@metrics_raid)
    assert_response :success
  end

  test "should update metrics_raid" do
    patch metrics_raid_url(@metrics_raid), params: { metrics_raid: {  } }
    assert_redirected_to metrics_raid_url(@metrics_raid)
  end

  test "should destroy metrics_raid" do
    assert_difference('Metrics::Raid.count', -1) do
      delete metrics_raid_url(@metrics_raid)
    end

    assert_redirected_to metrics_raids_url
  end
end
