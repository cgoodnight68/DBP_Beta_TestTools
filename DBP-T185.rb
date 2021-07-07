require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T185< Test::Unit::TestCase
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

  def test_dbp_t185

    @test.load_admin_navigation_elements
    @test.login_to_admin
    @test.admin_navigate_to("Search for Customers")
    userRow = @test.login_as_random_customer_from_backend_with_upcoming_orders()
    #username,password = @test.get_default_user_for_day
    #@test.login_as_customer(username,password)
    @test.click_element("My Account","UserApp","My Account in Header")
    
    @test.check_if_element_exists("My Account","UserApp>MyAccount",10,"My Account")
    @test.check_if_element_exists("Account Info","UserApp>MyAccount",10,"Account Info")
    @test.check_if_element_exists("Upcoming Deliveries","UserApp>MyAccount",10,"Upcoming Deliveries")
    @test.check_if_element_exists("Delivery Hold","UserApp>MyAccount",10,"Delivery Hold")
    @test.check_if_element_exists("Recurring Items","UserApp>MyAccount",10,"Recurring Items")
    @test.check_if_element_exists("Delivery History","UserApp>MyAccount",10,"Delivery History")
    @test.check_if_element_exists("Preferences","UserApp>MyAccount",10,"Preferences")
    @test.check_if_element_exists("Referrals","UserApp>MyAccount",10,"Referalls")


    @test.click_element("Account Info","UserApp>MyAccount","Account Info")
    @test.check_if_element_exists_and_has_value("First Name","UserApp>MyAccount>AccountInfo",userRow["firstname"],10,"First Name")
    @test.check_if_element_exists_and_has_value("Last Name","UserApp>MyAccount>AccountInfo",userRow["lastname"],10,"Last Name")
    @test.check_if_element_exists_and_has_value("Email","UserApp>MyAccount>AccountInfo",userRow["email"],10,"Email")
    @test.check_if_element_exists("Additional Email","UserApp>MyAccount>AccountInfo",10,"Additional Email","warn")
    @test.check_if_element_exists_and_has_value("Phone","UserApp>MyAccount>AccountInfo",userRow["phone"],10,"Phone","warn")
    @test.check_if_element_exists("Birthday","UserApp>MyAccount>AccountInfo",10,"Birthday","warn")
    @test.check_if_element_exists_and_has_value("Address","UserApp>MyAccount>AccountInfo",userRow["s_address"],10,"Address")
    @test.check_if_element_exists("Address Line 2","UserApp>MyAccount>AccountInfo",10,"Address Line 2")
    @test.check_if_element_exists("City","UserApp>MyAccount>AccountInfo",10,"City")

    @test.check_if_element_exists("County","UserApp>MyAccount>AccountInfo",10,"County","warn")
    @test.check_if_element_exists("State","UserApp>MyAccount>AccountInfo",10,"State")
    @test.check_if_element_exists("Zipcode","UserApp>MyAccount>AccountInfo",10,"Zipcode")
    @test.check_if_element_exists("Payment info Credit Card","UserApp>MyAccount>AccountInfo",10,"Payment info Credit Card")
    @test.check_if_element_exists("Payment info Check","UserApp>MyAccount>AccountInfo",10,"Payment info Check","warn")
    @test.check_if_element_exists("Payment info EBT","UserApp>MyAccount>AccountInfo",10,"Payment info EBT","warn")
    @test.check_if_element_exists("Billing and Delivery Same Checkbox","UserApp>MyAccount>AccountInfo",10,"Billing and Delivery Same Checkbox")

    


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


