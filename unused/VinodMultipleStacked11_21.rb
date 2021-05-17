require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class Vinod_Multiple_Stacked_11_21 < Test::Unit::TestCase
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

  def test_vinod_multiple_stacked_11_21
    @test.login_to_zenith()
    db_id =  @test.get_db_id
    testIdentifier = "Test#{db_id}"
    # testFilename = "HRUK.TANN7788.20180228.EX.TPA.xlsx"
    # secondTestFilename = "HRUK.TANN7788.20180331.EX.TPA.xlsx"
    # thridTestFileName ="HRUK.TANN7788.20180430.EX.TPA.xlsx"
    # fourthTestFileName ="HRUK.TANN7788.20180531.EX.TPA.xlsx"

    autoSchemaFile = "UAT2a.AS.xlsx"
    destFolder = "1.In"
    entityType = "HRUK"
    fileType = "TANN"
    company = "9999 - Integration Test Company"
    companyId = company[0..3]
     effectiveDate = "01022018"
    # endEffectiveDate = "28022018"
    # dataFileDate = "20180228"
    # schemaFileDate = "20180201"

    # secondEffectiveDate = "01032018"
    # secondEndEffectiveDate = "31032018"
    # secondDataFileDate = "20180331"
    # secondSchemaFileDate = "20180301"

    # thirdEffectiveDate = "01042018"
    # thirdEndEffectiveDate = "30042018"
    # thirdDataFileDate = "20180430"
    # thirdSchemaFileDate = "20180401"

    # fourthEffectiveDate = "01052018"
    # fourthEndEffectiveDate = "31052018"
    # fourthDataFileDate = "20180531"
    # fourthSchemaFileDate = "20180501"


    filesArray = [{"filename" => "UAT2a.xlsx","rplIdentifier" => testIdentifier,"effectiveDate" =>  "01022018","endEffectiveDate" => "28022018","dataFileDate" =>"20180228","schemaFileDate" => "20180201"},
                  {"filename" => "UAT2a.xlsx","rplIdentifier" => "#{testIdentifier}_2ndMonth","effectiveDate" =>  "01032018","endEffectiveDate" => "31032018","dataFileDate" =>"20180331","schemaFileDate" => "20180301"},
                  {"filename" =>"UAT2a.xlsx","rplIdentifier" => "#{testIdentifier}_3rdMonth","effectiveDate" =>  "01042018","endEffectiveDate" => "30042018","dataFileDate" =>"20180430","schemaFileDate" => "20180401"}]
                
    rplId = ""
    rcdbClientLogID = ""

    dateTime =@test.get_date_time("MM_DD_YYYY_HH_mm")
    @test.add_client_file(entityType,fileType,company,testIdentifier,effectiveDate,"Test-#{db_id} - automation test run #{dateTime}")

    sleep(3)
    @test.click_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]","Clicking on a row with the expected fourth qualifier of #{testIdentifier}")
    @test.click_element(:xpath,Utilities.siteMap[:client_files_output_company_criteria_btn],"Clicking on the Output Company Criteria")

    @test.click_element(:xpath,"//span[contains(text(),'UK Extract 2 (DO NOT USE)')]","Selecting the UK Extract 2 (DO NOT USE)")
    @test.click_element(:xpath,Utilities.siteMap[:output_company_criteria_add_btn],"Attaching the 'UK Extract 2 (DO NOT USE)' with the Add button")
    @driver.navigate.back()
    insertedClientFileText = @driver.find_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../..").text
    @util.logging("The inserted row #{testIdentifier} exists and has #{insertedClientFileText}")
    checkValues=["HRUK","TANN","9999","Integration Test Company","#{testIdentifier}","01/02/2018"]
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
    filesArray.each do |file|

      @test.click_element(:xpath,Utilities.siteMap[:workflow_mb],"Workflow Menu")
      @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs],"Reporting Period Logs menu item")

      @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_file_search],companyId,"for Company ID in RPL search")

      @test.click_element(:xpath,"//a[contains(text(),'#{testIdentifier}')]","#{testIdentifier} the search dropdown")
      @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_btn],"Add a Reporting Period Log")
      @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_rpl_name_text],"#{file["rplIdentifier"]}"," for RPL name")
      @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_start_effective_text],"#{file["effectiveDate"]}"," for the Start Effective Date")
      @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_end_effective_text],"#{file["endEffectiveDate"]}"," for the End Effective Date")
      @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_add_btn],"Add button on Add Reporting Period Log")

      @test.put_test_data_files_in_dataconnect_folder(file["filename"],destFolder,entityType,fileType,company,testIdentifier,"#{file["dataFileDate"]}")
      @test.put_test_data_files_in_dataconnect_folder(autoSchemaFile,"5.AutoSchema",entityType,fileType,company,testIdentifier,"#{file["schemaFileDate"]}")

      workflowStatus = @test.get_element_text(:xpath,"//span[contains(text(),'#{file["rplIdentifier"]}')]/../../td[4]/span","Workflow Status of #{file["rplIdentifier"]}")
      rplId = @test.get_rplId(file["rplIdentifier"])

      result = @test.wait_for_expected_workflow_status_with_timing(file["rplIdentifier"],"Ready for Review",120)
      dcResults1 =  @test.get_DC_jobid("p_Main","Test#{db_id}")
      @test.new_email_checker(["job id","RCDB load finished","CDS2 LOAD FINISHED","Ready for Review"],testIdentifier)

       db_tests_array = ["RPL Workflow = Ready for Review","RCDB Annuity Record Count","CDS2 Insured Record Count", "CDS2 Component Record Count", "CDS2 Policy Record Count"]
       countOfRecords = @test.run_back_end_tests(db_tests_array,rplId,1,)
       assert(result)



      @test.right_click_element(:xpath,"//span[contains(text(),'#{file["rplIdentifier"]}')]","Right clicking on a row with the expected RPL name of #{file["rplIdentifier"]}")
      @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{file["rplIdentifier"]} row")

      @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
      @test.click_element(:xpath, "//a[contains(text(),'Load to CDS')]","Event Status Dropdown > Load to CDS")
      @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")
      @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_cds_btn], "Load to CDS button")

      confirmationText = @test.get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]","Confirmation Modal window text")
      @util.logging("Got the message \n #{confirmationText}")
      @test.click_element(:xpath,"//span[contains(text(),'Yes')]", "Yes button on confirmation window")
      result = @test.wait_for_expected_workflow_status_with_timing(file["rplIdentifier"],"Completed",120)
      rcdbClientLogID = @test.get_rcdbclientlogid(rplId)
      dcResults2 = @test.get_DC_jobid("pCDS2_to_CDS",rcdbClientLogID)
      @test.new_email_checker(["job id","Load to CDS completed"],testIdentifier)
      # @test.verify_dc_logs_for_emails_sent(dcResults2,["job id","Load to CDS completed"])
       assert(result)

    countOfCDSRecords = @test.run_back_end_tests(db_tests_array,rplId,1,"Completed")


      @test.right_click_element(:xpath,"//span[contains(text(),'#{file["rplIdentifier"]}')]","Right clicking on a row with the expected RPL name of #{file["rplIdentifier"]}")
      @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{file["rplIdentifier"]} row")
      @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
      @test.click_element(:xpath, "//a[contains(text(),'Load to LRM CDS')]","Event Status Dropdown menu > Load to LRM CDS")
      @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")
      # @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_cds_btn], "Load to CDS button")
      @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_lrm_cds_btn ],"Load to LRM CDS" )

      @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_lrm_cds_modal_load_btn],"Load button")
      result = @test.wait_for_expected_workflow_status_with_timing(file["rplIdentifier"],"LRM CDS Load Success",120)
      @test.new_email_checker(["job id","LRM CDS load success"],testIdentifier)
       #@test.verify_dc_logs_for_emails_sent(dcResults3,["job id","LRM CDS load success"])
      assert(result)

    countOfLRMRecords = @test.run_back_end_tests(db_tests_array,rplId,1,"LRM Load Complete")
      assert(result)
      #set the workflowstatus to LRM load complete through SQl
      @util.logging("Setting the rplId: #{rplId} to LRM Load Complete, through SQL ")
      query = "update zenith.dbo.reportingperiodlog set workflowstatusid =22 where reportingperiodlogid = #{rplId}"
      results = @test.tds_query("Zenith",query)
      result = @test.wait_for_expected_workflow_status(testIdentifier,"LRM Load Complete",10)
      assert(result)
    end
    #    ## second month run
    #     @test.click_element(:xpath,Utilities.siteMap[:workflow_mb],"Workflow Menu")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs],"Reporting Period Logs menu item")

    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_file_search],companyId,"for Company ID in RPL search")

    #    @test.click_element(:xpath,"//a[contains(text(),'#{testIdentifier}')]","#{testIdentifier} the search dropdown")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_btn],"Add a Reporting Period Log")
    #    secondRPLIdentifier = "#{testIdentifier}_2ndmonth"
    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_rpl_name_text],"#{secondRPLIdentifier}"," for RPL name")
    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_start_effective_text],"#{secondEffectiveDate}"," for the Start Effective Date")
    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_end_effective_text],"#{secondEndEffectiveDate}"," for the End Effective Date")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_add_btn],"Add button on Add Reporting Period Log")

    #    @test.put_test_data_files_in_dataconnect_folder(secondTestFilename,destFolder,entityType,fileType,company,testIdentifier,"#{secondDataFileDate}")
    #    @test.put_test_data_files_in_dataconnect_folder(autoSchemaFile,"5.AutoSchema",entityType,fileType,company,testIdentifier,"#{secondSchemaFileDate}")

    #    workflowStatus = @test.get_element_text(:xpath,"//span[contains(text(),'#{secondRPLIdentifier}')]/../../td[4]/span","Workflow Status of #{secondRPLIdentifier}")
    #    rplId = @test.get_rplId(secondRPLIdentifier)

    #     result = @test.wait_for_expected_workflow_status_with_timing(secondRPLIdentifier,"CDS2 Validation Failed",120)
    #    @test.right_click_element(:xpath,"//span[contains(text(),'#{secondRPLIdentifier}')]","Right clicking on a row with the expected RPL name of #{secondRPLIdentifier}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{secondRPLIdentifier} row")
    #     @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
    #    @test.click_element(:xpath, "//a[contains(text(),'Override CDS2 validation')]","Event Status Dropdown > Override CDS2 validation")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")

    #    result = @test.wait_for_expected_workflow_status_with_timing(secondRPLIdentifier,"Ready for Review",120)
    #    assert(result)

    #    db_tests_array = ["RPL Workflow = Ready for Review","CDS2 - O Account Period"]
    #    @test.run_back_end_tests(db_tests_array,rplId,1)


    #    @test.right_click_element(:xpath,"//span[contains(text(),'#{secondRPLIdentifier}')]","Right clicking on a row with the expected RPL name of #{secondRPLIdentifier}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{secondRPLIdentifier} row")

    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
    #    @test.click_element(:xpath, "//a[contains(text(),'Load to CDS')]","Event Status Dropdown > Load to CDS")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_cds_btn], "Load to CDS button")

    #    confirmationText = @test.get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]","Confirmation Modal window text")
    #    @util.logging("Got the message \n #{confirmationText}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Yes')]", "Yes button on confirmation window")
    #    result = @test.wait_for_expected_workflow_status_with_timing(secondRPLIdentifier,"Completed",120)
    #    assert(result)


    #    @test.right_click_element(:xpath,"//span[contains(text(),'#{secondRPLIdentifier}')]","Right clicking on a row with the expected RPL name of #{secondRPLIdentifier}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{secondRPLIdentifier} row")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
    #    @test.click_element(:xpath, "//a[contains(text(),'Load to LRM CDS')]","Event Status Dropdown menu > Load to LRM CDS")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")
    #    # @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_cds_btn], "Load to CDS button")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_lrm_cds_btn ],"Load to LRM CDS" )

    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_lrm_cds_modal_load_btn],"Load button")
    #    result = @test.wait_for_expected_workflow_status_with_timing(secondRPLIdentifier,"LRM CDS Load Success",120)
    #    assert(result)
    # #set the workflowstatus to LRM load complete through SQl
    #    @util.logging("Setting the rplId: #{rplId} to LRM Load Complete, through SQL ")
    #    query = "update zenith.dbo.reportingperiodlog set workflowstatusid =22 where reportingperiodlogid = #{rplId}"
    #    results = @test.tds_query("Zenith",query)
    #    result = @test.wait_for_expected_workflow_status(testIdentifier,"LRM Load Complete",10)
    #    assert(result)
    #    ## third month run
    #    @test.click_element(:xpath,Utilities.siteMap[:workflow_mb],"Workflow Menu")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs],"Reporting Period Logs menu item")

    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_file_search],companyId,"for Company ID in RPL search")

    #    @test.click_element(:xpath,"//a[contains(text(),'#{testIdentifier}')]","#{testIdentifier} the search dropdown")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_btn],"Add a Reporting Period Log")
    #    thirdRPLIdentifier = "#{testIdentifier}_3rdmonth"
    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_rpl_name_text],"#{thirdRPLIdentifier}"," for RPL name")
    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_start_effective_text],"#{thirdEffectiveDate}"," for the Start Effective Date")
    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_end_effective_text],"#{thirdEndEffectiveDate}"," for the End Effective Date")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_add_btn],"Add button on Add Reporting Period Log")

    #    @test.put_test_data_files_in_dataconnect_folder(thirdTestFilename,destFolder,entityType,fileType,company,testIdentifier,"#{thirdDataFileDate}")
    #    @test.put_test_data_files_in_dataconnect_folder(autoSchemaFile,"5.AutoSchema",entityType,fileType,company,testIdentifier,"#{thirdSchemaFileDate}")

    #    workflowStatus = @test.get_element_text(:xpath,"//span[contains(text(),'#{thirdRPLIdentifierr}')]/../../td[4]/span","Workflow Status of #{thirdRPLIdentifier}")
    #    rplId = @test.get_rplId(secondRPLIdentifier)

    #     result = @test.wait_for_expected_workflow_status_with_timing(thirdRPLIdentifier,"CDS2 Validation Failed",120)
    #    @test.right_click_element(:xpath,"//span[contains(text(),'#{thirdRPLIdentifier}')]","Right clicking on a row with the expected RPL name of #{thirdRPLIdentifier}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{thirdRPLIdentifier} row")
    #     @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
    #    @test.click_element(:xpath, "//a[contains(text(),'Override CDS2 validation')]","Event Status Dropdown > Override CDS2 validation")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")

    #    result = @test.wait_for_expected_workflow_status_with_timing(secondRPLIdentifier,"Ready for Review",120)
    #    assert(result)

    #    db_tests_array = ["RPL Workflow = Ready for Review","CDS2 - O Account Period"]
    #    @test.run_back_end_tests(db_tests_array,rplId,1)


    #    @test.right_click_element(:xpath,"//span[contains(text(),'#{thirdRPLIdentifier}')]","Right clicking on a row with the expected RPL name of #{thirdRPLIdentifier}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{thirdRPLIdentifier} row")

    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
    #    @test.click_element(:xpath, "//a[contains(text(),'Load to CDS')]","Event Status Dropdown > Load to CDS")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_cds_btn], "Load to CDS button")

    #    confirmationText = @test.get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]","Confirmation Modal window text")
    #    @util.logging("Got the message \n #{confirmationText}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Yes')]", "Yes button on confirmation window")
    #    result = @test.wait_for_expected_workflow_status_with_timing(thirdRPLIdentifier,"Completed",120)
    #    assert(result)


    #    @test.right_click_element(:xpath,"//span[contains(text(),'#{thirdRPLIdentifier}')]","Right clicking on a row with the expected RPL name of #{thirdRPLIdentifier}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{secondRPLIdentifier} row")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
    #    @test.click_element(:xpath, "//a[contains(text(),'Load to LRM CDS')]","Event Status Dropdown menu > Load to LRM CDS")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")
    #    # @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_cds_btn], "Load to CDS button")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_lrm_cds_btn ],"Load to LRM CDS" )

    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_lrm_cds_modal_load_btn],"Load button")
    #    result = @test.wait_for_expected_workflow_status_with_timing(thirdRPLIdentifier,"LRM CDS Load Success",120)
    #    assert(result)
    # #set the workflowstatus to LRM load complete through SQl
    #    @util.logging("Setting the rplId: #{rplId} to LRM Load Complete, through SQL ")
    #    query = "update zenith.dbo.reportingperiodlog set workflowstatusid =22 where reportingperiodlogid = #{rplId}"
    #    results = @test.tds_query("Zenith",query)
    #    result = @test.wait_for_expected_workflow_status(testIdentifier,"LRM Load Complete",10)
    #    assert(result)
    #   ## fourth month run
    #    @test.click_element(:xpath,Utilities.siteMap[:workflow_mb],"Workflow Menu")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs],"Reporting Period Logs menu item")

    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_file_search],companyId,"for Company ID in RPL search")

    #    @test.click_element(:xpath,"//a[contains(text(),'#{testIdentifier}')]","#{testIdentifier} the search dropdown")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_btn],"Add a Reporting Period Log")
    #    thirdRPLIdentifier = "#{testIdentifier}_4thmonth"
    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_rpl_name_text],"#{fourthRPLIdentifier}"," for RPL name")
    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_start_effective_text],"#{fourthEffectiveDate}"," for the Start Effective Date")
    #    @test.enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_end_effective_text],"#{fourthEndEffectiveDate}"," for the End Effective Date")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_add_btn],"Add button on Add Reporting Period Log")

    #    @test.put_test_data_files_in_dataconnect_folder(thirdTestFilename,destFolder,entityType,fileType,company,testIdentifier,"#{fourthDataFileDate}")
    #    @test.put_test_data_files_in_dataconnect_folder(autoSchemaFile,"5.AutoSchema",entityType,fileType,company,testIdentifier,"#{fourthSchemaFileDate}")

    #    workflowStatus = @test.get_element_text(:xpath,"//span[contains(text(),'#{fourthRPLIdentifierr}')]/../../td[4]/span","Workflow Status of #{fourthRPLIdentifier}")
    #    rplId = @test.get_rplId(secondRPLIdentifier)

    #     result = @test.wait_for_expected_workflow_status_with_timing(fourthRPLIdentifier,"CDS2 Validation Failed",120)
    #    @test.right_click_element(:xpath,"//span[contains(text(),'#{fourthRPLIdentifier}')]","Right clicking on a row with the expected RPL name of #{fourthRPLIdentifier}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{fourthRPLIdentifier} row")
    #     @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
    #    @test.click_element(:xpath, "//a[contains(text(),'Override CDS2 validation')]","Event Status Dropdown > Override CDS2 validation")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")

    #    result = @test.wait_for_expected_workflow_status_with_timing(fourthRPLIdentifier,"Ready for Review",120)
    #    assert(result)

    #    db_tests_array = ["RPL Workflow = Ready for Review","CDS2 - O Account Period"]
    #    @test.run_back_end_tests(db_tests_array,rplId,1)


    #    @test.right_click_element(:xpath,"//span[contains(text(),'#{fourthRPLIdentifier}')]","Right clicking on a row with the expected RPL name of #{fourthRPLIdentifier}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{fourthRPLIdentifier} row")

    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
    #    @test.click_element(:xpath, "//a[contains(text(),'Load to CDS')]","Event Status Dropdown > Load to CDS")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_cds_btn], "Load to CDS button")

    #    confirmationText = @test.get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]","Confirmation Modal window text")
    #    @util.logging("Got the message \n #{confirmationText}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Yes')]", "Yes button on confirmation window")
    #    result = @test.wait_for_expected_workflow_status_with_timing(fourthRPLIdentifier,"Completed",120)
    #    assert(result)


    #    @test.right_click_element(:xpath,"//span[contains(text(),'#{fourthRPLIdentifier}')]","Right clicking on a row with the expected RPL name of #{fourthRPLIdentifier}")
    #    @test.click_element(:xpath,"//span[contains(text(),'Edit')]","Edit in right click menu for #{fourthRPLIdentifier} row")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_event_status_dropdwn],"Event Status Drop Down")
    #    @test.click_element(:xpath, "//a[contains(text(),'Load to LRM CDS')]","Event Status Dropdown menu > Load to LRM CDS")
    #    @test.click_element(:xpath, Utilities.siteMap[:reporting_period_logs_add_save_btn],"Save button")
    #    # @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_cds_btn], "Load to CDS button")
    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_lrm_cds_btn ],"Load to LRM CDS" )

    #    @test.click_element(:xpath,Utilities.siteMap[:reporting_period_logs_load_to_lrm_cds_modal_load_btn],"Load button")
    #    result = @test.wait_for_expected_workflow_status_with_timing(fourthRPLIdentifier,"LRM CDS Load Success",120)
    #    assert(result)
    # #set the workflowstatus to LRM load complete through SQl
    #    @util.logging("Setting the rplId: #{rplId} to LRM Load Complete, through SQL ")
    #    query = "update zenith.dbo.reportingperiodlog set workflowstatusid =22 where reportingperiodlogid = #{rplId}"
    #    results = @test.tds_query("Zenith",query)
    #    result = @test.wait_for_expected_workflow_status(testIdentifier,"LRM Load Complete",10)
    #    assert(result)



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
