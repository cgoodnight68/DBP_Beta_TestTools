require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T193< Test::Unit::TestCase
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

  def test_dbp_t193
    leavingDate = @test.get_date(-7)
    returningDate = @test.get_date(-12)

    @test.load_admin_navigation_elements
    @test.login_to_admin
    @test.admin_navigate_to("Search for Customers")
    userRow = @test.login_as_random_customer_from_backend_with_upcoming_orders()
    #username,password = @test.get_default_user_for_day
    #@test.login_as_customer(username,password)

    @test.click_element("My Account","UserApp","My Account in Header")


    @test.click_element("Delivery Hold","UserApp>MyAccount","Delivery Hold")
    
    @test.enter_text("Leaving","UserApp>MyAccount>DeliveryHolds","#{leavingDate}\n","Leaving on #{leavingDate}")

    @test.enter_text("Returning","UserApp>MyAccount>DeliveryHolds","#{returningDate}\n","Returning #{returningDate}")

    @test.click_element("Add Vacation","UserApp>MyAccount>DeliveryHolds","Add Vacation")


    @test.login_to_admin()
    @test.admin_navigate_to("Search for Customers")
    @test.enter_text("Search for Input Field","User Management>Customers>Search for Customers",userRow["login"],"Search for Input Field #{userRow["login"]}")
    @test.click_element("Search Button","User Management>Customers>Search for Customers","Search button")
    @test.click_on_row_in_table(userRow["email"],"Search for customer results table")
    @test.wait_for_element("Vacation Start","User Management>Customers>Search for Customers>Customer Card","Vacation Start input")
    prettyLeavingDate = @test.get_date_dayname_dd_abr_mo_yyyy(-7)
    prettyReturningDate = @test.get_date_dayname_dd_abr_mo_yyyy(-12)
 

    @test.verify_element_from_elements_with_text_or_value("Vacation Leaving row","User Management>Customers>Search for Customers>Customer Card",prettyLeavingDate,"Searching Vacation Leaving for #{prettyLeavingDate}")
    @test.verify_element_from_elements_with_text_or_value("Vacation Returning row","User Management>Customers>Search for Customers>Customer Card",prettyReturningDate,"Searching Vacation Returning for #{prettyReturningDate}")




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
