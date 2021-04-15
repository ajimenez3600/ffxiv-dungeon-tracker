require "application_system_test_case"

class InstanceEntriesTest < ApplicationSystemTestCase
  setup do
    @instance_entry = instance_entries(:one)
  end

  test "visiting the index" do
    visit instance_entries_url
    assert_selector "h1", text: "Instance Entries"
  end

  test "creating a Instance entry" do
    visit instance_entries_url
    click_on "New Instance Entry"

    click_on "Create Instance entry"

    assert_text "Instance entry was successfully created"
    click_on "Back"
  end

  test "updating a Instance entry" do
    visit instance_entries_url
    click_on "Edit", match: :first

    click_on "Update Instance entry"

    assert_text "Instance entry was successfully updated"
    click_on "Back"
  end

  test "destroying a Instance entry" do
    visit instance_entries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Instance entry was successfully destroyed"
  end
end
