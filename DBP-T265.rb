require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T265 < Test::Unit::TestCase
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

  def test_dbp_t265
    begin
      fullDate = @test.get_date_full_mmddyyyy
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Export products")


      @test.select_dropdown_list_text("Choose Format select","Products>Export products","Ready for import (.csv)","Choosing the 'Ready for import (.csv)'" )
      @test.click_element("Export","Products>Export products","Export")
      @test.check_columns_count("products#{fullDate}.csv",0)
      @test.check_for_file_download("products#{fullDate}.csv",60)
      

      @test.select_dropdown_list_text("Choose Format select","Products>Export products","Simple plain (.xls)","Choosing the 'Simple plain (.xls)'" )
      @test.click_element("Export","Products>Export products","Export")
      @test.check_columns_count("products.xlsx",5)
      @test.check_for_file_download("products.xlsx",60)



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
