require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T284 < Test::Unit::TestCase
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

  def test_dbp_t284
    begin
      fullDate = @test.get_date_full()
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Taxes Report")
      #@test.select_dropdown_list_text("Route selector","Reports>Financials Reporting>Taxes Report",1,"Choosing the first route","index" )
      ninetyDaysAgo= @test.get_date_x_days_ago(90)
      @test.enter_text("Date Range start","Reports>Financials Reporting>Taxes Report",ninetyDaysAgo,"Date Range start")
      @test.enter_text("Date Range end","Reports>Financials Reporting>Taxes Report",fullDate,"Date Range end")
      @test.click_element("Submit","Reports>Financials Reporting>Taxes Report","Submit")
      sleep(10)
      @test.check_if_element_exists_get_element_text("Report Results","Reports>Financials Reporting>Taxes Report",120,"Report Results")
      @test.click_element("Export to Excel","Reports>Financials Reporting>Taxes Report","Export to Excel")
      @test.check_for_file_download("taxes.xls",60)
      @test.click_element("Export to PDF","Reports>Financials Reporting>Taxes Report","Export to PDF")
      dateReversed = @test.get_date_reversed()
      @test.check_for_file_download("Report_taxes#{dateReversed}.pdf",60)

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
