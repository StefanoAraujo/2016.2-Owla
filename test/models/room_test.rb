require 'test_helper'

class RoomTest < ActiveSupport::TestCase

  def setup
    @member = Member.create(name: "Linus Torvalds", alias: "Lineu", email: "linuxFTW@linux.com", password: "i<3linux", password_confirmation: "i<3linux")
    @room = Room.create(name: "IAL", description:"Introdução à Álgebra Linear", owner: @member)
  end

  test "should save a valid room" do
    assert @room.save
  end

  test "should save room with exactly 2 or 47 characters name" do
    @valid_1 = Room.create(name: "-"*2, description: "-"*2, owner: @member)
    assert @valid_1.save
    @valid_2 = Room.create(name: "-"*47, description: "-"*2, owner: @member)
    assert @valid_2.save
  end

  test "should not save an unamed room" do
    @invalid = Room.create(name: nil, description: "-"*2, owner: @member)
    assert_not @invalid.save
  end

  test "should not save a room with no description" do
    @invalid = Room.create(name: "HC FTW", description: nil, owner: @member)
    assert_not @invalid.save
  end

  test "should note save a room with description smaller than 2 characters" do
    @invalid = Room.new(name: "Room", description: "1", owner: @member)
    assert_not @invalid.save
  end

  test "should not save a room with description bigger than 240 characters" do
    @invalid = Room.new(name: "Room", description: "A"*241, owner: @member)
    assert_not @invalid.save
  end

  test "should save a room which description has exactly 2 or 240 characters" do
    @valid1 = Room.new(name: "Room 1", description: "1"*2, owner: @member)
    assert @valid1.save
    @valid2 = Room.new(name: "Room 2", description: "1"*240, owner: @member)
    assert @valid2.save
  end

  test "should not save a room with name smaller than 2 characters" do
    @invalid = Room.create(name: "C", description: "-"*2, owner: @member)
    assert_not @invalid.save
  end

  test "should not save a room with name bigger than 47 characters" do
    @invalid = Room.create(name: "-"*48, description: "-"*2, owner: @member)
    assert_not @invalid.save
  end

  test "should create not null room" do
    assert_not_nil @room
  end

  test "should change name when room is edited" do
    before = @room.name
    @room.update_attribute(:name,"Cálculo 1")
    after = @room.name
    assert_not_equal before,after
  end

  test "should delete room" do
      room_id = @room.id
      count_before = Room.all.count
      @room.destroy
      recovered_room = Room.where(:id => room_id)
      count_after = Room.all.count
      assert_equal recovered_room.count, 0
      assert_equal count_before,count_after+1
  end
end
