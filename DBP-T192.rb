require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T192 < Test::Unit::TestCase
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

  def test_updating_payment_info
    begin
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Search for Customers")
      userRow = @test.login_as_random_customer_from_backend_with_upcoming_orders()
      @test.click_element("My Account","UserApp","My Account in Header")
      @test.click_element("Account Info","UserApp>MyAccount","Account Info")
      @test.click_element("Payment info Check","UserApp>MyAccount>AccountInfo","Payment info Check")
      @test.click_element("Update","UserApp>MyAccount>AccountInfo","Update")
      @test.click_element("Your changes have been saved, OK button","UserApp>MyAccount>AccountInfo","our changes have been saved, OK button")

      @test.click_element("Logout","UserApp","Logout")
      @test.click_element("Logout OK","UserApp","Logout OK")
      @test.login_to_admin()
      @test.admin_navigate_to("Search for Customers")
      @test.enter_text("Search for Input Field","User Management>Customers>Search for Customers",userRow["login"],"Search for Input Field #{userRow["login"]}")
      @test.click_element("Search Button","User Management>Customers>Search for Customers","Search button")
      @test.click_on_row_in_table(userRow["email"],"Search for customer results table")
      @test.verify_radio_button_is_selected("Payment Info Check","User Management>Customers>Search for Customers>Customer Card","Payment Info Check")


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


end
