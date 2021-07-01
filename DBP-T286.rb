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
      date = @test.get_date()
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Load Sheet Report")

      @test.select_dropdown_list_text("Route selector","Reports>Product Reporting>Load Sheet Report","All","Selecting '[Select all] for the route")
      sixtyDaysAgo = @test.get_date_x_days_ago(60) 

      @test.enter_text("Date Range start","Reports>Product Reporting>Load Sheet Report",sixtyDaysAgo,"Entering #{sixtyDaysAgo} in Date Range start")
      @test.enter_text("Date Range end","Reports>Product Reporting>Load Sheet Report",date,"Entering #{date} in Date Range end")

      @test.click_element("Export to Excel","Reports>Product Reporting>Load Sheet Report","Export to Excel")

      @test.check_columns_count("load_sheet.xlsx",5)
      @test.check_for_file_download("load_sheet.xlsx",60)


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
