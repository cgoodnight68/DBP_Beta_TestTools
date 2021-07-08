require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T285 < Test::Unit::TestCase
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

  def test_dbp_t285
    begin
      fullDate = @test.get_date_full()
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Bagged Items Report")
      
      @test.click_element("Search Bagged Items","Reports>Product Reporting>Bagged Items Report","Search Bagged Items")
      sleep(10)
      @test.check_if_element_exists_get_element_text("Search Result","Reports>Product Reporting>Bagged Items Report",120,"Verifying Seach Result")
      @test.click_element("Export to Excel","Reports>Product Reporting>Bagged Items Report","Export to Excel")
      @test.check_columns_count("Bagged items report.xlsx",0)
      @test.check_for_file_download("Bagged items report.xlsx",60)
      @test.click_element("Export to PDF","Reports>Product Reporting>Bagged Items Report","Export to PDF")
      dateReversed = @test.get_date_reversed()
      @test.check_for_file_download("Report_bagged_items#{dateReversed}.pdf",60)

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
