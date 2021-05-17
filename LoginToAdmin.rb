require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class LogonToAdmin < Test::Unit::TestCase
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

  def test_logon_to
    #@base_url = "https://integration.deliverybizpro.com/admin/login"
    #@util.logging("BaseURL ) \n>")

    @test.load_admin_navigation_elements
    @test.login_to_admin




    ##@driver.manage.window.maximize

    #  @test.goto_url("https://integration.deliverybizpro.com/admin")

    @test.admin_navigate_to("Search for Customers")



  end


end
