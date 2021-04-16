require "application_system_test_case"

class Metrics::RoulettesTest < ApplicationSystemTestCase
  setup do
    @metrics_roulette = metrics_roulettes(:one)
  end

  test "visiting the index" do
    visit metrics_roulettes_url
    assert_selector "h1", text: "Metrics/Roulettes"
  end

  test "creating a Roulette" do
    visit metrics_roulettes_url
    click_on "New Metrics/Roulette"

    click_on "Create Roulette"

    assert_text "Roulette was successfully created"
    click_on "Back"
  end

  test "updating a Roulette" do
    visit metrics_roulettes_url
    click_on "Edit", match: :first

    click_on "Update Roulette"

    assert_text "Roulette was successfully updated"
    click_on "Back"
  end

  test "destroying a Roulette" do
    visit metrics_roulettes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Roulette was successfully destroyed"
  end
end
