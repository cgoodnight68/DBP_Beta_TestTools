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

  def test_new_user_my_account

    @test.load_admin_navigation_elements
    username,password = @test.get_default_user_for_day
    @test.login_as_customer(username,password)
    #binding.pry
    @test.click_element(:link,@test.get_element_from_navigation("My Account","UserApp"),"My Account in Header")

    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("My Account","UserApp>MyAccount"),10,"My Account")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Account Info","UserApp>MyAccount"),10,"Account Info")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Upcoming Deliveries","UserApp>MyAccount"),10,"Upcoming Deliveries")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Delivery Hold","UserApp>MyAccount"),10,"Delivery Hold")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Recurring Items","UserApp>MyAccount"),10,"Recurring Items")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Delivery History","UserApp>MyAccount"),10,"Delivery History")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Preferences","UserApp>MyAccount"),10,"Preferences")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Referrals","UserApp>MyAccount"),10,"Referalls")


    @test.click_element(:xpath,@test.get_element_from_navigation("Account Info","UserApp>MyAccount"),"Account Info")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("First Name","UserApp>MyAccount>AccountInfo"),10,"First Name")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Last Name","UserApp>MyAccount>AccountInfo"),10,"Last Name")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Email","UserApp>MyAccount>AccountInfo"),10,"Email")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Additional Email","UserApp>MyAccount>AccountInfo"),10,"Additional Email")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Phone","UserApp>MyAccount>AccountInfo"),10,"Phone")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Birthday","UserApp>MyAccount>AccountInfo"),10,"Birthday")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Address","UserApp>MyAccount>AccountInfo"),10,"Address")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Address Line 2","UserApp>MyAccount>AccountInfo"),10,"Address Line 2")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("City","UserApp>MyAccount>AccountInfo"),10,"City")

    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("County","UserApp>MyAccount>AccountInfo"),10,"County")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("State","UserApp>MyAccount>AccountInfo"),10,"State")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Zipcode","UserApp>MyAccount>AccountInfo"),10,"Zipcode")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Payment info Credit Card","UserApp>MyAccount>AccountInfo"),10,"Payment info Credit Card")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Payment info Check","UserApp>MyAccount>AccountInfo"),10,"Payment info Check")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Payment info EBT","UserApp>MyAccount>AccountInfo"),10,"Payment info EBT")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Billing and Delivery Same Checkbox","UserApp>MyAccount>AccountInfo"),10,"Billing and Delivery Same Checkbox")

    @test.click_element(:xpath,@test.get_element_from_navigation("Upcoming Deliveries","UserApp>MyAccount"),"Upcoming Deliveries")
    @test.check_if_element_exists_get_element_text(:xpath,@test.get_element_from_navigation("Upcoming Deliveries Table","UserApp>MyAccount>UpcomingDeliveries"),10,"Upcoming Deliveries Table")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Change Delivery Address","UserApp>MyAccount>UpcomingDeliveries"),10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text(:xpath,@test.get_element_from_navigation("Delivery Address","UserApp>MyAccount>UpcomingDeliveries"),10,"Delivery Address")


    @test.click_element(:xpath,@test.get_element_from_navigation("Delivery Hold","UserApp>MyAccount"),"Delivery Hold")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Leaving","UserApp>MyAccount>DeliveryHolds"),10,"Leaving")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Returning","UserApp>MyAccount>DeliveryHolds"),10,"Returning")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Change Delivery Address","UserApp>MyAccount>DeliveryHolds"),10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text(:xpath,@test.get_element_from_navigation("Delivery Address","UserApp>MyAccount>DeliveryHolds"),10,"Delivery Address")
    @test.check_if_element_exists_get_element_text(:xpath,@test.get_element_from_navigation("Add Vacation","UserApp>MyAccount>DeliveryHolds"),10,"Add Vacation")


    @test.click_element(:xpath,@test.get_element_from_navigation("Recurring Items","UserApp>MyAccount"),"Recurring Items")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Change Delivery Address","UserApp>MyAccount>RecurringItems"),10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text(:xpath,@test.get_element_from_navigation("Delivery Address","UserApp>MyAccount>RecurringItems"),10,"Delivery Address")
    @test.check_if_element_exists_get_element_text(:xpath,@test.get_element_from_navigation("Recurring Items Table","UserApp>MyAccount>RecurringItems"),10,"Recurring Items Table")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Remove All","UserApp>MyAccount>RecurringItems"),10,"Remove All")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Update Order","UserApp>MyAccount>RecurringItems"),10,"Update Order")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Apply","UserApp>MyAccount>RecurringItems"),10,"Apply")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Coupon Code","UserApp>MyAccount>RecurringItems"),10,"Coupon Code")

    @test.click_element(:xpath,@test.get_element_from_navigation("Delivery History","UserApp>MyAccount"),"Delivery History")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Change Delivery Address","UserApp>MyAccount>DeliveryHistory"),10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text(:xpath,@test.get_element_from_navigation("Delivery Address","UserApp>MyAccount>DeliveryHistory"),10,"Delivery Address")
    @test.check_if_element_exists_get_element_text(:xpath,@test.get_element_from_navigation("Current Balance","UserApp>MyAccount>DeliveryHistory"),10,"Current Balance")


    @test.click_element(:xpath,@test.get_element_from_navigation("Preferences","UserApp>MyAccount"),"Preferences")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Change Delivery Address","UserApp>MyAccount>Preferences"),10,"Change Delivery Address")
    @test.check_if_element_exists_get_element_text(:xpath,@test.get_element_from_navigation("Delivery Address","UserApp>MyAccount>Preferences"),10,"Delivery Address")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Preferences Form","UserApp>MyAccount>Preferences"),10,"Preferences Form")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Newsletter Subscriptions","UserApp>MyAccount>Preferences"),10,"Newsletter Subscriptions")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Notification Preferences","UserApp>MyAccount>Preferences"),10,"Notification Preferences")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Cooler Location","UserApp>MyAccount>Preferences"),10,"Cooler Location")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Liked Products","UserApp>MyAccount>Preferences"),10,"Liked Products")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Add Liked Products","UserApp>MyAccount>Preferences"),10,"Add Liked Products")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Disliked Products","UserApp>MyAccount>Preferences"),10,"Disliked Products")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Add Disliked Products","UserApp>MyAccount>Preferences"),10,"Add Disliked Products")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Phone Provider","UserApp>MyAccount>Preferences"),10,"Phone Provider")

    @test.click_element(:xpath,@test.get_element_from_navigation("Referrals","UserApp>MyAccount"),"Referals")
    @test.check_if_element_exists(:xpath,@test.get_element_from_navigation("Referral URL","UserApp>MyAccount>Referrals"),10,"Referral URL")


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


