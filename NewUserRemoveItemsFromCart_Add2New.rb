require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class NewUserPlaceOrder < Test::Unit::TestCase
  def setup
    @test=Utilities.new
    filedir = File.expand_path File.dirname(__FILE__)
    filebase =  File.basename(__FILE__)
    @test.setup_tasks(filedir , filebase)
    @@g_base_dir, @util, @@environment, @driver, @base_url,@@brws,@@filedir=@test.get_globals

  end

  def teardown
    @test.teardown_tasks(passed?)
    assert_equal nil, @verification_errors
  end

  def test_new_user_place_order

    @test.load_admin_navigation_elements
    username,password = @test.get_default_user_for_day
    @test.login_as_customer(username,password)
    @test.go_to_cart()
    @test.remove_item_from_cart_and_verify(2)
    @test.remove_item_from_cart_and_verify(1)
    @test.select_random_item_from_shop_page(1,"Next Week")
    @test.select_random_item_from_shop_page(1,"Weekly")
  end


end
