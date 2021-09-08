require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T184< Test::Unit::TestCase
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

  def test_dbp_t190

    @test.load_admin_navigation_elements
    @test.login_to_admin
    @test.admin_navigate_to("Search for Customers")
    userRow = @test.login_as_random_customer_from_backend_with_upcoming_orders()
    #username,password = @test.get_default_user_for_day
    #@test.login_as_customer(username,password)
   
    @test.click_element("My Account","UserApp","My Account in Header")
    
    @test.click_element("Preferences","UserApp>MyAccount","Preferences")
    @test.check_if_element_exists("Change Delivery Address","UserApp>MyAccount>Preferences",10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text("Delivery Address","UserApp>MyAccount>Preferences",10,"Delivery Address")
    @test.check_if_element_exists("Preferences Form","UserApp>MyAccount>Preferences",10,"Preferences Form")
    @test.check_if_element_exists("Newsletter Subscriptions","UserApp>MyAccount>Preferences",10,"Newsletter Subscriptions","warn")
    @test.check_if_element_exists("Notification Preferences","UserApp>MyAccount>Preferences",10,"Notification Preferences","warn")
    @test.check_if_element_exists("Cooler Location","UserApp>MyAccount>Preferences",10,"Cooler Location","warn")
    @test.check_if_element_exists("Liked Products","UserApp>MyAccount>Preferences",10,"Liked Products","warn")
    @test.check_if_element_exists("Add Liked Products","UserApp>MyAccount>Preferences",10,"Add Liked Products","warn")
    @test.check_if_element_exists("Disliked Products","UserApp>MyAccount>Preferences",10,"Disliked Products","warn")
    @test.check_if_element_exists("Add Disliked Products","UserApp>MyAccount>Preferences",10,"Add Disliked Products","warn")
    @test.check_if_element_exists("Phone Provider","UserApp>MyAccount>Preferences",10,"Phone Provider","warn")




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


