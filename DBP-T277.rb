require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T277< Test::Unit::TestCase
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

  def test_dbp_t277

    @test.load_admin_navigation_elements
    @test.login_to_admin
    @test.admin_navigate_to("Manage KML File")
    
    @test.check_if_element_exists("Browse","Route Management> Manage KML File",10,"Browse")
    @test.check_if_element_exists("Update","Route Management> Manage KML File",10,"Update")
    @test.check_if_element_exists_get_element_text("Last Uploaded On","Route Management> Manage KML File",10,"Last Upload On")

    @test.kml_map_verification()
    

 


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


