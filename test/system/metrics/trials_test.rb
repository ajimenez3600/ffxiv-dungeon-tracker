require "application_system_test_case"

class Metrics::TrialsTest < ApplicationSystemTestCase
  setup do
    @metrics_trial = metrics_trials(:one)
  end

  test "visiting the index" do
    visit metrics_trials_url
    assert_selector "h1", text: "Metrics/Trials"
  end

  test "creating a Trial" do
    visit metrics_trials_url
    click_on "New Metrics/Trial"

    click_on "Create Trial"

    assert_text "Trial was successfully created"
    click_on "Back"
  end

  test "updating a Trial" do
    visit metrics_trials_url
    click_on "Edit", match: :first

    click_on "Update Trial"

    assert_text "Trial was successfully updated"
    click_on "Back"
  end

  test "destroying a Trial" do
    visit metrics_trials_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Trial was successfully destroyed"
  end
end
