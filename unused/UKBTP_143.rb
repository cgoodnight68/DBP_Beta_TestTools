require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class UAT4a_LRM_CDS_Load_Success < Test::Unit::TestCase
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

  def test_uat4a_lrm_cds_load_success
    @test.login_to_zenith()
    db_id =  @test.get_db_id
    testIdentifier = "Test#{db_id}"
    testFilename = "UKBTP-143.xlsx"
    autoSchemaFile = "UAT2a.AS.xlsx"
    destFolder = "1.In"
    entityType = "HRUK"
    fileType = "TANN"
    company = "9999 - Integration Test Company"
    companyId = company[0..3]
    effectiveDate = "01012017"
    rplId = ""
    rcdbClientLogId = ""

    dateTime =@test.get_date_time("MM_DD_YYYY_HH_mm")
    @test.add_client_file(entityType,fileType,company,testIdentifier,effectiveDate,"Test-#{db_id} - automation test run #{dateTime}")

    sleep(3)
    @test.click_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]","Clicking on a row with the expected fourth qualifier of #{testIdentifier}")
    @test.click_element(:xpath,Utilities.siteMap[:client_files_output_company_criteria_btn],"Clicking on the Output Company Criteria")

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

    @test.click_element(:xpath,Utilities.siteMap[:workflow_mb],"Workflow Menu")
    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs],"Reporting Period Logs menu item")

    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_file_search],companyId,"for Company ID in RPL search")

    @test.click_element(:xpath,"//a[contains(text(),'#{testIdentifier}')]","#{testIdentifier} the search dropdown")
    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_btn],"Add a Reporting Period Log")
    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_rpl_name_text],"#{testIdentifier}"," for RPL name")
    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_start_effective_text],"#{effectiveDate}"," for the Start Effective Date")
    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_end_effective_text],@test.datecleaner("31012017")," for the End Effective Date")
    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_add_btn],"Add button on Add Reporting Period Log")

    @test.put_test_data_files_in_dataconnect_folder(testFilename,destFolder,entityType,fileType,company,testIdentifier,"20170131")
    @test.put_test_data_files_in_dataconnect_folder(autoSchemaFile,"5.AutoSchema",entityType,fileType,company,testIdentifier,"20170101")
    workflowStatus = @test.get_element_text(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow Status of #{testIdentifier}")
    rplId = @test.get_rplId(testIdentifier)

    result = @test.wait_for_expected_workflow_status(testIdentifier,"Ready for Review",10)
    assert(result)

    db_tests_array = ["RPL Workflow = Ready for Review","CDS2 - O Account Period"]
    @test.run_back_end_tests(db_tests_array,rplId,1)


    @test.right_click_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]","Right clicking on a row with the expected RPL name of #{testIdentifier}")
    @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{testIdentifier} row")

    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
    @test.click_element(:xpath, "//a[contains(text(),'Load to CDS')]","Event Status Dropdown > Load to CDS")
    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")
    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_cds_btn], "Load to CDS button")

    confirmationText = @test.get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]","Confirmation Modal window text")
    @util.logging("Got the message \n #{confirmationText}")
    @test.click_element(:xpath,"//span[contains(text(),'Yes')]", "Yes button on confirmation window")
    result = @test.wait_for_expected_workflow_status(testIdentifier,"Completed",10)
    assert(result)

    @test.right_click_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]","Right clicking on a row with the expected RPL name of #{testIdentifier}")
    @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{testIdentifier} row")
    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
    @test.click_element(:xpath, "//a[contains(text(),'Load to LRM CDS')]","Event Status Dropdown menu > Load to LRM CDS")
    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")
    # @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_cds_btn], "Load to CDS button")
    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_lrm_cds_btn ],"Load to LRM CDS" )

    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_lrm_cds_modal_load_btn],"Load button")
    result = @test.wait_for_expected_workflow_status(testIdentifier,"LRM CDS Load Success",10)
    assert(result)


 


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
