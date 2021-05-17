require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class BasicLoginTest < Test::Unit::TestCase
  def setup
    @test=Utilities.new
    filedir = File.expand_path File.dirname(__FILE__)
    filebase =  File.basename(__FILE__)
    @test.setup_tasks(filedir , filebase)
    @@g_base_dir, @util, @@environment, @driver, @base_url,@@brws,@@filedir=@test.get_globals

  end

  def teardown
     @test.check_for_toaster_error_messages
         @test.teardown_tasks(passed?)
         assert_equal nil, @verification_errors
  end

  def test_basic_login
    @test.login_to_zenith()
    db_id =  @test.get_db_id
    testIdentifier = "Test-#{db_id}"
    dateTime =@test.get_date_time("MM_DD_YYYY_HH_mm")
    @test.add_client_file("HRUK","TANN","9999 - Integration Test Company",testIdentifier,"01012017","Test-#{db_id} - automation test run #{dateTime}")

    sleep(3)
    @test.click_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]","Clicking on a row with the expected fourth qualifier")
    @test.click_element(:xpath,Utilities.siteMap[:client_files_output_company_criteria_btn],"Clicking on the Output Company Criteria")

    # @test.enter_text(:xpath,"//span[contains(text(),'Output Company Criteria Name')]/../input","Integration Testing OCC")
    @test.click_element(:xpath,"//span[contains(text(),'Integration Testing OCC')]","Selecting the Integration Testing OCC")
    @test.click_element(:xpath,Utilities.siteMap[:output_company_criteria_add_btn],"Attaching the 'Integration Testing OCC' with the Add button")
    @driver.navigate.back()
    insertedClientFileText = @driver.find_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../..").text
    @util.logging("The inserted row #{testIdentifier} exists and has #{insertedClientFileText}")
    checkValues=["HRUK","TANN","9999","Integration Test Company","#{testIdentifier}","01/01/2017"]
    checkValues.each do |checkValue|
      if  ((insertedClientFileText.include? "#{checkValue}") != true)
        errorMsg ="Row #{testIdentifier} does not have #{checkValue}"
        @util.logging(errorMsg)
        @test.check_override(true,errorMsg,false)
      elsif
        @util.logging("Row #{testIdentifier} has #{checkValue}")
      end
    end

    outputCompanySql = @driver.find_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[8]/span/span/i")
    if outputCompanySql.style("visibility") != "visible"
      errorMsg ="Row #{testIdentifier} does not have Output Company Sql set"
      @util.logging(errorMsg)
      @test.check_override(true,errorMsg,false)
    elsif
      @util.logging("Row #{testIdentifier} has Output Company Sql set")
    end



    #  @test.right_click_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]","Right clicking on a row with the expected fourth qualifier")
    #  @test.click_element(:xpath,"//span[contains(text(),'Delete')]","Clicking on the Delete menu item")
    #binding.pry

    #@test.click_element(:xpath,"//button[contains(text(),'Add')]","Add button in new client file add screen")


    #binding.pry

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
