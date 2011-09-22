require 'test_helper'

class EmailingTest < ActiveSupport::TestCase
  
  test "should create emailing" do
    emailing = Emailing.new
    emailing.description = emailings(:one)
    emailing.api_key = emailings(:one)
    assert emailing.save
  end
  
  test "should not save without status, description and api_key " do
    emailing = Emailing.new
    assert !emailing.valid?
    assert emailing.errors[:description].any?
    assert emailing.errors[:api_key].any?
    assert_equal ["can't be blank"], emailing.errors[:description]
    assert_equal ["can't be blank"], emailing.errors[:api_key]
    assert !emailing.save
  end
  
  test "should find emailing" do
    emailing_id = emailings(:one).id
    assert_nothing_raised { Emailing.find(emailing_id) }
  end

  test "should update emailing" do
    emailing = emailings(:one)
    assert emailing.update_attributes(:list_key => '23dxdT6fg8g')
  end
  
  test "should destroy emailing" do
    emailing = emailings(:one)
    emailing.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Emailing.find(emailing.id) }
  end
  
end
