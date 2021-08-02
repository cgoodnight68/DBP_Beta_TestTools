require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T247 < Test::Unit::TestCase
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

  def test_add_test_membership_level
    begin
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Edit/Create Membership Levels")
      date = @test.get_date(0)
      @test.enter_text("New Customer Membership Level","User Management>Customers>Edit/Create Membership Levels","Membership #{date}","New Customer Membership Level entering Membership #{date} ")
      @test.click_element("Create","User Management>Customers>Edit/Create Membership Levels","Create")
      @driver.navigate().refresh()
      @test.click_element_ignore_failure(:css,"#dashboard_link")
      @driver.navigate().refresh()
      @test.admin_navigate_to("Search for Customers")
      userRow = @test.search_for_customer("C")
      @test.select_dropdown_list_text("Membership selector","User Management>Customers>Search for Customers>Customer Card","Membership #{date}", "Selecting Membership #{date} from Membership selector")
      @test.click_element("Save customer card","User Management>Customers>Search for Customers>Customer Card","Save customer card")
      @driver.navigate().refresh()
      @test.click_element_ignore_failure(:css,"#dashboard_link")
      @driver.navigate().refresh()
      @driver.navigate().refresh()
      @test.admin_navigate_to("Edit/Create Membership Levels")
      @test.select_checkbox_in_row_with_value3("Membership #{date}")
      @test.click_element("Delete Selected","User Management>Customers>Edit/Create Membership Levels","Delete Selected")



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
