require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T187< Test::Unit::TestCase
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

  def test_dbp_t187

    @test.load_admin_navigation_elements
    @test.login_to_admin
    @test.admin_navigate_to("Search for Customers")
    userRow = @test.login_as_random_customer_from_backend_with_upcoming_orders()
    #username,password = @test.get_default_user_for_day
    #@test.login_as_customer(username,password)
   
    @test.click_element("My Account","UserApp","My Account in Header")
    
  
    @test.click_element("Delivery Hold","UserApp>MyAccount","Delivery Hold")
    @test.check_if_element_exists("Leaving","UserApp>MyAccount>DeliveryHolds",10,"Leaving")
    @test.check_if_element_exists("Returning","UserApp>MyAccount>DeliveryHolds",10,"Returning")
    @test.check_if_element_exists("Change Delivery Address","UserApp>MyAccount>DeliveryHolds",10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text("Delivery Address","UserApp>MyAccount>DeliveryHolds",10,"Delivery Address","warn")
    @test.check_if_element_exists_get_element_text("Add Vacation","UserApp>MyAccount>DeliveryHolds",10,"Add Vacation","warn")



    rescue => e
    @util.logging("V______FAILURE!!! Previous line failed. Trace below. __________V")
    @util.logging(e.inspect)
    errortrace = e.backtrace
    size = errortrace.size
    for i in 0..size
      errortraceString = "#{errortraceString}\n #{errortrace[i]}"
    end
    @util.logging(errortraceString)
    throw e
  end

end


