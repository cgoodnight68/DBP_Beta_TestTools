require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T188< Test::Unit::TestCase
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

  def test_dbp_t188

    @test.load_admin_navigation_elements
    @test.login_to_admin
    @test.admin_navigate_to("Search for Customers")
    userRow = @test.login_as_random_customer_from_backend_with_recurring_orders()
    #username,password = @test.get_default_user_for_day
    #@test.login_as_customer(username,password)
   
    @test.click_element("My Account","UserApp","My Account in Header")
    
    @test.check_if_element_exists("My Account","UserApp>MyAccount",10,"My Account")
    @test.check_if_element_exists("Account Info","UserApp>MyAccount",10,"Account Info")
    @test.check_if_element_exists("Upcoming Deliveries","UserApp>MyAccount",10,"Upcoming Deliveries")
    @test.check_if_element_exists("Delivery Hold","UserApp>MyAccount",10,"Delivery Hold")
    @test.check_if_element_exists("Recurring Items","UserApp>MyAccount",10,"Recurring Items")
    @test.check_if_element_exists("Delivery History","UserApp>MyAccount",10,"Delivery History","warn")
    @test.check_if_element_exists("Preferences","UserApp>MyAccount",10,"Preferences")
    @test.check_if_element_exists("Referrals","UserApp>MyAccount",10,"Referalls","warn")




    @test.click_element("Recurring Items","UserApp>MyAccount","Recurring Items")
    @test.check_if_element_exists("Change Delivery Address","UserApp>MyAccount>RecurringItems",10,"Change Delivery Address","warn")
    @test.check_if_element_exists_get_element_text("Delivery Address","UserApp>MyAccount>RecurringItems",10,"Delivery Address","warn")
    recurringItems = @test.check_if_element_exists_get_element_text("Recurring Items Table","UserApp>MyAccount>RecurringItems",10,"Recurring Items Table")
    assert(recurringItems.include?("No Recurring Items")== false,"There are no recurring items in the users cart")
    @test.check_if_element_exists("Remove All","UserApp>MyAccount>RecurringItems",10,"Remove All")
    @test.check_if_element_exists("Update Order","UserApp>MyAccount>RecurringItems",10,"Update Order")
    @test.check_if_element_exists("Apply","UserApp>MyAccount>RecurringItems",10,"Apply")
    @test.check_if_element_exists("Coupon Code","UserApp>MyAccount>RecurringItems",10,"Coupon Code")


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


