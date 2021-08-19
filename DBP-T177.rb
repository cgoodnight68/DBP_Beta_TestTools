require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T177 < Test::Unit::TestCase
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

  def test_user_place_order_verify_in_admin
    begin
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Search for Customers")
      userRow = @test.login_as_random_customer_from_backend_with_upcoming_orders()
      @test.goto_url("#{@base_url}/summary.php?go=products&12")
      productDescription = @test.select_random_item_from_shop_page(1,"Next Week")
      @test.login_to_admin
      @test.admin_navigate_to("Search for Customers")
      @test.enter_text("Search for Input Field","User Management>Customers>Search for Customers",userRow["login"],"Search for Input Field #{userRow["login"]}")
      @test.click_element("Search Button","User Management>Customers>Search for Customers","Search button")
      @test.click_on_row_in_table(userRow["email"],"Search for customer results table")
      allOrdersText = @test.get_all_upcoming_orders_on_all_routes()
      assert(allOrdersText.include?(productDescription),"The expected product #{productDescription} does not exist in #{allOrdersText}")
   
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
