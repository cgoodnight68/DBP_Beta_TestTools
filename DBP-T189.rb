require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T189< Test::Unit::TestCase
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

  def test_dbp_t189

    @test.load_admin_navigation_elements
    @test.login_to_admin
    @test.admin_navigate_to("Search for Customers")
    userRow = @test.login_as_random_customer_from_backend_with_order_history()
    #username,password = @test.get_default_user_for_day
    #@test.login_as_customer(username,password)
   
    @test.click_element("My Account","UserApp","My Account in Header")
    
  
    @test.click_element("Delivery History","UserApp>MyAccount","Delivery History")
    @test.check_if_element_exists("Change Delivery Address","UserApp>MyAccount>DeliveryHistory",10,"Change Delivery Address","warn")
    @test.check_if_element_exists_get_element_text("Delivery Address","UserApp>MyAccount>DeliveryHistory",10,"Delivery Address","warn")
    @test.check_if_element_exists_get_element_text("Current Balance","UserApp>MyAccount>DeliveryHistory",10,"Current Balance")

    @test.verify_order_numbers_show_in_grid(userRow["login"],"C")
    


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


