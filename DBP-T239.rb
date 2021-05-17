require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T239 < Test::Unit::TestCase
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

  def test_dbp_t239
  	time = Time.new
    date = "#{time.month}_#{time.day}_#{time.year}"
    @test.load_admin_navigation_elements
    @test.login_to_admin
    @test.admin_navigate_to("Search for Customers")
    @test.search_for_customer("#{date}_Default_Cust@mailinator.com")
  end


end
