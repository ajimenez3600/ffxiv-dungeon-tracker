require "test_helper"

class Metrics::TrialsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @metrics_trial = metrics_trials(:one)
  end

  test "should get index" do
    get metrics_trials_url
    assert_response :success
  end

  test "should get new" do
    get new_metrics_trial_url
    assert_response :success
  end

  test "should create metrics_trial" do
    assert_difference('Metrics::Trial.count') do
      post metrics_trials_url, params: { metrics_trial: {  } }
    end

    assert_redirected_to metrics_trial_url(Metrics::Trial.last)
  end

  test "should show metrics_trial" do
    get metrics_trial_url(@metrics_trial)
    assert_response :success
  end

  test "should get edit" do
    get edit_metrics_trial_url(@metrics_trial)
    assert_response :success
  end

  test "should update metrics_trial" do
    patch metrics_trial_url(@metrics_trial), params: { metrics_trial: {  } }
    assert_redirected_to metrics_trial_url(@metrics_trial)
  end

  test "should destroy metrics_trial" do
    assert_difference('Metrics::Trial.count', -1) do
      delete metrics_trial_url(@metrics_trial)
    end

    assert_redirected_to metrics_trials_url
  end
end
