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
    @test.go_to_client_files()
    @test.click_element(:xpath,"//button[contains(text(),'Add')]","Add button on Client Files")
    @test.click_element(:xpath,"//span[@id='entity_ct_fb']","Dropdown for the Entity Type")
    @test.click_element(:xpath,"//a[contains(text(),'HRUK')]","Selecting HRUK from the Entity Type")

    @test.click_element(:xpath,"//span[@id='fileType_ct_fb']","Dropdown for the File Type")
    @test.click_element(:xpath,"//a[contains(text(),'TANN')]","Selecting TANN from the File Type")

    #@test.enter_text(:xpath,"//input[@id='fileType_ct']","TANN","Enter the FileType")
    @test.enter_text(:xpath,"//input[@id='company_ct']","9999","Enter Company")
     @test.click_element(:xpath,"//a[contains(text(),'9999 - Integration Test Company')]","Selecting 9999 - Integration Test Company from the Company")

    db_id =  @test.get_db_id
    testIdentifier = "Test-#{db_id}"
    @test.enter_text(:xpath,"//input[@id='qualifier_ct']","#{testIdentifier}","Enter Fourth Qualifier")
    @test.enter_text(:xpath,"//input[@id='effectiveDate_ct']","01012017","Enter Effective Date")
    time = Time.new
    dateTime = "#{time.month}_#{time.day}_#{time.year}_#{time.hour}_#{time.min}"
    #@test.enter_text(:xpath,"//textarea[@id='comments_ct']","#{testIdentifier} - automation test run #{dateTime} ","Entering a comment")
     @test.enter_text(:xpath,"//textarea[@id='comments_ct']","Test-#{db_id} - automation test run #{dateTime}\ue004 ","Entering a comment")
  
     sleep(1)
    @util.logging("Hack for adding the client file, since the object is obscured, sending enter on the modal page")
    @driver.action.send_keys("\ue007").perform
    
sleep(3)
    @test.click_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]","Clicking on a row with the expected fourth qualifier")
    @test.click_element(:xpath,"//button[contains(text(),'Output Company Criteria')]","Clicking on the Output Company Criteria")
   # @test.enter_text(:xpath,"//span[contains(text(),'Output Company Criteria Name')]/../input","Integration Testing OCC")
   @test.click_element(:xpath,"//span[contains(text(),'Integration Testing OCC')]","Selecting the Integration Testing OCC")
   @test.click_element(:xpath,"//button[contains(text(),'Attach')]","Attaching the 'Integration Testing OCC'")
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


    binding.pry

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
