require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T244 < Test::Unit::TestCase
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

  def test_import_5_customers
    begin
       date = @test.get_date(0)
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Import Customers")
      @test.upload_file("Choose File","User Management>Customers>Import Customers",File.expand_path("./DataFiles/ImportUsers.csv"),"Choose File sending the path to /DataFiles/ImportUsers.csv")
      @test.click_element("Import","User Management>Customers>Import Customers","Import")
      @test.accept_alert()
      sleep(5)
      @test.hack_for_resetting_the_navigation()
      sleep(10)
      @test.admin_navigate_to("Search for Customers")
      @test.enter_text("Search for Input Field","User Management>Customers>Search for Customers","testy9","Search by keyword for testy9")
      @test.click_element("Search Button","User Management>Customers>Search for Customers","Search Button")
      sleep(5)
      first_row = @test.check_if_element_exists_get_element_text("First row of found users","User Management>Customers>Search for Customers",10,"First row of found users")

      assert(first_row.include?("testytesterson9@mailinator.com"),"First row does not have testytesterson9@mailinator.com. Users were not imported")
      @util.logging("Successfully imported testy9  email =testytesterson9@mailinator.com")

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
