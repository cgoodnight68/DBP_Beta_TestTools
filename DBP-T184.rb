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

  def test_dbp_t184

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
    @test.check_if_element_exists("Referrals","UserApp>MyAccount",10,"Referals",true)


    @test.click_element("Account Info","UserApp>MyAccount","Account Info")
    @test.check_if_element_exists("First Name","UserApp>MyAccount>AccountInfo",10,"First Name")
    @test.check_if_element_exists("Last Name","UserApp>MyAccount>AccountInfo",10,"Last Name")
    @test.check_if_element_exists("Email","UserApp>MyAccount>AccountInfo",10,"Email")
    @test.check_if_element_exists("Additional Email","UserApp>MyAccount>AccountInfo",10,"Additional Email","warn")
    @test.check_if_element_exists("Phone","UserApp>MyAccount>AccountInfo",10,"Phone")
    @test.check_if_element_exists("Birthday","UserApp>MyAccount>AccountInfo",10,"Birthday","warn")
    @test.check_if_element_exists("Address","UserApp>MyAccount>AccountInfo",10,"Address")
    @test.check_if_element_exists("Address Line 2","UserApp>MyAccount>AccountInfo",10,"Address Line 2")
    @test.check_if_element_exists("City","UserApp>MyAccount>AccountInfo",10,"City")

    @test.check_if_element_exists("County","UserApp>MyAccount>AccountInfo",10,"County","warn")
    @test.check_if_element_exists("State","UserApp>MyAccount>AccountInfo",10,"State")
    @test.check_if_element_exists("Zipcode","UserApp>MyAccount>AccountInfo",10,"Zipcode")
    @test.check_if_element_exists("Payment info Credit Card","UserApp>MyAccount>AccountInfo",10,"Payment info Credit Card")
    @test.check_if_element_exists("Payment info Check","UserApp>MyAccount>AccountInfo",10,"Payment info Check","warn")
    @test.check_if_element_exists("Payment info EBT","UserApp>MyAccount>AccountInfo",10,"Payment info EBT","warn")
    @test.check_if_element_exists("Billing and Delivery Same Checkbox","UserApp>MyAccount>AccountInfo",10,"Billing and Delivery Same Checkbox")

    @test.click_element("Upcoming Deliveries","UserApp>MyAccount","Upcoming Deliveries")
    @test.check_if_element_exists_get_element_text("Upcoming Deliveries Table","UserApp>MyAccount>UpcomingDeliveries",10,"Upcoming Deliveries Table")
    @test.check_if_element_exists("Change Delivery Address","UserApp>MyAccount>UpcomingDeliveries",10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text("Delivery Address","UserApp>MyAccount>UpcomingDeliveries",10,"Delivery Address")


    @test.click_element("Delivery Hold","UserApp>MyAccount","Delivery Hold")
    @test.check_if_element_exists("Leaving","UserApp>MyAccount>DeliveryHolds",10,"Leaving")
    @test.check_if_element_exists("Returning","UserApp>MyAccount>DeliveryHolds",10,"Returning")
    @test.check_if_element_exists("Change Delivery Address","UserApp>MyAccount>DeliveryHolds",10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text("Delivery Address","UserApp>MyAccount>DeliveryHolds",10,"Delivery Address")
    @test.check_if_element_exists_get_element_text("Add Vacation","UserApp>MyAccount>DeliveryHolds",10,"Add Vacation")


    @test.click_element("Recurring Items","UserApp>MyAccount","Recurring Items")
    @test.check_if_element_exists("Change Delivery Address","UserApp>MyAccount>RecurringItems",10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text("Delivery Address","UserApp>MyAccount>RecurringItems",10,"Delivery Address")
    @test.check_if_element_exists_get_element_text("Recurring Items Table","UserApp>MyAccount>RecurringItems",10,"Recurring Items Table")
    @test.check_if_element_exists("Remove All","UserApp>MyAccount>RecurringItems",10,"Remove All")
    @test.check_if_element_exists("Update Order","UserApp>MyAccount>RecurringItems",10,"Update Order")
    @test.check_if_element_exists("Apply","UserApp>MyAccount>RecurringItems",10,"Apply")
    @test.check_if_element_exists("Coupon Code","UserApp>MyAccount>RecurringItems",10,"Coupon Code")

    @test.click_element("Delivery History","UserApp>MyAccount","Delivery History")
    @test.check_if_element_exists("Change Delivery Address","UserApp>MyAccount>DeliveryHistory",10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text("Delivery Address","UserApp>MyAccount>DeliveryHistory",10,"Delivery Address")
    @test.check_if_element_exists_get_element_text("Current Balance","UserApp>MyAccount>DeliveryHistory",10,"Current Balance")


    @test.click_element("Preferences","UserApp>MyAccount","Preferences")
    @test.check_if_element_exists("Change Delivery Address","UserApp>MyAccount>Preferences",10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text("Delivery Address","UserApp>MyAccount>Preferences",10,"Delivery Address")
    @test.check_if_element_exists("Preferences Form","UserApp>MyAccount>Preferences",10,"Preferences Form")
    @test.check_if_element_exists("Newsletter Subscriptions","UserApp>MyAccount>Preferences",10,"Newsletter Subscriptions")
    @test.check_if_element_exists("Notification Preferences","UserApp>MyAccount>Preferences",10,"Notification Preferences")
    @test.check_if_element_exists("Cooler Location","UserApp>MyAccount>Preferences",10,"Cooler Location","warn")
    @test.check_if_element_exists("Liked Products","UserApp>MyAccount>Preferences",10,"Liked Products","warn")
    @test.check_if_element_exists("Add Liked Products","UserApp>MyAccount>Preferences",10,"Add Liked Products","warn")
    @test.check_if_element_exists("Disliked Products","UserApp>MyAccount>Preferences",10,"Disliked Products","warn")
    @test.check_if_element_exists("Add Disliked Products","UserApp>MyAccount>Preferences",10,"Add Disliked Products","warn")
    @test.check_if_element_exists("Phone Provider","UserApp>MyAccount>Preferences",10,"Phone Provider","warn")

    @test.click_element("Referrals","UserApp>MyAccount","Referals",true)
    @test.check_if_element_exists("Referral URL","UserApp>MyAccount>Referrals",10,"Referral URL",true)


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


