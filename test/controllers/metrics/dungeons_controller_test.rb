require "test_helper"

class Metrics::DungeonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metrics_dungeon = metrics_dungeons(:one)
  end

  test "should get index" do
    get metrics_dungeons_url
    assert_response :success
  end

  test "should get new" do
    get new_metrics_dungeon_url
    assert_response :success
  end

  test "should create metrics_dungeon" do
    assert_difference('Metrics::Dungeon.count') do
      post metrics_dungeons_url, params: { metrics_dungeon: {  } }
    end

    assert_redirected_to metrics_dungeon_url(Metrics::Dungeon.last)
  end

  test "should show metrics_dungeon" do
    get metrics_dungeon_url(@metrics_dungeon)
    assert_response :success
  end

  test "should get edit" do
    get edit_metrics_dungeon_url(@metrics_dungeon)
    assert_response :success
  end

  test "should update metrics_dungeon" do
    patch metrics_dungeon_url(@metrics_dungeon), params: { metrics_dungeon: {  } }
    assert_redirected_to metrics_dungeon_url(@metrics_dungeon)
  end

  test "should destroy metrics_dungeon" do
    assert_difference('Metrics::Dungeon.count', -1) do
      delete metrics_dungeon_url(@metrics_dungeon)
    end

    assert_redirected_to metrics_dungeons_url
  end
end
