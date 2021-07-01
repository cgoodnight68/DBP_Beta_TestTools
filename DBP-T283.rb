require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T283 < Test::Unit::TestCase
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

  def test_dbp_t283
    begin
      fullDate = @test.get_date_full()
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Ordered Products Reports")


      @test.select_dropdown_list_text("Routes selector","Reports>Sales Reporting>Ordered Products Reports",1,"Choosing the first route","index" )
      @test.select_dropdown_list_text("Search in select","Reports>Sales Reporting>Ordered Products Reports","Current Week Order","Choosing 'Current Week Order'")
      @test.click_element("Export to Excel","Reports>Sales Reporting>Ordered Products Reports","Export to Excel")
      @test.check_for_file_download("products.xlsx",60)

      @test.select_dropdown_list_text("Search in select","Reports>Sales Reporting>Ordered Products Reports","Custom Date Range","Choosing 'Custom Date Range'")


      ninetyDaysAgo= @test.get_date_x_days_ago(90)
      @test.enter_text("Order Date start","Reports>Sales Reporting>Ordered Products Reports",ninetyDaysAgo,"Order Date start")
      @test.enter_text("Order Date end","Reports>Sales Reporting>Ordered Products Reports",fullDate,"Order Date end")
      @test.click_element("Export to Excel","Reports>Sales Reporting>Ordered Products Reports","Export to Excel")
      
      @test.check_columns_count("products.xlsx",10)
      @test.check_for_file_download("products.xlsx",60)

      @test.click_element("Export to PDF","Reports>Sales Reporting>Ordered Products Reports","Export to PDF")
      dateReversed = @test.get_date_reversed()
      @test.check_for_file_download("Report_product#{dateReversed}.pdf",60)



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
