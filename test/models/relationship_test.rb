require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # User_Relation_shipがうまく機能しているか？
  
  def setup
    # @user = users(:first_user)
    @relationship = Relationship.new(follower_id: users(:first_user).id, 
                                      followed_id: users(:second_user).id )
  end
  
  test "relation_ship.valid?" do
    assert @relationship.valid?
  end
  
  # followerがNilでも通るか？
  test "follower_id nil?" do
    @relationship.follower_id = nil 
    assert_not  @relationship.valid?, "@relationship.save? #{@relationship.save}"
  end
  
  test "followed_id nil?" do
    @relationship.follower_id = nil 
    assert_not @relationship.valid?, "@relationship.save? #{@relationship.save}"
  end
end
