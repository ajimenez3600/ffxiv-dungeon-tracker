require "application_system_test_case"

class Metrics::DeepDungeonsTest < ApplicationSystemTestCase
  setup do
    @metrics_deep_dungeon = metrics_deep_dungeons(:one)
  end

  test "visiting the index" do
    visit metrics_deep_dungeons_url
    assert_selector "h1", text: "Metrics/Deep Dungeons"
  end

  test "creating a Deep dungeon" do
    visit metrics_deep_dungeons_url
    click_on "New Metrics/Deep Dungeon"

    click_on "Create Deep dungeon"

    assert_text "Deep dungeon was successfully created"
    click_on "Back"
  end

  test "updating a Deep dungeon" do
    visit metrics_deep_dungeons_url
    click_on "Edit", match: :first

    click_on "Update Deep dungeon"

    assert_text "Deep dungeon was successfully updated"
    click_on "Back"
  end

  test "destroying a Deep dungeon" do
    visit metrics_deep_dungeons_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Deep dungeon was successfully destroyed"
  end
end
