require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T272 < Test::Unit::TestCase
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

  def test_change_route
    begin
      @test.load_admin_navigation_elements
      @test.login_to_admin

      @test.admin_navigate_to("Search for Customers")
      userRow = @test.search_for_customer("C")
      routesBefore = @test.check_if_element_exists_get_element_text("Assigned Routes Table","User Management>Customers>Search for Customers>Customer Card",10,"Assigned Routes Table")
      @test.admin_navigate_to("Change/Assign Routes")
      @test.enter_text("Search by name/address","Route Management>Change/Assign Routes",userRow["lastname"],"Search by name/address")
      @test.click_element("Search","Route Management>Change/Assign Routes","Search")
      @test.select_checkbox_in_row_with_value2(userRow["lastname"])
      @test.select_dropdown_list_text("Change or Assign Routes selectors","Route Management>Change/Assign Routes","Assign to a New Route (in addition to any existing routes)","Change or Assign Routes selectors")
      @test.click_element("The action will assign OK","Route Management>Change/Assign Routes","The action will assign OK")
      @test.select_dropdown_list_text("Assign to a Route","Route Management>Change/Assign Routes",1,"Assign to a Route 1","index")
      @test.click_element("Submit","Route Management>Change/Assign Routes","Submit")
      @test.click_element("Are you sure ok","Route Management>Change/Assign Routes"," Routes  Are you sure ok")
      @test.click_element("The action will assign OK","Route Management>Change/Assign Routes","Operation Completed OK")
      @test.admin_navigate_to("Search for Customers")
      @test.enter_text("Search for Input Field","User Management>Customers>Search for Customers","#{userRow["login"]}","Search for Customer: #{userRow["login"]}")
      @test.click_element("Search Button","User Management>Customers>Search for Customers","Search Button")
      @test.click_element(:xpath,"//p[contains(text(),'#{userRow["email"]}')]/a", "Clicking on results table full name and email column  on row with #{userRow["email"]}")
      routesAfter = @test.check_if_element_exists_get_element_text("Assigned Routes Table","User Management>Customers>Search for Customers>Customer Card",10,"Assigned Routes Table")

      assert(routesAfter != routesBefore,"The route was not added to the user")
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
