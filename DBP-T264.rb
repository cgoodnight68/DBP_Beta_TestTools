require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T264 < Test::Unit::TestCase
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

  def test_import_a_file_with_a_few_products
    begin
       date = @test.get_date(0)
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Import products")
      @test.upload_file("Browse","Products>Import Products",File.expand_path("./DataFiles/DBPInventoryUpdate.csv"),"Browse sending the path to the import file DBPInventoryUpdate.csv")
      @test.click_element("Import","Products>Import Products","Import")
      @test.click_element("Import Started OK","Products>Import Products","OK button on import started")
      sleep(30)
      @test.admin_navigate_to("Edit/Search Products")
      @test.enter_text("Search by keyword","Products>Edit/Search Products","Bacopa","Search by keyword for Bacopa")
      @test.click_element("Search Button","Products>Edit/Search Products","Search Button")
      sleep(5)
      first_row = @test.check_if_element_exists_get_element_text("First row of found products","Products>Edit/Search Products",10,"First row of found products")

      assert(first_row.include?("Bacopa"),"First row does not have Bacopa.  Products were not imported")
      @util.logging("Successfully imported Bacopa")

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
