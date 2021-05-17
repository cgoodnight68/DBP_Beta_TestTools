require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class UAT2_ReadyForReview < Test::Unit::TestCase
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

  def test_uat2_ready_for_review
    @test.login_to_zenith()
    db_id =  @test.get_db_id
    testIdentifier = "Test#{db_id}"
    testFilename = "HRUK.TANN7788.20180228.EX.TPA.xlsx"
    autoSchemaFile = "UAT2a.AS.xlsx"
    destFolder = "1.In"
    entityType = "HRUK"
    fileType = "TANN"
    company = "9999 - Integration Test Company"
    companyId = company[0..3]
    effectiveDate = "01012017"
    rplId = ""
    rcdbClientLogId = ""
    rowsInXlsxFile =11
    expectedCDS2InsuredRecordCount = 11
    expectedCDS2ComponentRecordCount =15
    expectedCDS2PolicyRecordCount = 11

    dateTime =@test.get_date_time("MM_DD_YYYY_HH_mm")
    @test.add_client_file(entityType,fileType,company,testIdentifier,effectiveDate,"Test-#{db_id} - automation test run #{dateTime}")

    sleep(3)
    @test.click_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]","Clicking on a row with the expected fourth qualifier of #{testIdentifier}")
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
    rplId = @test.get_rplId(testIdentifier)
    result = @test.wait_for_expected_workflow_status(testIdentifier,"Ready for Review",120)
    assert(result)


    db_tests_array = ["RPL Workflow = Ready for Review","CDS2 - O Account Period"]
    countOfRecords = @test.run_back_end_tests(db_tests_array,rplId,1,"Ready for Review")

  if countOfRecords["RCDB Annuity Record Count"].to_i != rowsInXlsxFile
    errorMsg ="The source xlsx file has #{rowsInXlsxFile} records but there are #{countOfRecords["RCDB Annuity Record Count"]} in the RCdB : rplID = #{rplId}"
      @util.logging(errorMsg)
      @test.check_override(true,errorMsg,false)
    elsif
      @util.logging("The #{rowsInXlsxFile} records in the source file  match the rows inserted #{countOfRecords["RCDB Annuity Record Count"]} in RCdB ")
    end
    if countOfRecords["CDS2 Insured Record Count"].to_i != expectedCDS2InsuredRecordCount
    errorMsg ="Expected #{expectedCDS2InsuredRecordCount} records but there are #{countOfRecords["CDS2 Insured Record Count"]} in CDS2 for CDS2 Insured Record Count : rplID = #{rplId}"
      @util.logging(errorMsg)
      @test.check_override(true,errorMsg,false)
    elsif
      @util.logging("The rows inserted #{countOfRecords["CDS2 Insured Record Count"]} in the CDS2 match the expected count for CDS2 Insured Record Count")
    end
     if countOfRecords["CDS2 Component Record Count"].to_i != expectedCDS2ComponentRecordCount
    errorMsg ="Expected #{expectedCDS2ComponentRecordCount} records but there are #{countOfRecords["CDS2 Component Record Count"]} in CDS2 for CDS2 Component Record Count : rplID = #{rplId}"
      @util.logging(errorMsg)
      @test.check_override(true,errorMsg,false)
    elsif
      @util.logging("The rows inserted #{countOfRecords["CDS2 Component Record Count"]} in the CDS2 match the expected count for CDS2 Component Record Count")
    end
     if countOfRecords["CDS2 Policy Record Count"].to_i != expectedCDS2PolicyRecordCount
    errorMsg ="Expected #{expectedCDS2InsuredRecordCount} records but there are #{countOfRecords["CDS2 Policy Record Count"]} in CDS2 for CDS2 Policy Record Count: rplID = #{rplId}"
      @util.logging(errorMsg)
      @test.check_override(true,errorMsg,false)
    elsif
      @util.logging("The rows inserted #{countOfRecords["CDS2 Policy Record Count"]} in the CDS2 match the expected count for CDS2 Policy Record Count")
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
