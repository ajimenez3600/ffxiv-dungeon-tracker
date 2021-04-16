require "application_system_test_case"

class Metrics::DungeonsTest < ApplicationSystemTestCase
  setup do
    @metrics_dungeon = metrics_dungeons(:one)
  end

  test "visiting the index" do
    visit metrics_dungeons_url
    assert_selector "h1", text: "Metrics/Dungeons"
  end

  test "creating a Dungeon" do
    visit metrics_dungeons_url
    click_on "New Metrics/Dungeon"

    click_on "Create Dungeon"

    assert_text "Dungeon was successfully created"
    click_on "Back"
  end

  test "updating a Dungeon" do
    visit metrics_dungeons_url
    click_on "Edit", match: :first

    click_on "Update Dungeon"

    assert_text "Dungeon was successfully updated"
    click_on "Back"
  end

  test "destroying a Dungeon" do
    visit metrics_dungeons_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dungeon was successfully destroyed"
  end
end
