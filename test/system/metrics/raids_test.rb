require "application_system_test_case"

class Metrics::RaidsTest < ApplicationSystemTestCase
  setup do
    @metrics_raid = metrics_raids(:one)
  end

  test "visiting the index" do
    visit metrics_raids_url
    assert_selector "h1", text: "Metrics/Raids"
  end

  test "creating a Raid" do
    visit metrics_raids_url
    click_on "New Metrics/Raid"

    click_on "Create Raid"

    assert_text "Raid was successfully created"
    click_on "Back"
  end

  test "updating a Raid" do
    visit metrics_raids_url
    click_on "Edit", match: :first

    click_on "Update Raid"

    assert_text "Raid was successfully updated"
    click_on "Back"
  end

  test "destroying a Raid" do
    visit metrics_raids_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Raid was successfully destroyed"
  end
end
