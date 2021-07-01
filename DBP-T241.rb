require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T241 < Test::Unit::TestCase
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

  def test_dbp_t241
    begin
      date = @test.get_date_full_mmddyyyy()
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Search for Customers")
      @test.select_five_random_users_on_customer_search()
      @test.select_dropdown_list_text("Export type select","User Management>Customers>Search for Customers","Export to (.csv)","Selecting export type of 'Export to (.csv)'")
      @test.click_element("Export","User Management>Customers>Search for Customers","Export")

      @test.check_columns_count("customers_#{date}.csv",39)
      @test.check_for_file_download("customers_#{date}.csv",60)

      @test.select_dropdown_list_text("Export type select","User Management>Customers>Search for Customers","Export to (.xls)","Selecting export type of 'Export to (.xls)'")
      @test.click_element("Export","User Management>Customers>Search for Customers","Export")

      @test.check_for_file_download("customers_#{date}",60)
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
