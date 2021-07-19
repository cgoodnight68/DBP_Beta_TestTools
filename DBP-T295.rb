require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T295 < Test::Unit::TestCase
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

  def test_user_place_order_recurring_verify_in_admin
    begin
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Search for Customers")
      userRow = @test.login_as_random_customer_from_backend_with_upcoming_orders()
      @test.goto_url("#{@base_url}/summary.php?go=products&12")
      productDescription = @test.select_random_item_from_shop_page(1,"Weekly")

      @test.login_to_admin
      @test.admin_navigate_to("Search for Customers")
      @test.enter_text("Search for Input Field","User Management>Customers>Search for Customers",userRow["login"],"Search for Input Field #{userRow["login"]}")
      @test.click_element("Search Button","User Management>Customers>Search for Customers","Search button")
      @test.click_on_row_in_table(userRow["email"],"Search for customer results table")
      @test.click_element("Upcoming Orders Tab","User Management>Customers>Search for Customers>Customer Card","Upcoming Orders Tab")
   
      ordersText = @test.check_if_element_exists_get_element_text("Upcoming Orders table","User Management>Customers>Search for Customers>Customer Card",10,"Upcoming Orders table")

   assert(ordersText.include?(productDescription),"The expected product #{productDescription} does not exist in #{ordersText}")
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
