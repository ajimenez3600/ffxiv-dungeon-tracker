require "test_helper"

class InstanceEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @instance_entry = instance_entries(:one)
  end

  test "should get index" do
    get instance_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_instance_entry_url
    assert_response :success
  end

  test "should create instance_entry" do
    assert_difference('InstanceEntry.count') do
      post instance_entries_url, params: { instance_entry: {  } }
    end

    assert_redirected_to instance_entry_url(InstanceEntry.last)
  end

  test "should show instance_entry" do
    get instance_entry_url(@instance_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_instance_entry_url(@instance_entry)
    assert_response :success
  end

  test "should update instance_entry" do
    patch instance_entry_url(@instance_entry), params: { instance_entry: {  } }
    assert_redirected_to instance_entry_url(@instance_entry)
  end

  test "should destroy instance_entry" do
    assert_difference('InstanceEntry.count', -1) do
      delete instance_entry_url(@instance_entry)
    end

    assert_redirected_to instance_entries_url
  end
end
