require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class CreateAppsideDefaultCustomerForDay < Test::Unit::TestCase
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

  def test_create_appside_default_user_for_day

    @test.load_admin_navigation_elements
    @test.create_new_user_customer_side()
    sleep(10)
    newurl = @test.get_url()
    assert_equal newurl,"#{@base_url}/thanks_for_registering.php"
   

  end


end
