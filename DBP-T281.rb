require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T281 < Test::Unit::TestCase
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

  def test_dbp_t281
    begin
      fullDate = @test.get_date_full()
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Print Bag Labels")
      @test.select_dropdown_list_text("Choose a route selector","Route Management>Print Bag Labels",1,"Choosing the first route","index" )
      @test.click_element("Show","Route Management>Print Bag Labels","Show button")
      route = @test.verify_print_route_sheets_show_return_route_name()
      @test.click_element("Export to Excel","Route Management>Print Bag Labels","Export to Excel")
      @test.check_for_file_download("Route Sheets #{fullDate}.xlsx",60)
      @test.click_element("Export to CSV","Route Management>Print Bag Labels","Export to CSV")
      @test.check_for_file_download("Route Sheets #{fullDate}.csv",60)
      @test.click_element("Download PDF","Route Management>Print Bag Labels","Download PDF")
      pdfRoute = route.downcase.gsub(':','').gsub(',','').gsub('-','').gsub('(','').gsub(')','_').gsub(' ','_')
      @test.check_for_file_download("#{pdfRoute}.pdf",60)
      @test.click_element("Print Bag Labels","Route Management>Print Bag Labels","Print Bag Labels")
      bagLabelsRoute =route.upcase.gsub(':','').gsub(',','').gsub('-','').gsub('(','').gsub(')','_').gsub(' ','_')
      @test.check_for_file_download("Bag_Labels_#{bagLabelsRoute}.pdf",60)
      @test.click_element("Print/Export to PDF multiple Bag Labels","Route Management>Print Bag Labels","Print/Export to PDF multiple Bag Labels Tab" )
      @test.select_dropdown_list_text("Choose a route select on print/export pdf tab","Route Management>Print Bag Labels",1,"Choosing route 1" ,"index")
      @test.select_dropdown_list_text("Choose a route select on print/export pdf tab","Route Management>Print Bag Labels",2,"Choosing route 2" ,"index")
      #@test.choose_a_route_multiselect()

      @test.click_element("Export PDF button on Multiple bag labels tab","Route Management>Print Bag Labels","Export PDF button on Multiple bag labels tab")
      @test.click_element("Ok on file generation modal","Route Management>Print Bag Labels","Ok on file generation modal")
      sleep(5)
      @test.wait_for_element("File List Table first row","Route Management>Print Bag Labels","File List Table first row",120)
      @test.check_if_element_exists_get_element_text("File List Table first row","Route Management>Print Bag Labels",120,"File List Table first row exists")

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
