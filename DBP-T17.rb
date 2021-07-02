require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T17 < Test::Unit::TestCase
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

  def test_dbp_t17
    begin
      date = @test.get_date_full_mmddyyyy()
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Edit/Search Products")
      @test.select_first_five_products_on_product_search()
      @test.click_element("Export","Products>Edit/Search Products","Export")
      
      @test.click_element("Only selected rows radio","Products>Edit/Search Products","Only selected rows radio")
      @test.select_dropdown_list_text("Choose File Type select","Products>Edit/Search Products","Ready for import (.csv)","Selecting file  type of 'Ready for import(.csv)'")
      @test.click_element("Export on export modal","Products>Edit/Search Products","Export on export modal")

      @test.check_columns_count("products#{date}.csv",0)
      @test.check_rows_count("products#{date}.csv",6)
      @test.check_for_file_download("products#{date}.csv",60)

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
