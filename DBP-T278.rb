require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T278< Test::Unit::TestCase
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

  def test_display_route_kml_issues

    @test.load_admin_navigation_elements
    @test.login_to_admin
    @test.admin_navigate_to("Display Route/KML Issues")

    areasInKmlNotInDbp = @test.check_if_element_exists_get_element_text("Areas in KML but not found in DBP","Route Management>Display Route-KML Issues",10,"Areas in KML but not found in DBP")
    areasInDbpNotInKml = @test.check_if_element_exists_get_element_text("Areas in DBP but not found in KML","Route Management>Display Route-KML Issues",10,"Areas in DBP but not found in KML")
    routesWithoutAreas = @test.check_if_element_exists_get_element_text("Routes without Area names assigned","Route Management>Display Route-KML Issues",10,"Routes without Area names assigned")

    if (areasInKmlNotInDbp.count('\n') >1)
      @test.check_override("warn","There are  errors in Area in KML but not found in DBP",false)
    end
    if (areasInDbpNotInKml.count('\n') >1)
      @test.check_override("warn","There are errors in Area in DBP but not found in KML",false)
    end
    if (routesWithoutAreas.count('\n') >1)
      @test.check_override("warn","There are  errors routes without areas",false)
    end



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
