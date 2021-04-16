require "test_helper"

class Metrics::DeepDungeonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metrics_deep_dungeon = metrics_deep_dungeons(:one)
  end

  test "should get index" do
    get metrics_deep_dungeons_url
    assert_response :success
  end

  test "should get new" do
    get new_metrics_deep_dungeon_url
    assert_response :success
  end

  test "should create metrics_deep_dungeon" do
    assert_difference('Metrics::DeepDungeon.count') do
      post metrics_deep_dungeons_url, params: { metrics_deep_dungeon: {  } }
    end

    assert_redirected_to metrics_deep_dungeon_url(Metrics::DeepDungeon.last)
  end

  test "should show metrics_deep_dungeon" do
    get metrics_deep_dungeon_url(@metrics_deep_dungeon)
    assert_response :success
  end

  test "should get edit" do
    get edit_metrics_deep_dungeon_url(@metrics_deep_dungeon)
    assert_response :success
  end

  test "should update metrics_deep_dungeon" do
    patch metrics_deep_dungeon_url(@metrics_deep_dungeon), params: { metrics_deep_dungeon: {  } }
    assert_redirected_to metrics_deep_dungeon_url(@metrics_deep_dungeon)
  end

  test "should destroy metrics_deep_dungeon" do
    assert_difference('Metrics::DeepDungeon.count', -1) do
      delete metrics_deep_dungeon_url(@metrics_deep_dungeon)
    end

    assert_redirected_to metrics_deep_dungeons_url
  end
end
