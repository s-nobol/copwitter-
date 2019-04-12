require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  
  test "create Relationship_path " do
    assert_no_difference "Relationship.count" do
      post relationships_path
    end
    assert_redirected_to login_path
  end
  
  test "delete Relationship_path " do
    assert_no_difference "Relationship.count" do
      post relationships_path
    end
    assert_redirected_to login_path
  end
end
