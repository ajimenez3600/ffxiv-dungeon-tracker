require "test_helper"

class Metrics::RoulettesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metrics_roulette = metrics_roulettes(:one)
  end

  test "should get index" do
    get metrics_roulettes_url
    assert_response :success
  end

  test "should get new" do
    get new_metrics_roulette_url
    assert_response :success
  end

  test "should create metrics_roulette" do
    assert_difference('Metrics::Roulette.count') do
      post metrics_roulettes_url, params: { metrics_roulette: {  } }
    end

    assert_redirected_to metrics_roulette_url(Metrics::Roulette.last)
  end

  test "should show metrics_roulette" do
    get metrics_roulette_url(@metrics_roulette)
    assert_response :success
  end

  test "should get edit" do
    get edit_metrics_roulette_url(@metrics_roulette)
    assert_response :success
  end

  test "should update metrics_roulette" do
    patch metrics_roulette_url(@metrics_roulette), params: { metrics_roulette: {  } }
    assert_redirected_to metrics_roulette_url(@metrics_roulette)
  end

  test "should destroy metrics_roulette" do
    assert_difference('Metrics::Roulette.count', -1) do
      delete metrics_roulette_url(@metrics_roulette)
    end

    assert_redirected_to metrics_roulettes_url
  end
end
