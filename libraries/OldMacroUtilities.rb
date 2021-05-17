class Utilities;

  @siteMap = {
    ###Client_files page
    :zenith_mappings_mb =>"//li[@id='navMapMenu']",
    :client_files => "//a[contains(text(),'Client Files')]",
    :client_files_add_btn => "//button[contains(text(),'Add')]",
    :client_files_entity_type_dropdwn => "//span[@id='entity_ct_fb']",
    :client_files_file_type_dropdwn => "//span[@id='fileType_ct_fb']",
    :client_files_company_srch => "//input[@id='company_ct']",
    :client_files_fourth_qualifier_txt => "//input[@id='qualifier_ct']",
    :client_files_effective_date_txt => "//input[@id='effectiveDate_ct']",
    :client_files_comment_txt => "//textarea[@id='comments_ct']",
    :client_files_output_company_criteria_btn => "//button[contains(text(),'Output Company Criteria')]",
    :output_company_criteria_add_btn => "//button[contains(text(),'Attach')]",
    :output_company_criteria_detach_btn => "//button[contains(text(),'Detach')]",
    :lookup => "//a[contains(text(),'Lookup')]",
    :output_company_criteria => "//a[contains(text(),'Output Company Criteria')]",
    :output_company_criteria_output_criteria_search => "//span[contains(text(),'Output Criteria')]/../input",
    :column_definitions => "//a[contains(text(),'Column Definitions')]",
    :company => "//a[@id='navBizCompany']",
    :entity => "//a[contains(text(),'Entity')]",
    :standard_output_codes => "//a[contains(text(),'Standard Output Codes')]",
    :validation_rules => "//a[contains(text(),'Validation Rules')]",
    :data_types => "//a[contains(text(),'Data Types')]",
    :database_tables => "//a[contains(text(),'Database Tables')]",
    :event_status => "//a[contains(text(),'Event Status')]",
    :operators => "//a[contains(text(),'Operators')]",
    :target_databases => "//a[contains(text(),'Target Databases')]",
    :workflow_status => "//a[contains(text(),'Workflow Status')]",
    :settings => "//a[contains(text(),'Settings')]",
    :reporting_period_logs => "//a[contains(text(),'Reporting Period Logs')]",
    :reporting_period_logs_file_search => "//input[@id='fileSearch_ct']",
    :reporting_period_logs_add_btn => "//button[contains(text(),'Add')]",
    :reporting_period_logs_load_to_cds_btn => "//button[contains(text(),'Load to CDS')]",
    :reporting_period_logs_load_to_lrm_cds_btn => "//button[contains(text(),'Load To LRM CDS')]",
    :reporting_period_logs_load_to_lrm_dta_btn => "//button[contains(text(),'Load to LRM DTA')]",
    :reporting_period_logs_purge_btn => "//button[contains(text(),'Purge')]",
    :reporting_period_logs_load_to_lrm_cds_modal_load_btn => "//div[@class='modal-footer']/div/button[contains(text(),' Load')]",
    :reporting_period_logs_add_rpl_name_text => "//label[contains(text(),'RPL Name')]/../input",
    :reporting_period_logs_add_start_effective_text => "//label[contains(text(),'Start Effective Date')]/../input",
    :reporting_period_logs_add_end_effective_text => "//label[contains(text(),'End Effective Date')]/../input",
    :reporting_period_logs_add_event_status_dropdwn => "//input[@id='eventStatus_ct']",
    :reporting_period_logs_add_save_btn => "//button[contains(text(),'Save')]",
    :reporting_period_logs_add_cancel_btn => "//button[contains(text(),'Cancel')]",
    :reporting_period_logs_add_add_btn =>"//div[@class='modal-footer']/div/button",
    :reporting_period_logs_refresh_btn =>  "//button[contains(text(),'Refresh')]",

    :audit_reporting => "//a[contains(text(),'Audit Reporting')]",
    :rcdb_cds_comparison => "//a[contains(text(),'RCDB CDS Comparison')]",
    :zenith_totals_report => "//a[@id = 'navKeyFieldsReport']",
    :rcdb_cds2_comparison => "//a[contains(text(),'RCDB CDS2 Comparison')]",
    :rcdb_totals_by_company => "//a[contains(text(),'RCDB Totals by Company')]",
    :rcdb_validation_requests_view => "//a[contains(text(),'Validation Requests View')]",
    :roles => "//a[contains(text(),'Roles')]",
    :users => "//a[contains(text(),'Users')]",
    :user_guide => "//a[contains(text(),'User Guide')]",
    :new_file_checklist => "//a[contains(text(),'New File Checklist')]",
    :business_reference_mb => "//li[@id='navBizRefMenu']",
    :system_reference_mb => "//li[@id='navSysRefMenu']",
    :workflow_mb => "//li[@id='navWorkflowMenu']",
    :reports_mb => "//li[@id='navReportsMenu']",
    :security_mb => "//li[@id='navSecurityMenu']",
    :security_users => "//a[@id='navSecUsers']",
    :security_roles => "//a[@id='navSecRoles']",
    :help_mb => "//li[@id='navHelpMenu']",
    :version_id => "//div[@class='navbar-header']/../div[2]"
  }
  @siteUrls =
  {
    :client_files => "files",
    :lookup => "lookup",
    :output_company_criteria => "output-company",
    :column_definitions => "reference/columns",
    :company => "reference/companies",
    :entity => "reference/entity",
    :standard_output_codes => "reference/outputcodes",
    :validation_rules => "reference/validation",
    :data_types => "datatype",
    :database_tables => "reference/db",
    :event_status => "reference/eventstatus",
    :operators => "reference/operators",
    :target_databases => "reference/targetdb",
    :workflow_status => "reference/workflowstatus",
    :settings => "reference/settings",
    :reporting_period_logs => "workflow/reporting-period-logs",
    :audit_reporting => "report/show?name=Audit\%20Reporting",
    :rcdb_cds_comparison => "report/show?name=RCDB\%20CDS\%20Comparison",
    :rcdb_cds2_comparison => "report/show?name=RCDB\%20CDS2\%20Comparison",
    :rcdb_totals_by_company => "report/show?name=RCDB\%20Totals\%20by\%20Company",
    :rcdb_validation_requests_view => "report/show?name==Validation\%20Requests\%20View",
    :roles => "security/roles",
  :users => "security/users"}



  class << self
    attr_accessor :siteMap
  end
  class << self
    attr_accessor :siteUrls
  end
   #  Login to Zenith.  Either site prep or test based off of @@base_url which is set in startup based off of the @@environment variable
  def login_to_zenith()
    url  = ""
    @util.logging("Logging into #{@@base_url}")
    if @@brws.upcase == "FIREFOX"

      goto_url("#{@@base_url}")
      #wait_for_alert(5)
      sleep(2)
      a= @driver.switch_to.alert
      a.send_keys("G0h\ue004G00dnight$3")
      a.accept
    elsif @@brws.upcase =="CHROME" || @@brws.upcase == "GOOGLE CHROME"

      if @@host == "placeholder"
        newBase= @@base_url.gsub("http://","http://g0h:G00dnight$3@")
         goto_url("#{newBase}")
      elsif  @@host == "ustw5032" || @@host == "detw5126" || @@host == "dexw5171" 
        newBase= @@base_url.gsub("http://","https://g0h:G00dnight$3@")
        goto_url("#{newBase}")
      else
        goto_url("#{@@base_url}")
      end
      #a.accept
    else

      goto_url("#{@@base_url}")
    end
    wait_for_element(:xpath,Utilities.siteMap[:zenith_mappings_mb]," Zenith Mappings to show",60)
    @@branch = get_element_text(:xpath,Utilities.siteMap[:version_id],"Zenith Version")
  end
     # Depricated  NOT USED
  def login_to_data_connect()
    if @@environment.upcase == "QA_UK"
      goto_url("http://dexw5151.hr-applprep.de/Designers/HomePage.html")
    elsif @@environment.upcase =="DEV_UK"
      goto_url("http://detw5151.hr-appltest.de/Designers/HomePage.html")
    else
      @util.logging("Unknown DC environment : #{@@environment}")
      return false
    end
    sleep(5)
    %x("C:\\Users\\g0h\\cdmi\\Automation\\ie_data_connect_login.exe")
  end
   #   Depricated Used to go to just the client file
  def go_to_client_files()
    goto_url("#{@@base_url}files")
  end
   #   Goes to a zenith sub url
   #   suburl-  text with just the suburl (no / in front of it).  Taken from the site_map
   #   uses the @@base_url to go to a specific suburl
  def go_to_(suburl)
    begin
      @util.logging("Going to #{@@base_url}#{suburl}")
      goto_url("#{@@base_url}#{suburl}")
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "Failed to log into  #{@@base_url}suburl "
      false
    else

    end
  end
   #   Selects a value from the zenith dropdowns
   #   dropdown_button -  The :xpath of the expected dropdown button (usually an arrow icon) defined in site_map
   #   value - The value to select from the dropdown
   #   selectedDescriptor - Logging text to identify the dropdown-  make it descriptive
  def select_from_dropdown(dropdown_button,value,selectedDescriptor)
    click_element(:xpath,dropdown_button,"Dropdown for the #{selectedDescriptor}")
    click_element(:xpath,"//a[contains(text(),'#{value}')]","Selecting #{value} from the #{selectedDescriptor}")
  end
   #   Basic get date time to get date time in different formats
   #   format - text the format to get the date time in
   #   Needs Work-  Only 1 format so far.  Add different formats as needed
  def get_date_time(format)
    time = Time.new
    case format
    when "MM_DD_YYYY_HH_mm"
      dateTime = "#{time.month}_#{time.day}_#{time.year}_#{time.hour}_#{time.min}"
    end
    return dateTime
  end
   # Macro to add a RPL client file.
   #   EntityType-  text The entity type value to select
   #   FileType - text The file type to select
   #   Company -  text The Company name. Assumes that the company already exists
   #   fourthQual - text - The fourth qualifier value-  Usually should use the DB_ID which is the unique test case run id (accessor get_db_id)
   #   effectiveDate -  text - The Effective date to enter
   #   comment- text- Comment text to enter.  Usually should use the DB_ID as well as some comments about the test being run
  def add_client_file(entityType,fileType,company,fourthQual,effectiveDate,comment)
   # go_to_(Utilities.siteUrls[:client_files])
    click_element(:xpath,Utilities.siteMap[:zenith_mappings_mb],"Clicking Zenith Mappings menu")
    click_element(:xpath,Utilities.siteMap[:client_files],"Clicking Client Files from menu")
    click_element(:xpath,Utilities.siteMap[:client_files_add_btn],"Add button on Client Files")
    select_from_dropdown(Utilities.siteMap[:client_files_entity_type_dropdwn],"#{entityType}","Entity Type Dropdown")
    select_from_dropdown(Utilities.siteMap[:client_files_file_type_dropdwn],"#{fileType}","File Type Dropdown")
    shortCompany = company[0..3]
    enter_text(:xpath,Utilities.siteMap[:client_files_company_srch],"#{shortCompany}","Enter Company")
    click_element(:xpath,"//a[contains(text(),'#{company}')]","Selecting '#{company}'")
    enter_text(:xpath,Utilities.siteMap[:client_files_fourth_qualifier_txt],"#{fourthQual}","Fourth Qualifier")
    enter_text(:xpath,Utilities.siteMap[:client_files_effective_date_txt],datecleaner("#{effectiveDate}"),"Effective Date")
    #enter_text(:xpath,Utilities.siteMap[:client_files_comment_txt],"#{comment}\ue004 ","Comment field")
     enter_text(:xpath,Utilities.siteMap[:client_files_comment_txt],"#{comment} ","Comment field")
   click_element(:xpath,"//div[@class ='btn-toolbar pull-right']/button","the add button on the Add Client File Modal" )

    # sleep(1)
    # @util.logging("---> Hack for adding the client file, since the object is obscured, sending enter on the modal page")
    # if @@brws =="edge"

    # else
    #   @driver.action.send_keys("\ue007").perform
    # end
  end
   # Macro to add an OCC to a client file
   #   PreConditions- Assumes that the user is on the client file screen(ie. base_url/files)
   #   clientFileIdentifier -  text-  Usually the 4th qualifier that is a unique identifier for the RPL
   #   occToAttach - Text - The OCC to attach to the client file-  Assumes that the OCC already exists
  def attach_occ_to_client_file(clientFileIdentifier,occToAttach)
    click_element(:xpath,"//span[contains(text(),'#{clientFileIdentifier}')]","Clicking on a row with the expected fourth qualifier of #{clientFileIdentifier}")
    click_element(:xpath,Utilities.siteMap[:client_files_output_company_criteria_btn],"Clicking on the Output Company Criteria")
    click_element(:xpath,"//span[contains(text(),'#{occToAttach}')]","Selecting the #{occToAttach}")
    click_element(:xpath,Utilities.siteMap[:output_company_criteria_add_btn],"Attaching the '#{occToAttach}' with the Add button")
  end
   # Switches to a browser window.  Used to view reports that get generated in a new browser tab.
   #   titleOrParent  - usually either NEWEST or PARENT, but could be the title of the page.  NEWEST shifts focus to the newest create tab.  
   #   Parent takes it to the home screen (zenith) 
  def switch_to_tab(titleOrParent)
    #  currentTitle = @driver.title
    switchedToTitle =""
    titleFound = false
    tabHandles = @driver.window_handles()

    if titleOrParent.upcase == "PARENT"
      @driver.switch_to.window(tabHandles[0])
      titleFound =true
    elsif titleOrParent.upcase =="NEWEST"
      numberOfTabs= tabHandles.length
      @driver.switch_to.window(tabHandles[numberOfTabs-1])
      titleFound =true
    else
      numberOfTabs= tabHandles.length

      for i in 0..(numberOfTabs -1 )
        if titleFound == false
          @driver.switch_to.window(tabHandles[i])
        end
        if @driver.title == titleOrParent
          titleFound =true
        end
      end
    end
    if titleFound== true
      @util.logging("Successfully switched to #{@driver.title}")
      return true
    else
      @util.logging("Unable to find tab #{titleOrParent}.  Currently on #{@driver.title}")
      return false
    end
  end
   # Copies a test file from the DATAfiles directory into the specified destination folder.  Creates the file name and path to rename the file to based off of the environment, entityType,filetype, company, fourthQualifier, effectiveDate
   #   testFileName  the raw file name to be renamed
   #   destFolder the folder to put the renamed file in ie 1.In,2.ARCHIVE, 3.Error, etc
   #   entityType
   #   fileType
   #   company
   #   fourthQual
   #   effectiveDate
  def put_test_data_files_in_dataconnect_folder(*args)
    #(testFilename,destFolder,entityType,fileType,company,fourthQual,effectiveDate)
   testFilename = args[0]
   destFolder = args[1]
   entityType = args[2]
   fileType = args[3]
   company = args[4]
   fourthQual = args[5]
   effectiveDate = args[6]
    if args.size >=8
        fileSuffix = args[7]
    else
 fileSuffix = "xlsx" 
      end
    destBaseFilePath  = ""
    destFileName =""
    case destFolder.upcase
    when "1.IN","IN"
      destFolderChecked = "1.In"
    when "2.ARCHIVE","ARCHIVE"
      destFolderChecked = "2.Archive"
    when "3.ERROR","ERROR"
      destFolderChecked = "3.Error"
    when "4.RERUN","RERUN"
      destFolderChecked = "4.Rerun"
    when "5.AUTOSCHEMA","AUTOSCHEMA"
      destFolderChecked = "5.AutoSchema"
    when "6.OUTPUT","OUTPUT"
      destFolderChecked = "6.Output"
    when "7.RESET","RESET"
      destFolderChecked = "7.Reset"
    else
      @util.logging("#{destFolder} is unknown")
    end


    if @@environment.upcase =="QA_UK"
      destBaseFilePath= "\\\\hr-applprep.de\\shares\\us6_Actian_UK\\TPA\\#{destFolderChecked}"
    elsif @@environment.upcase =="PREPROD_UK"
      destBaseFilePath= "\\\\hr-applprep.de\\shares\\us6_Actian_UK\\TPA_PREPROD\\#{destFolderChecked}"
    elsif @@environment.upcase =="DEV_UK"
      destBaseFilePath = "\\\\hr-appltest.de\\shares\\us6_Actian_UK\\TPA\\#{destFolderChecked}"
    elsif @@environment.upcase =="QA_US"
      destBaseFilePath= "\\\\hr-applprep.de\\shares\\us6_Actian_US\\TPA\\#{destFolderChecked}"
    elsif @@environment.upcase =="DEV_US"
      destBaseFilePath = "\\\\hr-appltest.de\\shares\\us6_Actian_US\\TPA\\#{destFolderChecked}"
     elsif @@environment.upcase =="QA_US"
      destBaseFilePath = "\\\\hr-applprep.de\\shares\\us6_Actian_US\\TPA\\#{destFolderChecked}"
    else
      @util.logging("Unknown environment #{@@environment}")
    end
    companyCode = company[0..3]
    if testFilename.include?(".AS.xlsx")
      destFileName = "#{entityType}.#{fileType}#{companyCode}.#{effectiveDate}.EX.#{fourthQual}.AS.xlsx"
    else
      destFileName = "#{entityType}.#{fileType}#{companyCode}.#{effectiveDate}.EX.#{fourthQual}.#{fileSuffix}"
    end
    src = "#{@@filedir}\\DataFiles\\#{testFilename}"
    checkOriginalExists = File.exists?("#{src}")
    if checkOriginalExists == false
      @util.logging("The src file #{src} does not exist")
      return false
    end

    FileUtils.copy(src,"#{destBaseFilePath}\\#{destFileName}")
    if destBaseFilePath.include?("1.In")
      @@deleteFiles.push("#{destBaseFilePath}\\#{destFileName}")
    end
    copySuccessful = File.exists?("#{destBaseFilePath}\\#{destFileName}")
    if copySuccessful == false
      @util.logging("The copy failed")
      return false
    else
      @util.logging("Copied #{src} to #{destBaseFilePath}\\#{destFileName} ")
    end
  end
   # Checks that a file exists in the destination folder.  Creates the file name and path to verify based off of the environment, entityType,filetype, company, fourthQualifier, effectiveDate
   #   testFileName  the raw file name to be renamed
   #   destFolder the folder to check for the renamed file in ie 1.In,2.ARCHIVE, 3.Error, etc
   #   entityType
   #   fileType
   #   company
   #   fourthQual
   #   effectiveDate
  def verify_data_files_in_dataconnect_folder(*args)
    #(testFilename,destFolder,entityType,fileType,company,fourthQual,effectiveDate)
   testFilename = args[0]
   destFolder = args[1]
   entityType = args[2]
   fileType = args[3]
   company = args[4]
   fourthQual = args[5]
   effectiveDate = args[6]
    if args.size >=8
        fileSuffix = args[7]
    else
 fileSuffix = "xlsx" 
      end

    destBaseFilePath  = ""
    destFileName =""
    case destFolder.upcase
    when "1.IN","IN"
      destFolderChecked = "1.In"
    when "2.ARCHIVE","ARCHIVE"
      destFolderChecked = "2.Archive"
    when "3.ERROR","ERROR"
      destFolderChecked = "3.Error"
    when "4.RERUN","RERUN"
      destFolderChecked = "4.Rerun"
    when "5.AUTOSCHEMA","AUTOSCHEMA"
      destFolderChecked = "5.AutoSchema"
    when "6.OUTPUT","OUTPUT"
      destFolderChecked = "6.Output"
    when "7.RESET","RESET"
      destFolderChecked = "7.Reset"
    else
      @util.logging("#{destFolder} is unknown")
    end


    if @@environment.upcase =="QA_UK"
      destBaseFilePath= "\\\\hr-applprep.de\\shares\\us6_Actian_UK\\TPA\\#{destFolderChecked}"
    elsif @@environment.upcase =="PREPROD_UK"
      destBaseFilePath= "\\\\hr-applprep.de\\shares\\us6_Actian_UK\\TPA_PREPROD\\#{destFolderChecked}"
    elsif @@environment.upcase =="DEV_UK"
      destBaseFilePath = "\\\\hr-appltest.de\\shares\\us6_Actian_UK\\TPA\\#{destFolderChecked}"
    elsif @@environment.upcase =="QA_US"
      destBaseFilePath= "\\\\hr-applprep.de\\shares\\us6_Actian_US\\TPA\\#{destFolderChecked}"
    elsif @@environment.upcase =="DEV_US"
      destBaseFilePath = "\\\\hr-appltest.de\\shares\\us6_Actian_US\\TPA\\#{destFolderChecked}"
       elsif @@environment.upcase =="QA_US"
      destBaseFilePath = "\\\\hr-applprep.de\\shares\\us6_Actian_US\\TPA\\#{destFolderChecked}"
    else
      @util.logging("Unknown environment #{@@environment}")
    end
    companyCode = company[0..3]
    if testFilename.include?(".AS.xlsx")
      destFileName = "#{entityType}.#{fileType}#{companyCode}.#{effectiveDate}.EX.#{fourthQual}.AS.xlsx"
    else
      destFileName = "#{entityType}.#{fileType}#{companyCode}.#{effectiveDate}.EX.#{fourthQual}.#{fileSuffix}"
    end

    fileExists = File.exists?("#{destBaseFilePath}\\#{destFileName}")
    if fileExists == false
      errorMsg = "File #{destFileName} is not in #{destBaseFilePath}"
      @util.logging(errorMsg)
      check_override(true,errorMsg,false)
      return false
    else
      @util.logging("File #{destFileName} is in #{destBaseFilePath} ")
    end
  end
   # Deletes the raw files from a specific folder.  Creates the file name and path to delete based off of the environment,
   #   entityType,filetype, company, fourthQualifier, effectiveDate
   #   testFileName  the raw file name to be renamed
   #   destFolder the folder to delete the renamed file from ie 1.In,2.ARCHIVE, 3.Error, etc
   #   entityType
   #   fileType
   #   company
   #   fourthQual
   #   effectiveDate

  def delete_test_data_files_from_dataconnect_folder(testFilename,destFolder,entityType,fileType,company,fourthQual,effectiveDate)
    destBaseFilePath  = ""
    destFileName =""
    case destFolder.upcase
    when "1.IN","IN"
      destFolderChecked = "1.In"
    when "2.ARCHIVE","ARCHIVE"
      destFolderChecked = "2.Archive"
    when "3.ERROR","ERROR"
      destFolderChecked = "3.Error"
    when "4.RERUN","RERUN"
      destFolderChecked = "4.Rerun"
    when "5.AUTOSCHEMA","AUTOSCHEMA"
      destFolderChecked = "5.AutoSchema"
    when "6.OUTPUT","OUTPUT"
      destFolderChecked = "6.Output"
    when "7.RESET","RESET"
      destFolderChecked = "7.Reset"
    else
      @util.logging("#{destFolder} is unknown")
    end
    if @@environment.upcase =="QA_UK"
      destBaseFilePath= "\\\\hr-applprep.de\\shares\\us6_Actian_UK\\TPA\\#{destFolderChecked}"
    elsif @@environment.upcase =="PREPROD_UK"
      destBaseFilePath= "\\\\hr-applprep.de\\shares\\us6_Actian_UK\\TPA_PREPROD\\#{destFolderChecked}"
    elsif @@environment.upcase =="DEV_UK"
      destBaseFilePath = "\\\\hr-appltest.de\\shares\\us6_Actian_UK\\TPA\\#{destFolderChecked}"
    elsif @@environment.upcase =="QA_US"
      destBaseFilePath= "\\\\hr-applprep.de\\shares\\us6_Actian_US\\TPA\\#{destFolderChecked}"
    elsif @@environment.upcase =="DEV_US"
      destBaseFilePath = "\\\\hr-appltest.de\\shares\\us6_Actian_US\\TPA\\#{destFolderChecked}"
    elsif @@environment.upcase =="QA_US"
      destBaseFilePath = "\\\\hr-applprep.de\\shares\\us6_Actian_US\\TPA\\#{destFolderChecked}"
    else
      @util.logging("Unknown environment #{@@environment}")
    end
    companyCode = company[0..3]
    if testFilename.include?(".AS.xlsx")
      destFileName = "#{entityType}.#{fileType}#{companyCode}.#{effectiveDate}.EX.#{fourthQual}.AS.xlsx"
    else
      destFileName = "#{entityType}.#{fileType}#{companyCode}.#{effectiveDate}.EX.#{fourthQual}.xlsx"
    end
    fileExists = File.exists?("#{destBaseFilePath}\\#{destFileName}")
    if fileExists == false
      @util.logging("The file #{destFileName} does not exist in #{destBaseFilePath}")
      return false
    else
      @util.logging("Deleting #{destBaseFilePath}\\#{destFileName}")
      File.delete("#{destBaseFilePath}\\#{destFileName}")
    end
  end
   # Deprecated?
   #   calls each of the sub functions from a single call.  Returns the logLocation
   #   dcProcess the process to call, main,conductor,CDS, LRM
  def call_DC_process(dcProcess)
    case dcProcess.upcase
    when "MAIN"
      logLocation = run_dc_main
    when "CONDUCTOR"
      logLocation = run_dc_conductor
    when "CDS"
      logLocation = run_dc_cds
    when "LRM"
      logLocation = run_dc_lrm
    else
      @util.logging("Invalid dc process name #{dcProcess}")
    end
    return logLocation
  end
   # Starts the specific DC process (main or conductor at this point).Waits for the workflow status to reach a specific value. 
   #   Hits the Refresh button every 10 sec.  Checks the DC log for initialization failures and that the process completes. 
   #   Recursively calls DC if there are initialization failures up to 3 times.
   #   testIdentifier  the unique identifier of the report.  Usually the the 4th Qualifier as the name of the rpl
   #   status expected status to get to
   #   maxTimeinMinToWait  time to wait for the status to reach the expected status
  def wait_for_expected_workflow_status_start_dc(testIdentifier,status,maxTimeInMinToWait,dcProcess)
    whileCounter = 0
    workflowStatus = ""
    while (whileCounter<2) && (workflowStatus != status)
      logLocation = call_DC_process(dcProcess)
      wait_for_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow status",30)
      workflowStatus,logLocation = wait_for_expected_workflow_status_recursion(testIdentifier,status,maxTimeInMinToWait,dcProcess,logLocation)
      sleep(10)
      logresponse = HTTParty.get("#{logLocation}/log",get_dc_options)

      if  (workflowStatus  != "#{status}")
        errorMsg ="The status of rpl #{testIdentifier} never got to '#{status}'  instead it is at #{workflowStatus}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
        return false
      else
        if logresponse.to_s.include?("No log file mapped to this address") && workflowStatus == "#{status}"
          @util.logging("#{logresponse.to_s}")
          errorMsg ="<font color =\"orange\">  WARN  ----DC log appears to be stuck.  Check DC server for errors </font>"
          @util.logging(errorMsg)
       #   check_override(true,errorMsg,false)
          @util.logging("The status of rpl #{testIdentifier} is #{workflowStatus}")
          return true
        elsif ((logresponse.to_s.include?("Test#{@@db_id}")) == false) && (whileCounter < 2)
         # binding.pry
          @util.logging("#{logresponse.to_s}")
          @util.logging("<a href =\"#{logLocation}\">#{logLocation}</a> is not for the current file with the fourth qualifier Test#{@@db_id}")
          @util.logging("Sending DC #{dcProcess} again. Try #{whileCounter}")
          whileCounter += 1

        else
          @util.logging("The status of rpl #{testIdentifier} is #{workflowStatus}")
          return true
        end
      end
    end
  end
     # Helper function for wait_for_expected_workflow_status_start_dc
  def wait_for_expected_workflow_status_recursion(testIdentifier,status,maxTimeInMinToWait,dcProcess,logLocation)
    workflowStatus = get_element_text(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow Status of #{testIdentifier}")
    sleep(10)
    checkTime = Time.new
    endTime = checkTime + (maxTimeInMinToWait * 60 )
    dcFinished = false
    whileCounter =0
    while (workflowStatus != "#{status}" ) && (checkTime < endTime) && (dcFinished ==false)

      sleep(10)
      checkTime = Time.new
      logMeta = HTTParty.get("#{logLocation}",get_dc_options)
      click_element(:xpath, Utilities.siteMap[:reporting_period_logs_refresh_btn],"RPL Refresh button")
      #:reporting_period_logs_refresh_btn =>  "//button[contains(text(),'Refresh')]",
      workflowStatus = get_element_text(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow Status of #{testIdentifier}")

      if ((logMeta["job"]["status"].to_s != "RUNNING") && (logMeta["job"]["status"].to_s != "QUEUED"))

        dcFinished = true
        @util.logging("DC job #{dcProcess} got to #{logMeta["job"]["status"].to_s} ")
        logresponse = HTTParty.get("#{logLocation}/log",get_dc_options)
       whileCount = 0 
        # while ((logresponse.to_s.include?("No log file mapped to this address")) && (whileCount < 10))
        #   sleep(10)
        #    logresponse = HTTParty.get("#{logLocation}/log",get_dc_options)
        #    whileCount = whileCount + 1
        #    binding.pry
        # end
        # binding.pry
        workflowStatuslog = get_element_text(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow Status of #{testIdentifier}")
        if logresponse.to_s.include?("Email From DC: Initialization Failure")
          errorMsg ="There was an initialization Failure for DC Main in #{logLocation}"
          @util.logging(errorMsg)
          check_override(true,errorMsg,false)
          @util.logging("Sending DC #{dcProcess} again. Try #{whileCounter}")
          logLocation = call_DC_process(dcProcess)
          @util.logging("New DC #{dcProcess} job created at <a href =\"#{logLocation}\">#{logLocation}</a> add /log at the end to see the log")
          sleep(10)
          dcFinished = false
          response = HTTParty.get("#{logLocation}/log",get_dc_options)
          whileCounter +=1
        elsif  (logresponse.to_s.include?("Test#{@@db_id}") == false)
          #DC finished but there is not
          if (  (logresponse.to_s.include?("Test#{@@db_id}")) == false) && (whileCounter < 3)
            @util.logging("<a href =\"#{logLocation}\">#{logLocation}</a> is not for the current file with the fourth qualifier Test#{@@db_id}")
            @util.logging("Sending DC #{dcProcess} again. Try #{whileCounter}")
            logLocation = call_DC_process(dcProcess)
            @util.logging("New DC #{dcProcess} job created at <a href =\"#{logLocation}\">#{logLocation}</a> add /log at the end to see the log")
            sleep(10)
            dcFinished = false
            response = HTTParty.get("#{logLocation}/log",get_dc_options)
            whileCounter +=1
          end
          if ( ! (logresponse.to_s.include?("Test#{@@db_id}"))) && (whileCounter >=3)
            errorMsg ="Unable to get a DC log with Test#{@@db_id} after 3 trys"
            @util.logging(errorMsg)
            check_override(true,errorMsg,false)
          end
        end
      end
    end
    return workflowStatus,logLocation
  end
   # Waits for the workflow status to reach a specific value.  Hits the Refresh button every 10 sec
   #   testIdentifier  the unique identifier of the report.  Usually the the 4th Qualifier as the name of the rpl
   #   status expected status to get to
   #   maxTimeinMinToWait  time to wait for the status to reach the expected status
  def wait_for_expected_workflow_status(testIdentifier,status,maxTimeInMinToWait)
    # if maxTimeInMinToWait.to_int 0
    #   maxTimeInMinToWait = 10
    # end
    wait_for_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow status",30)
    workflowStatus = get_element_text(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow Status of #{testIdentifier}")
    sleep(10)
    checkTime = Time.new
    endTime = checkTime + (maxTimeInMinToWait * 60 )
    while (workflowStatus != "#{status}" ) && (checkTime < endTime)
      click_element(:xpath, Utilities.siteMap[:reporting_period_logs_refresh_btn],"RPL Refresh button")
      #:reporting_period_logs_refresh_btn =>  "//button[contains(text(),'Refresh')]",
      workflowStatus = get_element_text(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow Status of #{testIdentifier}")
      sleep(10)
      checkTime = Time.new
    end
    if  (workflowStatus  != "#{status}")
      errorMsg ="The status of rpl #{testIdentifier} never got to '#{status}' for 10 minutes, instead it is at #{workflowStatus}"
      @util.logging(errorMsg)
      check_override(true,errorMsg,false)
      return false
    else
      @util.logging("The status of rpl #{testIdentifier} is #{workflowStatus}")
      return true
    end
  end
   # Special case for performance testing
   #   waits for the workflow status to reach a specific value.  Hits the Refresh button every 10 sec.  At each step the time is taken from the previous step. 
   #   Each step is logged to the automation DB with the rplid and time
   #   testIdentifier  the unique identifier of the report.  Usually the the 4th Qualifier as the name of the rpl
   #   status expected status to get to
   #   maxTimeinMinToWait  time to wait for the status to reach the expected status
  def wait_for_expected_workflow_status_with_timing(testIdentifier,status,maxTimeInMinToWait)
    # if maxTimeInMinToWait.to_int 0
    #   maxTimeInMinToWait = 10
    # end

    workflowStatus = get_element_text(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow Status of #{testIdentifier}")
    lastWorkflowStatus = workflowStatus
    sleep(5)
    checkTime = Time.new
    startWorkflowStatusTime = checkTime
    workflowStatuses =Array.new
    endTime = checkTime + (maxTimeInMinToWait * 60 )
    while (workflowStatus != "#{status}" ) && (checkTime < endTime)
      click_element(:xpath, Utilities.siteMap[:reporting_period_logs_refresh_btn],"RPL Refresh button")
      #:reporting_period_logs_refresh_btn =>  "//button[contains(text(),'Refresh')]",
      workflowStatus = get_element_text(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow Status of #{testIdentifier}")
      if workflowStatus != lastWorkflowStatus
        workflowChanged = Time.new
        workflowStatusDifferential = workflowChanged - startWorkflowStatusTime
        individualWorkflowArray = [workflowStatus, workflowStatusDifferential,workflowChanged.strftime("%Y-%m-%d %H:%M:%S")]
        workflowStatuses.push(individualWorkflowArray)
        @util.logging("Took #{workflowStatusDifferential} to get to #{workflowStatus} from #{lastWorkflowStatus}")
        lastWorkflowStatus =workflowStatus  #reset the lastWorkflowStatus
        startWorkflowStatusTime = workflowChanged  #rese4t the startWorkflowStatus
      end
      sleep(5)
      checkTime = Time.new
    end
    workflowValues = ""
    workflowStatuses.each do |row|
      workflowValues = workflowValues + "(#{@@rplId},'#{row[0]}',#{row[1]},convert(datetime,'#{row[2]}',20),#{@@db_id}),"
    end
    ##
    wfLength = workflowValues.length - 2

    workflowValues = workflowValues[0..wfLength]  #take off the last comma

    query = "Insert into WorkflowPerformance (RPLid,WorkflowStep,TimeToWorkflowStepSec,TimeOfWorkflow,TestId) VALUES #{workflowValues};"
    @util.logging("Inserting workflow times into automation database")
    results = run_automation_db_query(query)
    if  (workflowStatus  != "#{status}")
      errorMsg ="The status of rpl #{testIdentifier} never got to '#{status}' for 10 minutes, instead it is at #{workflowStatus}"
      @util.logging(errorMsg)
      check_override(true,errorMsg,false)
      return false
    else
      @util.logging("The status of rpl #{testIdentifier} is #{workflowStatus}")

      return true
    end
  end
   # Special case  Test to verify that the workflow status does NOT change.   Hits the Refresh button every 10 sec
   #   testIdentifier  the unique identifier of the report.  Usually the the 4th Qualifier as the name of the rpl
   #   status to not get to
   #   maxTimeinMinToWait  time to wait for the status to change
  def wait_for_workflow_status_to_not_get_to(testIdentifier,status,maxTimeInMinToWait)
    # if maxTimeInMinToWait.to_int 0
    #   maxTimeInMinToWait = 10
    # end
    workflowStatus = get_element_text(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow Status of #{testIdentifier}")
    sleep(10)
    checkTime = Time.new
    endTime = checkTime + (maxTimeInMinToWait * 60 )
    while (workflowStatus != "#{status}" ) && (checkTime < endTime)
      click_element(:xpath, Utilities.siteMap[:reporting_period_logs_refresh_btn],"RPL Refresh button")
      #:reporting_period_logs_refresh_btn =>  "//button[contains(text(),'Refresh')]",
      workflowStatus = get_element_text(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[4]/span","Workflow Status of #{testIdentifier}")
      sleep(10)
      checkTime = Time.new
    end
    if  (workflowStatus  == "#{status}")
      errorMsg ="The status of rpl #{testIdentifier} never got to '#{status}' for 10 minutes, instead it is at #{workflowStatus}"
      @util.logging(errorMsg)
      check_override(true,errorMsg,false)
      return false
    else
      @util.logging("The status of rpl #{testIdentifier} is #{workflowStatus}")
      return true
    end
  end
 # Runs the backend database tests.  Can take either an array of the test cases to run OR the workflow step grouping for tests. Runs each test in the array
 #   if the test fails, it logs the failure and continues on
 #   testListArray  an array of tests to run. Overriden if there are values in the allTestsForWorkflowStep
 #   rplId  the rplid to run the tests against
 #   failOnly  sets the @FailOnlyInd  declare in the SQL statement as either 0 or 1.  The back end tests use this to either report the fails(1) or report all information (0)
 #   allTestsForWorkflowStep.  The workflow step identifier in the automation backend tests table that identifies groups of tests for a specific workflow.

  def run_back_end_tests(*args)
    testListArray = args[0]
    rplId =args[1]
    failOnly =args[2]
    errorSql=false
    if args.size >=4
      allTestsForWorkflowStep = args[3]
    end
    countOfRecords = Hash.new
    @util.logging("--------------------------------------Backend Test Section--------------------------------------\nThe RPLID for this run is #{rplId}")
    if allTestsForWorkflowStep
      get_tests_query = "select * from [Automation].[dbo].[BackendTests] a inner join   [Automation].[dbo].[WorkflowStatusTestXref] b on a.testid = b.testid where b.workflowstatus = '#{allTestsForWorkflowStep}'"
      results= run_automation_db_query(get_tests_query)
    else
      string_db_tests_array =testListArray.to_s.gsub('[','').gsub(']','').gsub('"','\'')
      get_tests_query = "Select TestName,SQL, ComplexityId from [Automation].[dbo].[BackendTests] where TestName in \(#{string_db_tests_array}\)"
      results= run_automation_db_query(get_tests_query)
    end
    run_tests = Array.new
    results.each do |result|
      line = {"TestName" => result["TestName"], "SQL" => result["SQL"], "Complexity" => result["ComplexityId"]}
      run_tests.push(line)
    end
    @util.logging("Running #{run_tests.count} Backend Tests")
    run_tests.each do |dbtest|
      modifiedSql = ""
      results = ""
      modifiedSql = dbtest["SQL"].gsub('{RPLId}',"#{rplId}")

      if failOnly ==0
        failString ="DECLARE @FailOnlyInd INT = 0;"
      else
        failString ="DECLARE @FailOnlyInd INT = 1;"
      end
      modifiedSql = "#{failString} \n #{modifiedSql}"
      # if dbtest["TestName"] == "CDS2 - O_Movement_Date" || dbtest["TestName"] == "CDS2 - O_Current_Reinsured_Periodic_Annuity"
      #     file=File.open("c:\\\\users\\g0h\\cdmi\\automation\\O_movementDate.sql","a")
      #     file.write ("#{modifiedSql}")
      #     file.close
      #     binding.pry
      # end

      results,error = tds_query("Zenith",modifiedSql)
      if error != ""
        errorMsg ="#{dbtest['TestName']} query failed with the message #{error}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      else
        # count = 0
        # while dbtest["TestName"] == "CDS2 - O_Movement_Date" && results.count != 0 && count <20
        #   results.do
        #   results = tds_query("CDS2",modifiedSql)
        #   @util.logging "Re ran sql for #{dbtest["TestName"]} #{count}"
        #   count +=1
        # end
        @util.logging("Running test: #{dbtest['TestName']}")
        if dbtest["Complexity"] ==3
          results.each do |row|
            countOfRecords.merge!({"#{dbtest['TestName']}" => row[""]})
            @util.logging("Back End test #{dbtest["TestName"]} returned #{row[""]} for count")
          end
        else

          if results.count != 0
            errorMsg = "Back End test #{dbtest["TestName"]} failed with the following errors for RPLID #{rplId}"

            justFile =@@g_base_dir[(@@g_base_dir.rindex('/')+1)..@@g_base_dir.length]
            file=File.open("#{@@artifact_dir}#{justFile}.sql","a")
            if errorSql == false
              #shortArtifactDir = @@artifact_dir.gsub("\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs\\","")
              log_new_artifact("#{justFile}.sql")
            end
            errorSql=true
            file.write ("--#{dbtest['TestName']}")
            file.write ("#{modifiedSql};")
            file.close
            results.each do |row|

              errorMsg = "#{errorMsg}\n#{row}"
            end
            @util.logging(errorMsg)
            check_override(true,errorMsg,false)
          else
            @util.logging("Back End test #{dbtest["TestName"]} passed")
          end
        end
      end
    end
    @util.logging("--------------------------------------End of Backend Test Section--------------------------------------")
    if countOfRecords != ""
      return countOfRecords
    end
  end
 # Gets the rplId with a specific name.  For the automated tests this is the testIdentifier, ie the unique 4th qualifier
 #   testidentifier   
 def get_rplId(testIdentifier)
    query = "select * from [Zenith].[dbo].[ReportingPeriodLog] where name = '#{testIdentifier}'"
    rplId =""
    results, error = tds_query("Zenith",query)
    #binding.pry
    results.each do |row|
      rplId = row["ReportingPeriodLogId"]
      rcdbClientLogId = row["RcdbClientLogId"]
    end
    if results.count > 0
      @util.logging("The RplId for #{testIdentifier} is #{rplId}")
      @@rplId = rplId
      return rplId
    else
      return false
    end
  end
   # Gets the rcdb client log id given the rplId
   #   rplid
  def get_rcdbclientlogid(rplId)
    query = "select rcdbclientlogid from zenith.dbo.reportingperiodlog where reportingperiodlogid = #{rplId}"
    results, error = tds_query("Zenith",query)
    rcdbclientlogid =""

    results.each do |logid|
      rcdbclientlogid  = logid["rcdbclientlogid"]
    end
    return  rcdbclientlogid
  end
   # Takes the count of records in the current hash array and compares that to an expected hash array.  Uses the results of the backend counts tests
   #   countOfRecords hash array with the current count for a particualar hash
   #   expectedRecordsArray  a hash array of expected records 
  def verify_expected_records_counts(countOfRecords,expectedRecordsArray)
    rplId  = @@rplId
    if countOfRecords["RCDB Annuity Record Count"]
      if countOfRecords["RCDB Annuity Record Count"].to_i != expectedRecordsArray["rowsInXlsxFile"]
        errorMsg ="The source xlsx file has #{expectedRecordsArray["rowsInXlsxFile"]} records but there are #{countOfRecords["RCDB Annuity Record Count"]} in the RCdB : rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The #{expectedRecordsArray["rowsInXlsxFile"]} records in the source file  match the rows inserted #{countOfRecords["RCDB Annuity Record Count"]} in RCdB ")
      end
    end
    if countOfRecords["CDS2 Insured Record Count"]
      if countOfRecords["CDS2 Insured Record Count"].to_i != expectedRecordsArray["expectedCDS2InsuredRecordCount"]
        errorMsg ="Expected #{expectedRecordsArray["expectedCDS2InsuredRecordCount"]} records but there are #{countOfRecords["CDS2 Insured Record Count"]} in CDS2 for CDS2 Insured Record Count : rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["CDS2 Insured Record Count"]} in the CDS2 match the expected count for CDS2 Insured Record Count")
      end
    end
    if countOfRecords["CDS2 Component Record Count"]
      if countOfRecords["CDS2 Component Record Count"].to_i != expectedRecordsArray["expectedCDS2ComponentRecordCount"]
        errorMsg ="Expected #{expectedRecordsArray["expectedCDS2ComponentRecordCount"]} records but there are #{countOfRecords["CDS2 Component Record Count"]} in CDS2 for CDS2 Component Record Count : rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["CDS2 Component Record Count"]} in the CDS2 match the expected count for CDS2 Component Record Count")
      end
    end
    if countOfRecords["CDS2 Policy Record Count"]
      if countOfRecords["CDS2 Policy Record Count"].to_i != expectedRecordsArray["expectedCDS2PolicyRecordCount"]
        errorMsg ="Expected #{expectedRecordsArray["expectedCDS2InsuredRecordCount"]} records but there are #{countOfRecords["CDS2 Policy Record Count"]} in CDS2 for CDS2 Policy Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["CDS2 Policy Record Count"]} in the CDS2 match the expected count for CDS2 Policy Record Count")
      end
    end
    if countOfRecords["CDS Insured Record Count"]
      if countOfRecords["CDS Insured Record Count"].to_i != expectedRecordsArray["expectedCDSInsuredRecordCount"]
        errorMsg ="Expected #{expectedRecordsArray["expectedCDSInsuredRecordCount"]} records but there are #{countOfRecords["CDS Insured Record Count"]} in CDS for CDS Insured Record Count : rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["CDS Insured Record Count"]} in the CDS match the expected count for CDS Insured Record Count")
      end
    end
    if countOfRecords["CDS Component Record Count"]
      if countOfRecords["CDS Component Record Count"].to_i != expectedRecordsArray["expectedCDSComponentRecordCount"]
        errorMsg ="Expected #{expectedRecordsArray["expectedCDSComponentRecordCount"]} records but there are #{countOfRecords["CDS Component Record Count"]} in CDS for CDS Component Record Count : rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["CDS Component Record Count"]} in the CDS match the expected count for CDS Component Record Count")
      end
    end
    if countOfRecords["CDS Policy Record Count"]
      if countOfRecords["CDS Policy Record Count"].to_i != expectedRecordsArray["expectedCDSPolicyRecordCount"]
        errorMsg ="Expected #{expectedRecordsArray["expectedCDSInsuredRecordCount"]} records but there are #{countOfRecords["CDS Policy Record Count"]} in CDS for CDS Policy Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["CDS Policy Record Count"]} in the CDS match the expected count for CDS Policy Record Count")
      end
    end
    if countOfRecords["LRM TRANSFER Record Count"]
      if countOfRecords["LRM TRANSFER Record Count"].to_i != expectedRecordsArray["expectedLRMTransferRecordCount"]
        errorMsg ="Expected #{expectedRecordsArray["expectedLRMTransferRecordCount"]} records but there are #{countOfRecords["LRM TRANSFER Record Count"]} in LRM CDS for LRM Transfer Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM TRANSFER Record Count"]} match the expected count for LRM TRANSFER Record Count")
      end
    end
    if countOfRecords["LRM CT_CLAIM Record Count"]
      if countOfRecords["LRM CT_CLAIM Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_CLAIM_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_CLAIM_Record_Count"]} records but there are #{countOfRecords["LRM CT_CLAIM Record Count"]} in LRM CDS for LRM CT_CLAIM Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_CLAIM Record Count"]} in the LRM CDS match the expected count for LRM CT_CLAIM Record Count")
      end
    end
    if countOfRecords["LRM CT_CLAIMHD Record Count"]
      if countOfRecords["LRM CT_CLAIMHD Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_CLAIMHD_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_CLAIMHD_Record_Count"]} records but there are #{countOfRecords["LRM CT_CLAIMHD Record Count"]} in LRM CDS for LRM CT_CLAIMHD Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_CLAIMHD Record Count"]} match the expected count for LRM CT_CLAIMHD Record Count")
      end
    end
    if countOfRecords["LRM CT_CLAIMSHR Record Count"]
      if countOfRecords["LRM CT_CLAIMSHR Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_CLAIMSHR_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_CLAIMSHR_Record_Count"]} records but there are #{countOfRecords["LRM CT_CLAIMSHR Record Count"]} in LRM CDS for LRM CT_CLAIMSHR Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_CLAIMSHR Record Count"]} match the expected count for LRM CT_CLAIMSHR Record Count")
      end
    end
    if countOfRecords["LRM CT_DTAHEAD Record Count"]
      if countOfRecords["LRM CT_DTAHEAD Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_DTAHEAD_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_DTAHEAD_Record_Count"]} records but there are #{countOfRecords["LRM CT_DTAHEAD Record Count"]} in LRM CDS for LRM CT_DTAHEAD Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_DTAHEAD Record Count"]} match the expected count for LRM CT_DTAHEAD Record Count")
      end
    end
    if countOfRecords["LRM CT_ESC Record Count"]
      if countOfRecords["LRM CT_ESC Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_ESC_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_ESC_Record_Count"]} records but there are #{countOfRecords["LRM CT_ESC Record Count"]} in LRM CDS for LRM CT_ESC Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_ESC Record Count"]}  match the expected count for LRM CT_ESC Record Count")
      end
    end
    if countOfRecords["LRM CT_IDENT Record Count"]
      if countOfRecords["LRM CT_IDENT Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_IDENT_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_IDENT_Record_Count"]} records but there are #{countOfRecords["LRM CT_IDENT Record Count"]} in LRM CDS for LRM CT_IDENT Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_IDENT Record Count"]}  match the expected count for LRM CT_IDENT Record Count")
      end
    end
    if countOfRecords["LRM CT_INSPER Record Count"]
      if countOfRecords["LRM CT_INSPER Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_INSPER_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_INSPER_Record_Count"]} records but there are #{countOfRecords["LRM CT_INSPER Record Count"]} in LRM CDS for LRM CT_INSPER Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_INSPER Record Count"]} match the expected count for LRM CT_INSPER Record Count")
      end
    end
    if countOfRecords["LRM CT_PCSHR Record Count"]
      if countOfRecords["LRM CT_PCSHR Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_PCSHR_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_PCSHR_Record_Count"]} records but there are #{countOfRecords["LRM CT_PCSHR Record Count"]} in LRM CDS for LRM CT_PCSHR Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_PCSHR Record Count"]} in the LRM CDS match the expected count for LRM CT_PCSHR Record Count")
      end
    end
    if countOfRecords["LRM CT_POL Record Count"]
      if countOfRecords["LRM CT_POL Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_POL_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_POL_Record_Count"]} records but there are #{countOfRecords["LRM CT_POL Record Count"]} in LRM CDS for LRM CT_POL Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_POL Record Count"]} match the expected count for LRM CT_POL Record Count")
      end
    end
    if countOfRecords["LRM CT_POLCOMP Record Count"]
      if countOfRecords["LRM CT_POLCOMP Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_POLCOMP_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_POLCOMP_Record_Count"]} records but there are #{countOfRecords["LRM CT_POLCOMP Record Count"]} in LRM CDS for LRM CT_POLCOMP Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_POLCOMP Record Count"]} match the expected count for LRM CT_POLCOMP Record Count")
      end
    end
    if countOfRecords["LRM CT_PROALO Record Count"]
      if countOfRecords["LRM CT_PROALO Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_PROALO_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_PROALO_Record_Count"]} records but there are #{countOfRecords["LRM CT_PROALO Record Count"]} in LRM CDS for LRM CT_PROALO Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_PROALO Record Count"]} in the LRM CDS match the expected count for LRM CT_PROALO Record Count")
      end
    end
    if countOfRecords["LRM CT_PROALO_NOTICE Record Count"]
      if countOfRecords["LRM CT_PROALO_NOTICE Record Count"].to_i != expectedRecordsArray["expected_LRM_CT_PROALO_NOTICE_Record_Count"]
        errorMsg ="Expected #{expectedRecordsArray["expected_LRM_CT_PROAL_NOTICE_Record_Count"]} records but there are #{countOfRecords["LRM CT_PROALO_NOTICE Record Count"]} in LRM CDS for LRM CT_PROALO_NOTICE Record Count: rplID = #{rplId}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The rows inserted #{countOfRecords["LRM CT_PROALO_NOTICE Record Count"]}  match the expected count for LRM CT_PROALO_NOTICE Record Count")
      end
    end
  end
   # Depricated 
   #   Gets the counts of records in the CDS
  def get_count_records_in_CDS(rcdbclientlogid)
    query = "select count(*) as count_cds_components  from [CDS].[dbo].[Component] Com with (nolock)
 where com.fkLogid in (select  cds2logid from cds2.dbo.correlation where rcdblogid =  #{rcdbclientlogid});"
    results,error = tds_query("CDS",query)
    count_cds2_components =""
    results.each do |logid|
      count_cds_components = logid["count_cds_components"]
    end
    return count_cds_components
  end
   # Helper function.  Sets up the dc options
  def get_dc_options
    @auth = {:username => "Chris", :password => "ChrisGoodnight01"}
    options = {:digest_auth => @auth }
    return options
  end
   # Gets the DC job.  Checks the Dc log for errors.  
   #   workflow  the expected workfolow the system should get to
   #   secondIdentifier is the unique identifier
  def get_DC_jobid(workflow,secondIdentifier)
    begin
      dcBase = ""
      options = get_dc_options
      if @@environment.upcase == "QA_UK"
        dcBase = "dexw5151"
      elsif @@environment.upcase =="PREPROD_UK"
        dcBase = "DEXW5181"
      elsif  @@environment.upcase =="DEV_UK"
        dcBase = "detw5151"
      elsif  @@environment.upcase =="DEV_US"
        dcBase = "USTW5033"
      elsif  @@environment.upcase =="QA_US"
        dcBase = "USXW5052"
      end
      @util.logging("Checking DC logs for a job that matches the current run")
      jobsResponse = HTTParty.get("http://#{dcBase}/di/services/batch/jobs",options)
      if !(jobsResponse)
        jobsResponse = HTTParty.get("http://#{dcBase}/di/services/batch/jobs",options)
      end
      i = 0
      response = HTTParty.get("#{jobsResponse["jobs"]["job"][i][jobsResponse["jobs"]["job"][i].keys[0]]}/log",options)
      while (!(response.to_s.include?("#{secondIdentifier}") && response.to_s.include?("#{workflow}")) && (i<10))
        i  += 1
        @util.logging("checking job #{i}  #{jobsResponse["jobs"]["job"][i][jobsResponse["jobs"]["job"][i].keys[0]]} workflow :#{workflow} secondidentifier :#{secondIdentifier}")
        response = HTTParty.get("#{jobsResponse["jobs"]["job"][i][jobsResponse["jobs"]["job"][i].keys[0]]}/log",options)
      end
      if i <10
        @util.logging("The DC log for this run with process #{workflow} is  <a href =\"#{jobsResponse["jobs"]["job"][i][jobsResponse["jobs"]["job"][i].keys[0]]}/log\">#{jobsResponse["jobs"]["job"][i][jobsResponse["jobs"]["job"][i].keys[0]]}/log</a>")
        check_dc_log_for_errors(response)
        return response
      else
        @util.logging("Unable to find the DC log for #{workflow} with #{secondIdentifier}")
      end
    rescue HTTParty::Error
      @util.logging("JobsResponse had the error  #{jobsResponse.error}")

    rescue StandardError
      @util.logging("JobsResponse had an error error")
      # i.e. Timeout::Error, SocketError etc
      # binding.pry
    end
  end
   # Depricated
   #   checks the DC logs to see that emails were sent
   #   dcLog the full text of the DC log
   #   emailTypeArray  array of each of the emails to be searched for in the dc log
  def verify_dc_logs_for_emails_sent(dcLog,emailTypeArray)
    emailTypeArray.each do |emailType|
      emailFound = false
      timeEmailSent = ""
      emailSubject =""
      case emailType
      when "job id"
        emailFound,timeEmailSent,emailSubject = email_parser(dcLog,"Process Step Begin: [JobID Notification]","Process Execution End: [process_JobIDNotification] completed successfully.")
        emailSubject = "Data Connect Process Information"
      when "RCDB load finished"
        emailFound,timeEmailSent,emailSubject = email_parser(dcLog,"Email from DC: RCdB Load Finished","Scripting Step Begin: [MoveToArchive]")
      when "RCDB validation failed"
        emailFound,timeEmailSent,emailSubject = email_parser(dcLog,"Email from DC: RCdB Validation Failed","Process Step End: [Send failed notification] completed")
      when "CDS2 LOAD FINISHED"
        emailFound,timeEmailSent,emailSubject = email_parser(dcLog,"Email from DC: CDS2 Load Finished","SQL Session Started: [Cds2]")
      when "CDS2 Validation Failed"
        emailFound,timeEmailSent,emailSubject = email_parser(dcLog,"Email from DC: CDS2 Validation Failed","Process Execution End: [p_ValidateCDS2] completed successfully")
      when "Ready for Review"
        emailFound,timeEmailSent,emailSubject = email_parser(dcLog,"Email from DC: Ready for Review","Process Execution End: [p_ValidateCDS2]")
      when "Load to CDS completed"
        emailFound,timeEmailSent,emailSubject = email_parser(dcLog,"Email from DC: Completed","Process Execution End: [pCDS2_to_CDS]")
      when "LRM CDS load success"
        emailFound,timeEmailSent,emailSubject = email_parser(dcLog,"Email from DC: LRM CDS Load Success","Process Execution End: [p_CDS_to_LRM]")
      when "Initialization Failure"
        emailFound,timeEmailSent,emailSubject = email_parser(dcLog,"[Prep Initialization Email]","Process Execution End: [p_ClientFileRouting] completed successfully")
      end
      if emailFound == false
        errorMsg ="DC log did not show an email of type #{emailType}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The DC log showed an email of type #{emailType} being sent at #{timeEmailSent} with a subject of #{emailSubject}")
      end
    end
  end
   # Checks that expected emails are received at any given point
   #   emailTypeArray  array of emails to be checked ie ["job id","RCDB load finished","CDS2 LOAD FINISHED","Ready for Review"]
   #   testIdentifier the unique 4th qualifier of the test
  def new_email_checker(emailTypeArray,testIdentifier)
    begin
      @util.logging("--------------------------------------Begin Email Test Section--------------------------------------")
      @util.logging(" Checking for emails of type #{emailTypeArray} after 60 sec pause")
      sleep(60)
      cli = email_connection
      counter =0
      while cli == false && counter <10
        cli = email_connection
        counter += 1
      end
      zenithEmails = cli.get_folder_by_name 'ZenithEmails'
      items =zenithEmails.todays_items

      emailTypeArray.each do |emailType|
        i = 0
        emailFound = false
        while i < 20  && emailFound == false
          case emailType.upcase
          when "JOB ID"
            emailFound = items[i].subject.include?("Data Connect Process Information") ## we need the RCdB LogID or ReportingPeriodLogID in the email as well to truly identify
          when "RCDB LOAD FINISHED"
            emailFound = items[i].subject.include?("Email from DC: RCdB Load Finished") && items[i].subject.include?("#{testIdentifier}")
          when "RCDB VALIDATION FAILED"
            emailFound = items[i].subject.include?("Email from DC: RCdB Validation Failed") && items[i].subject.include?("#{testIdentifier}")
          when "RCDB VALIDATION PASSED WITH EXCEPTIONS"
            emailFound = items[i].subject.include?("Email from DC: RCdB Validation Passed with Exceptions") && items[i].subject.include?("#{testIdentifier}")
          when "RCDB VALIDATION PASSED"
            emailFound = items[i].subject.include?("Email from DC: RCdB Validation Passed") && items[i].subject.include?("#{testIdentifier}")
          when "RCDB LOAD FAILED"
            emailFound = items[i].subject.include?("Email from DC: RCdB Load Failed") && items[i].subject.include?("#{testIdentifier}")
          when "CDS2 LOAD FINISHED"
            emailFound = items[i].subject.include?("Email from DC: CDS2 Load Finished") && items[i].subject.include?("#{testIdentifier}")
          when "CDS2 VALIDATION PASSED"
            emailFound = items[i].subject.include?("Email from DC: CDS2 Validation Passed") && items[i].subject.include?("#{testIdentifier}")
          when "CDS2 VALIDATION FAILED"
            emailFound = items[i].subject.include?("Email from DC: CDS2 Validation Failed") && items[i].subject.include?("#{testIdentifier}")
          when "CDS2 LOOKUPS FAILED"
            emailFound = (items[i].subject.include?("Email from DC: CDS2 Lookups Failed") && items[i].subject.include?("#{testIdentifier}"))||(items[i].subject.include?("Email from DC: CDS2 lookups failed") && items[i].subject.include?("#{testIdentifier}"))
          when "READY FOR REVIEW"
            emailFound = items[i].subject.include?("Email from DC: Ready for Review") && items[i].subject.include?("#{testIdentifier}")
          when "LOAD TO CDS COMPLETED"
            emailFound = items[i].subject.include?("Email from DC: Completed")  ## we need the RCdB LogID or ReportingPeriodLogID in the email as well to truly identify
          when "CDS2 LOAD FAILED"
            emailFound = items[i].subject.include?("Email from DC: CDS2 Load Failed") && items[i].subject.include?("#{testIdentifier}")
          when "LRM CDS LOAD SUCCESS"
            emailFound = items[i].subject.include?("Email from DC: LRM CDS Load Success") ## we need the RCdB LogID or ReportingPeriodLogID in the email as well to truly identify
          when "LRM CDS LOAD FAILED"
            emailFound = items[i].subject.include?("Email from DC: LRM CDS Load Failed") ## we need the RCdB LogID or ReportingPeriodLogID in the email as well to truly identify
          when "CDS LOAD FAILED"
            emailFound = items[i].subject.include?("Email from DC: CDS Load Failed") ## we need the RCdB LogID or ReportingPeriodLogID in the email as well to truly identify
          when "INITIALIZATION FAILURE"
            emailFound = items[i].subject.include?("Email From DC: Initialization Failure") && items[i].body.include?("#{testIdentifier}")
          end
          if emailFound == true
            @util.logging("Received an email of type #{emailType} being sent at #{items[i].date_time_sent} with a subject of #{items[i].subject} and body of:\n  #{items[i].body}")
          elsif i == 19
            errorMsg ="The last 20 emails from today in ZenithEmails folder do not have an email of type #{emailType}"
            @util.logging(errorMsg)
            check_override(true,errorMsg,false)
            i += 1
          else
            i += 1

          end


        end #while end
      end #each end
      @util.logging("--------------------------------------End Email Test Section--------------------------------------")

    rescue
      @util.logging("Error connecting to exchange.  No emails retrieved")
    end
  end
   # Helper function for email
   #   handles the email connection for retrieving zenith emails 
  def email_connection
    begin
      endpoint = 'https://us6x5003.hannover-re.grp:444/EWS/exchange.asmx'
      user = 'g0h'
      pass = 'G00dnight$3'
      #opts = http_opts: {ssl_verify_mode: 0}

      cli = Viewpoint::EWSClient.new endpoint, user, pass,http_opts: {ssl_verify_mode: 0}
      return cli
    rescue  StandardError => msg
      @util.logging("New email had an error.  No emails retrieved #{msg}")
      return false
    end
  end
   # Helper function for new email parser
   #   dcLog the entire dcLog as text
   #   start  the expected string to start the search for to find the email in the log
   #   end the expected string to end the sear for to find the email in the log
  def email_parser(dcLog,start,stop)
    if dcLog
      startEmail = dcLog.index(start)
      emailFound = false
      timeEmailSent =""
      emailSubject = ""
      if startEmail
        emailFound = true
        endEmail = dcLog[startEmail..dcLog.length].index(stop) + startEmail
        if !(endEmail)
          @util.logging("Couldn't find the end of the email #{stop}")
          emailFound = false
        else

          invokerSuccessful = dcLog[startEmail..endEmail].index("*** Invoker Step End:")

          connected = dcLog[startEmail..endEmail].index("connected") + startEmail
          if !(invokerSuccessful)
            @util.logging("Couldn't find the invoker  Invoker Step End:")
            emailFound = false
          else
            invokerSuccessful = invokerSuccessful - 1 + startEmail
            connected = connected +9
            timeEmailSent = dcLog[connected..invokerSuccessful].gsub("1      0 O Global","").gsub("\r\n","").rstrip
            subjectStart = dcLog[startEmail..endEmail].index("EmailSubject macro value ------------------------------")
            subjectStart = subjectStart + startEmail + 55
            subjectEnd = dcLog[startEmail..endEmail].index("EmailtoList macro value ------------------------------")
            subjectEnd = subjectEnd + startEmail - 99
            emailSubject = dcLog[subjectStart..subjectEnd].gsub("\r\n","")
          end
        end
      end
      if start =="Email From DC: Initialization Failure"
      #  binding.pry
      end
      return emailFound,timeEmailSent,emailSubject
    else
      @util.logging("No DC log to parse")
      return false,"",""
    end
  end
   # Helper function that checks if there are any "Status Code" errors in the DC log
   #   If there are errors then an error is logged and the test proceeds on. 
  def check_dc_log_for_errors(dcLog)
    if   @@filebase.include?("SMOKE4")
      errorsArray = ["Status Code","Error Description"]
    else
      errorsArray = ["Status Code","Email From DC: Initialization Failure","Error Description"]
    end
    errorsArray.each do |errorString|
      errorCount = 0
      errorCount = dcLog.scan(/(?=#{errorString})/).count
      if ((errorCount > 0) && (errorString  == "Error Description"))
         errorMsg ="There are #{errorCount} #{errorString} error messages in the DC log"
         insert_warning(errorMsg)
        elsif ((errorCount > 0) && (errorString  != "Error Description")) 
        errorMsg ="There are #{errorCount} #{errorString} error messages in the DC log"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      else
        @util.logging("There are no #{errorString} errors in the DC log")
      end
    end
  end
   # Gets the error log report  Visual
   #   testIdentifier the unique 4th qualifier of the specific RPL
   #   identifier  The error report to get
  def get_error_log_report(testIdentifier,identifier)
    begin
      click_element(:xpath,"//span[contains(text(),'#{testIdentifier}')]/../../td[6]","Error Report")
      sleep(1)
      switch_to_tab("NEWEST")
    
       viewReportButton = check_if_exist(:xpath,"//input[@id='ReportViewerControl_ctl04_ctl00']","Check that the View report button exists")
      
      globalValidations =  check_if_exist(:xpath,"//div[contains(text(),'Global Validations')]","Check that the Global Validations section comes up")

      outputCompanyValidations =  check_if_exist(:xpath,"//div[contains(text(),'Output Company Validations')]","Check that the Global Validations section comes up")

      if (viewReportButton == false) || (globalValidations == false) || (outputCompanyValidations == false)
         errorMsg ="The report did not come up"
         @util.logging(errorMsg)
         check_override(true,errorMsg,false)
      else
               reportTitle = get_element_text(:xpath,"//div[@aria-label = 'Report text']","Report Title Text")
      @util.logging("The report #{reportTitle} came up")
  
      sleep(2)
      take_snapshot("Error Report #{identifier}")
      end
      switch_to_tab("parent")
    rescue  StandardError => msg
      @util.logging("Unable to get the error report #{msg}")
       switch_to_tab("parent")
      return false
    end
  end
   # Checks the event status dropdown has the expected array of values
   #   precondition -  In the Reporting Period log modal for a specific RPL
   #   arrayOfExpectedVal-  an array of values that are expected to be in the dropdown ie ["Cancelled","Load to CDS","Redo Lookups"]
  def verify_event_status_dropdown_values(arrayOfexpectedVal)
    dropDownTxt = @driver.find_element(:xpath, "//input[@id='eventStatus_ct']/..").text
    arrayOfexpectedVal.each do |expectVal|
      if (expectVal=="") && (dropDownTxt =="")
        @util.logging("There are no Event Statuses in the dropdown as expected")
      elsif (expectVal =="")  && (dropDownTxt !="")
        errorMsg ="There are values in the dropdown when there were supposed to me no values"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif dropDownTxt.include?(expectVal)
        @util.logging("Event Status dropdown has #{expectVal}")
      else
        errorMsg ="Event Status dropdown does not have the expected Value of #{expectVal}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      end
    end
    @util.logging("Event Status dropdown has \n'#{dropDownTxt}'")
  end
   # Runs DC main for the current environment.  Rest call
  def run_dc_main
    @util.logging("Sending REST request to DC to start Main")
    @auth,dcBase = get_dc_auth_base
    #binding.pry
    data ={"runtimeConfig": {"description": "","entryPoint": "CDM-#{@@mainVersion}/p_Main.process","logLevel": "INFO","macroSetNames": ["CDS2Macroset","CDSMacroset","DBMacroSet","DBMacroSetPerf","FileNameParsing","HLR_Proto","LRM","LRMMacroset","SMTP","SchemaMapping","WorkflowMacroset","ZenithMacroSet","di_ExportDesignRepository","di_Services"],"profiling": false,"packageName": "CDM","inMessages": [],"packageVersion": "#{@@mainVersion}","transformOptions": {"nullOption": "ERROR","overflowOption": "ERROR","truncationOption": "ERROR"},"variableInitialValues": [{"name": "varLogId","value": "cdsLogId"},{"name": "varReportingPeriodId","value": "369"}],"datasetConfigs": {"namedDatasets": [],"namedSessions": []},"macroDefinitions": [],"profile_mask": -1,"profile_output_file": "profile.out","execution_options": {"jvmargs": "","classpath_list": [],"use_jvmargs": false}} }

    options = {
      :body => data.to_json,
      :digest_auth => @auth,
      :headers => {
        "Content-Type" => "application/json"
    } }
    endpoint = "http://#{dcBase}/di/services/batch/jobs"
    #data ={"runtimeConfig":{"description":"","entryPoint": "CDM-34.0/p_Main.process","logLevel": "INFO","macroSetNames":["CDS2Macroset","CDSMacroset","DBMacroSet","DBMacroSetPerf","FileNameParsing","HLR_Proto","LRM","LRMMacroset","SMTP","SchemaMapping","WorkflowMacroset","ZenithMacroSet","di_ExportDesignRepository","di_Services"],"profiling": false,"packageName": "CDM","inMessages": [],"packageVersion": "34.0","transformOptions":{"nullOption": "ERROR","overflowOption": "ERROR","truncationOption": "ERROR"},"variableInitialValues":[{"name": "varLogId","value": "cdsLogId"},{"name": "varReportingPeriodId","value": "369"}],"datasetConfigs":{"namedDatasets": [],"namedSessions": []},"macroDefinitions": [],"profile_mask": -1,"profile_output_file": "profile.out","execution_options": {"jvmargs": "","classpath_list": [],"use_jvmargs": false}} }
    response = HTTParty.post(endpoint,options)
    logLocation = response["location"]
    @util.logging("DC Main(#{@@mainVersion}) job created at  <a href =\"#{logLocation}\">#{logLocation}</a>   add /log at the end to see the log")

    get_current_client_file_validations_and_thresholds
    return logLocation
  end
   # Runs DC conductor for the current environment. Rest call.
  def run_dc_conductor
    @util.logging("Sending REST request to DC to start conductor")
    @auth,dcBase = get_dc_auth_base

    data ={"runtimeConfig": {"description": "","entryPoint": "CDM-#{@@conductorVersion}/p_Conductor.process","logLevel": "INFO","macroSetNames": [ "di_Services","ZenithMacroSet","WorkflowMacroset","SMTP","HLR_Proto","FileNameParsing","DBMacroSet","CDS2Macroset"],"profiling": false,"packageName": "CDM","inMessages": [],"packageVersion": "#{@@conductorVersion}","transformOptions": {"nullOption": "ERROR","overflowOption": "ERROR","truncationOption": "ERROR"},"variableInitialValues": [{"name": "varLogId","value": "cdsLogId"},{"name": "varReportingPeriodId","value": "369"}],"datasetConfigs": {"namedDatasets": [],"namedSessions": []},"macroDefinitions": [],"profile_mask": -1,"profile_output_file": "profile.out","execution_options": {"jvmargs": "","classpath_list": [],"use_jvmargs": false}} }

    options = {
      :body => data.to_json,
      :digest_auth => @auth,
      :headers => {
        "Content-Type" => "application/json"
    } }
    endpoint = "http://#{dcBase}/di/services/batch/jobs"
    #data ={"runtimeConfig":{"description":"","entryPoint": "CDM-34.0/p_Main.process","logLevel": "INFO","macroSetNames":["CDS2Macroset","CDSMacroset","DBMacroSet","DBMacroSetPerf","FileNameParsing","HLR_Proto","LRM","LRMMacroset","SMTP","SchemaMapping","WorkflowMacroset","ZenithMacroSet","di_ExportDesignRepository","di_Services"],"profiling": false,"packageName": "CDM","inMessages": [],"packageVersion": "34.0","transformOptions":{"nullOption": "ERROR","overflowOption": "ERROR","truncationOption": "ERROR"},"variableInitialValues":[{"name": "varLogId","value": "cdsLogId"},{"name": "varReportingPeriodId","value": "369"}],"datasetConfigs":{"namedDatasets": [],"namedSessions": []},"macroDefinitions": [],"profile_mask": -1,"profile_output_file": "profile.out","execution_options": {"jvmargs": "","classpath_list": [],"use_jvmargs": false}} }
  
    response = HTTParty.post(endpoint,options)
    logLocation = response["location"]

    @util.logging("DC Conductor(#{@@conductorVersion}) job created at <a href =\"#{logLocation}\">#{logLocation}</a> add /log at the end to see the log")
    get_current_client_file_validations_and_thresholds
    return logLocation
  end
   # Helper function for setting up the DC authorization base
  def get_dc_auth_base
    dcBase = ""
    if @@environment.upcase == "QA_UK"
      dcBase = "dexw5151"
    elsif @@environment.upcase =="PREPROD_UK"
      dcBase = "DEXW5181"
    elsif  @@environment.upcase =="DEV_UK"
      dcBase = "detw5151"
    elsif  @@environment.upcase =="DEV_US"
      dcBase = "USTW5033"
    elsif  @@environment.upcase =="QA_US"
      dcBase = "USXW5052"
    end
    @auth = {:username => "Chris", :password => "ChrisGoodnight01"}
    return @auth,dcBase
  end
   # NOT USED
   #   runs the DC CDS  for the given environment
  def run_dc_cds
    @util.logging("Sending REST request to DC to start CDS")
    #require "HTTParty"
    @auth,dcBase = get_dc_auth_base

    data ={"runtimeConfig": {"description": "","entryPoint": "CDM-#{@@cdsVersion}/pCDS2_to_CDS.process","logLevel": "INFO","macroSetNames": [ "CDS2Macroset","CDSMacroSet","DBMacroSet","SMTP","ZenithMacroSet","WorkflowMacroset"],"profiling": false,"packageName": "CDM","inMessages": [],"packageVersion": "#{@@cdsVersion}","transformOptions": {"nullOption": "ERROR","overflowOption": "ERROR","truncationOption": "ERROR"},"variableInitialValues": [{"name": "varLogId","value": "cdsLogId"},{"name": "varReportingPeriodId","value": "369"}],"datasetConfigs": {"namedDatasets": [],"namedSessions": []},"macroDefinitions": [],"profile_mask": -1,"profile_output_file": "profile.out","execution_options": {"jvmargs": "","classpath_list": [],"use_jvmargs": false}} }

    options = {
      :body => data.to_json,
      :digest_auth => @auth,
      :headers => {
        "Content-Type" => "application/json"
    } }
    endpoint = "http://#{dcBase}/di/services/batch/jobs"
    #data ={"runtimeConfig":{"description":"","entryPoint": "CDM-34.0/p_Main.process","logLevel": "INFO","macroSetNames":["CDS2Macroset","CDSMacroset","DBMacroSet","DBMacroSetPerf","FileNameParsing","HLR_Proto","LRM","LRMMacroset","SMTP","SchemaMapping","WorkflowMacroset","ZenithMacroSet","di_ExportDesignRepository","di_Services"],"profiling": false,"packageName": "CDM","inMessages": [],"packageVersion": "34.0","transformOptions":{"nullOption": "ERROR","overflowOption": "ERROR","truncationOption": "ERROR"},"variableInitialValues":[{"name": "varLogId","value": "cdsLogId"},{"name": "varReportingPeriodId","value": "369"}],"datasetConfigs":{"namedDatasets": [],"namedSessions": []},"macroDefinitions": [],"profile_mask": -1,"profile_output_file": "profile.out","execution_options": {"jvmargs": "","classpath_list": [],"use_jvmargs": false}} }
    response = HTTParty.post(endpoint,options)
    logLocation = response["location"]

    @util.logging("DC CDS(#{@@cdsVersion}) job created at <a href =\"#{logLocation}\">#{logLocation}</a> add /log at the end to see the log")
    get_current_client_file_validations_and_thresholds
    return logLocation
  end
   # NOT USED
   #   runs the DC lrm for the given environment
  def run_dc_lrm
    @util.logging("Sending REST request to DC to start LRM")
    #require "HTTParty"
    @auth,dcBase = get_dc_auth_base
    data ={"runtimeConfig": {"description": "","entryPoint": "LRM-#{@@lrmVersion}/p_CDS_to_LRM.process","logLevel": "INFO","macroSetNames": [ "CDS2Macroset","CDSMacroSet","DBMacroSet","SMTP","ZenithMacroSet"],"profiling": false,"packageName": "LRM","inMessages": [],"packageVersion": "#{@@lrmVersion}","transformOptions": {"nullOption": "ERROR","overflowOption": "ERROR","truncationOption": "ERROR"},"variableInitialValues": [{"name": "varLogId","value": "cdsLogId"},{"name": "varReportingPeriodId","value": "369"}],"datasetConfigs": {"namedDatasets": [],"namedSessions": []},"macroDefinitions": [],"profile_mask": -1,"profile_output_file": "profile.out","execution_options": {"jvmargs": "","classpath_list": [],"use_jvmargs": false}} }

    options = {
      :body => data.to_json,
      :digest_auth => @auth,
      :headers => {
        "Content-Type" => "application/json"
    } }
    endpoint = "http://#{dcBase}/di/services/batch/jobs"
    #data ={"runtimeConfig":{"description":"","entryPoint": "CDM-34.0/p_Main.process","logLevel": "INFO","macroSetNames":["CDS2Macroset","CDSMacroset","DBMacroSet","DBMacroSetPerf","FileNameParsing","HLR_Proto","LRM","LRMMacroset","SMTP","SchemaMapping","WorkflowMacroset","ZenithMacroSet","di_ExportDesignRepository","di_Services"],"profiling": false,"packageName": "CDM","inMessages": [],"packageVersion": "34.0","transformOptions":{"nullOption": "ERROR","overflowOption": "ERROR","truncationOption": "ERROR"},"variableInitialValues":[{"name": "varLogId","value": "cdsLogId"},{"name": "varReportingPeriodId","value": "369"}],"datasetConfigs":{"namedDatasets": [],"namedSessions": []},"macroDefinitions": [],"profile_mask": -1,"profile_output_file": "profile.out","execution_options": {"jvmargs": "","classpath_list": [],"use_jvmargs": false}} }
    response = HTTParty.post(endpoint,options)
    logLocation = response["location"]

    @util.logging("DC LRM(#{@@lrmVersion}) job created at <a href =\"#{logLocation}\">#{logLocation}</a> add /log at the end to see the log")
    get_current_client_file_validations_and_thresholds
    return logLocation
  end
   # Gets the CURRENT lookups,validations and thresholds for a client file based off of the current OCC.  Puts the results into the logs
  def get_current_client_file_validations_and_thresholds
    query = "select
cm.CompanyName, VR.RuleName,CSVR.threshold
from 
ClientFile cf 
JOIN OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
JOIN OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
JOIN CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
JOIN CompanyMaster cm on cs.FK_OutputCompanyId = cm.CompanyMasterId
JOIN CompanySplitValidationRuleLink CSVR ON CSVR.CompanySplitId = cs.CompanySplitId
JOIN ValidationRule VR ON VR.VAlidationRuleId = CSVR.ValidationRuleId
WHERE cf.fourthQualifier = 'Test#{@@db_id}' and csvr.activeflag = 1"
    results,error = tds_query("Zenith",query)
    if error != ""
      errorMsg ="Unable to query the database for the current validations and thresholds"
      @util.logging(errorMsg)
      check_override(true,errorMsg,false)
    else
      @util.logging("------The file is running with the current validations and thresholds-----")
      results.each do |result|
        @util.logging(result)
      end
      query2 = "select
cm.CompanyName, LU.LookupName
from 
ClientFile cf 
JOIN OutputCompanyCriteriaClientFileLink OCCCFL ON OCCCFL.ClientFileId = cf.ClientFileId
JOIN OutputCompanyCriteria OCC ON OCC.OutputCompanyCriteriaId = OCCCFL.OutputCompanyCriteriaId
JOIN CompanySplit cs on cs.CriteriaId = occ.OutputCompanyCriteriaId 
JOIN CompanyMaster cm on cs.FK_OutputCompanyId = cm.CompanyMasterId
JOIN CompanySplitLookupLink CSLL ON CSLL.CompanySplitId = cs.CompanySplitId
JOIN Lookup LU ON LU.LookupId = CSLL.LookupId
WHERE cf.fourthQualifier = 'Test#{@@db_id}' "
      results,error = tds_query("Zenith",query2)
      if error != ""
        errorMsg ="Unable to query the database for the current lookups"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      else
        @util.logging("------The file is running with the current lookups-----")
        results.each do |result|
          @util.logging(result)
        end
      end

      @util.logging("--------------------------------------------------------------------------")
    end
  end
   # Gets the cds2 logids based off of the RCDBlogid
   #   rcdblogid
  def get_cds2LogIds(rcdblogid)
    cds2LogIds = Array.new
    query = "select distinct cds2LogID from cds2.dbo.correlation where [RcDbLogID] = '#{rcdblogid}'"
    results,error = tds_query("Zenith",query)
    #binding.pry
    if error != ""
      errorMsg ="Unable to get the cds2logId for #{rcdblogid}"
      @util.logging(errorMsg)
      check_override(true,errorMsg,false)
     # binding.pry
    else
      results.each do |result|
        cds2LogIds.push(result)
      end
    end
    @util.logging("The cds2LogIds for #{rcdblogid} are #{cds2LogIds}")
    return cds2LogIds
  end
   # Sends a test request to the DC for a specific environment for the DC schedules to get the version for each of the packages
   #   stores the value for each package in the automation database
  def get_dc_versions
    lrmVersion =""
    mainVersion =""
    cdsVersion = ""
    conductorVersion = ""

    @util.logging("Sending REST request to DC for schedules")
    #require "HTTParty"
    @auth,dcBase = get_dc_auth_base
    options = {
      :digest_auth => @auth,
      :headers => {
        "Content-Type" => "application/json"
    } }
    endpoint = "http://#{dcBase}/di/services/batch/schedules/"
    #data ={"runtimeConfig":{"description":"","entryPoint": "CDM-34.0/p_Main.process","logLevel": "INFO","macroSetNames":["CDS2Macroset","CDSMacroset","DBMacroSet","DBMacroSetPerf","FileNameParsing","HLR_Proto","LRM","LRMMacroset","SMTP","SchemaMapping","WorkflowMacroset","ZenithMacroSet","di_ExportDesignRepository","di_Services"],"profiling": false,"packageName": "CDM","inMessages": [],"packageVersion": "34.0","transformOptions":{"nullOption": "ERROR","overflowOption": "ERROR","truncationOption": "ERROR"},"variableInitialValues":[{"name": "varLogId","value": "cdsLogId"},{"name": "varReportingPeriodId","value": "369"}],"datasetConfigs":{"namedDatasets": [],"namedSessions": []},"macroDefinitions": [],"profile_mask": -1,"profile_output_file": "profile.out","execution_options": {"jvmargs": "","classpath_list": [],"use_jvmargs": false}} }
    response = HTTParty.get(endpoint,options)
    schedules = response["schedules"]["schedule"]
    schedules.each do |schedule|
      scheduleDetail = HTTParty.get(schedule["href"],options)
      scheduleName =  scheduleDetail["schedule"]["name"]
      schedulePackageVersion = scheduleDetail["schedule"]["runtimeConfig"]["packageVersion"]
      schedulePackageName = scheduleDetail["schedule"]["runtimeConfig"]["packageName"]
      scheduleEntryPoint = scheduleDetail["schedule"]["runtimeConfig"]["entryPoint"]
      @util.logging("Name:#{scheduleName} PackageVersion:#{schedulePackageVersion} entryPoint:#{scheduleEntryPoint} PackageName:#{schedulePackageName}")
      case scheduleName
      when "Conductor"
        conductorVersion = schedulePackageVersion
      when "Main"
        mainVersion = schedulePackageVersion
      when "CDS"
        cdsVersion = schedulePackageVersion
      when "LRM"
        lrmVersion = schedulePackageVersion
      end
    end
    query = "update Automation.dbo.environments
set main_version = '#{mainVersion}',
conductor_version ='#{conductorVersion}',
cds_version = '#{cdsVersion}',
lrm_version ='#{lrmVersion}',
zenith_version ='#{@@branch}'
where environment_name ='#{@@environment}'" 
    results =  run_automation_db_query(query)
  end
   # Gets the DC and Zenith versions for a specific environment that is stored in the automation database.  Saves the values in global variables
  def get_stored_dc_versions
    query = "select main_version,conductor_version,cds_version,lrm_version,zenith_version from Automation.dbo.environments
      where environment_name ='#{@@environment}'" 
    results =  run_automation_db_query(query)

    results.each do |result|
      @@mainVersion = result["main_version"].strip
      @@conductorVersion =result["conductor_version"].strip
      @@cdsVersion = result["cds_version"].strip
      @@lrmVersion = result["lrm_version"].strip
      @@zenithVersion = result["zenith_version"].strip
    end
    @util.logging("DC Main:#{@@mainVersion} Conductor:#{@@conductorVersion} CDS:#{@@cdsVersion} LRM:#{@@lrmVersion} Zenith:#{@@zenithVersion}")
  end
   # Add a lookup condition
   #   precondition  on the edit page of a specific lookup
   #   logicalOperator
   #   columnShort
   #   operator
   #   inputValues
   #   description
   #   comments
  def add_lookup_condition(logicalOperator,columnShort,operator,inputValues,description,comments)
    if logicalOperator != ""
      enter_text(:xpath,"//input[@id='lOp_ct']","#{logicalOperator}","Logical Operator")
      @driver.action.send_keys("\ue015").perform
      @driver.action.send_keys("\ue007").perform
    end
    enter_text(:xpath,"//input[@id='ceColumn_ct']","#{columnShort}","Column Short Name")
   # binding.pry
   # click_element(:xpath,"//a[text()='#{columnShort}']","Selecting #{columnShort} "  )
  #wait_for_element(:xpath,"//a[contains(text(),'#{columnShort}')]", "Waiting for the dropdown to show", 60)
  sleep(20)
  dropdown = @driver.find_elements(:xpath,"//a[contains(text(),'#{columnShort}')]")
  selected = false
  numdropdowns = dropdown.count - 1
  for i in 0..numdropdowns
    #binding.pry
    if (dropdown[i].text == columnShort) && (selected == false)
      dropdown[i].click
      @util.logging("Clicking on Column Short name and selecting #{columnShort}")
      selected = true
   end
 end
   # @driver.action.send_keys("\ue015").perform
   # @driver.action.send_keys("\ue007").perform
    enter_text(:xpath,"//input[@id ='ceOperator_ct']","#{operator}","Operator Drop Down")
    @driver.action.send_keys("\ue015").perform
    if operator == "Less than"
      @driver.action.send_keys("\ue015").perform
    end
    if operator == "Equal to"
      @driver.action.send_keys("\ue013").perform
    end
    if operator == "Greater than"
      @driver.action.send_keys("\ue013").perform
      # binding.pry
    end

    @driver.action.send_keys("\ue007").perform

    #click_element(:xpath,"//a[contains(text(),'#{operator}')]","#{operator} from Operator Drop down")
    if inputValues != ""
      if operator.include?("BETWEEN",)
        enter_text(:xpath,"//input[@id='param1_ct']","#{inputValues[0]}","Entering values into From")
        enter_text(:xpath,"//input[@id='param2_ct']","#{inputValues[1]}","Entering values into To")
      elsif (operator.include?("Less than")) || (operator.include?("Less than or equal to")) ||(operator.include?("Not equal to")) || (operator.include?("Equal to")) ||(operator.include?("Greater than")) ||(operator.include?("Greater than or Equal to")) || (operator.include?("Like")) || (operator.include?("Contains"))
        enter_text(:xpath,"//input[@id='val1_ct']","#{inputValues}","Entering values into Input Values")
      elsif (operator.include?("In list"))
        enter_text(:xpath,"//textarea[@id='val2_ct']","#{inputValues}","Entering values into Input Values")
      elsif  (operator.include?("Substring"))
        enter_text(:xpath,"//input[@id='param1_ct']","#{inputValues[0]}","Entering values into Start Position")
        enter_text(:xpath,"//input[@id='val1_ct']","#{inputValues[1]}","Entering values into Input Values")
      end
    end
    enter_text(:xpath,"//textarea[@id='desc_ct']","#{description}","Description Field")
    enter_text(:xpath,"//textarea[@id='cmt_ct']","#{comments}","Comments Field")
    addButtons2 = @driver.find_elements(:xpath,"//button[contains(text(),'Add')]")
    addButtons2[2].click
    sleep(10)
  end
    # Clicks on a specific lookup conditions
    #   precondition  on the edit page of a specific lookup
    #   groupNumber is the number of lookup condition groups from top to bottom in lookup conditions.  0 to n
  def click_lookup_conditon(groupNumber)
    @util.logging("Clicking the condition button")
    conditionButtons =@driver.find_elements(:xpath,"//button[contains(text(),'Condition')]")
    conditionButtons[groupNumber].click
  end
   # Deletes a group in lookup conditions
   #   precondition  on the edit page of a specific lookup
   #   groupNumber is the number of lookup condition groups from top to bottom in lookup conditions 0 to N
   #   Note all conditions must be deleted out of the group before
  def delete_group(groupNumber)
    @util.logging("Clicking the condition button")
    conditionButtons =@driver.find_elements(:xpath,"//button[contains(text(),'Condition')]")
    @driver.action.context_click(conditionButtons[groupNumber]).perform
    @util.logging("Clicking the Delete button")
    #@test.click_element(:xpath,"//*[contains(text(),'Delete')]","Delete button")
    @driver.action.send_keys("\u0009").perform
    @driver.action.send_keys("\ue007").perform
    confirmationDialog = wait_for_element(:xpath,"//span[contains(text(),'Confirmation')]",": Confirmation Dialog for Delete")
    confirmationDialogText = get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]/span","Confirmation Dialog Box Text")
    if (confirmationDialogText.include?("Are you sure you want to delete?") != true)
      errorMsg ="The confirmation dialog does not have the correct message"
      @util.logging(errorMsg)
      check_override(true,errorMsg,false)
    elsif
      @util.logging("The confirmation dialog has the correct message\n#{confirmationDialogText}")
    end
    click_element(:xpath,"//button/span[contains(text(),'Yes')]","Yes button on Delete Condition window")
  end
   # Clicks a lookup condition group
   #   modifier is either 'AND' or 'OR'
   #   level is either 1 or 2 
  def click_lookup_group(modifier,level)
    if level == 1
      click_element(:xpath,"//ng-component/app-lookup-condition-list/div[2]/div/div/div/div/div/button","Group Button")
      click_element(:xpath,"//a[contains(text(),'#{modifier}')]","#{modifier} button")
      sleep(5)
    elsif level ==2
      click_element(:xpath,"//app-lookup-condition-group/div/div/div[2]/div/button","Secondary Group Button")
      if modifier == "AND"
        click_element(:xpath,"//app-lookup-condition-group/div/div/div[2]/div/ul/li","#{modifier} button")
      elsif modifier =="OR"
        click_element(:xpath,"//app-lookup-condition-group/div/div/div[2]/div/ul/li[2]","#{modifier} button")
      end
      sleep(5)
    end
  end
   # Deletes a lookup condition. Checks whether the delete should check all delete options or just the no
   #   Precondition-  on the edit page for the specific lookup to delete a condition from
   #   identifier - one of the unique visible text identifiers in the condition
   #   confirmation check  Full to check each of the possible confirmations of the delete(yes,X, no)
  def delete_lookup_condition(identifier,confirmationCheck)
    if confirmationCheck == "Full"
      right_click_element(:xpath,"//div[contains(text(),'#{identifier}')]","#{identifier} Condition from a group")
      sleep(1)
      @util.logging("Clicking the Delete button")
      #@test.click_element(:xpath,"//*[contains(text(),'Delete')]","Delete button")
      @driver.action.send_keys("\u0009").perform
      @driver.action.send_keys("\ue007").perform

      confirmationDialog = wait_for_element(:xpath,"//span[contains(text(),'Confirmation')]",": Confirmation Dialog for Delete")
      confirmationDialogText = get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]/span","Confirmation Dialog Box Text")
      if (confirmationDialogText.include?("Are you sure you want to delete?") != true)
        errorMsg ="The confirmation dialog does not have the correct message"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The confirmation dialog has the correct message\n#{confirmationDialogText}")
      end
      click_element(:xpath,"//button/span[contains(text(),'No')]","No button on Delete Condition window")
      right_click_element(:xpath,"//div[contains(text(),'#{identifier}')]","#{identifier} Condition from a group")
      @util.logging("Clicking the Delete button")
      #@test.click_element(:xpath,"//*[contains(text(),'Delete')]","Delete button")
      @driver.action.send_keys("\u0009").perform
      @driver.action.send_keys("\ue007").perform

      confirmationDialog = wait_for_element(:xpath,"//span[contains(text(),'Confirmation')]",": Confirmation Dialog for Delete")
      confirmationDialogText = get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]/span","Confirmation Dialog Box Text")
      if (confirmationDialogText.include?("Are you sure you want to delete?") != true)
        errorMsg ="The confirmation dialog does not have the correct message"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The confirmation dialog has the correct message\n#{confirmationDialogText}")
      end
      click_element(:xpath,"//span[contains(text(),'Confirmation')]/../a","X button on Delete Condition window")
    end
    right_click_element(:xpath,"//div[contains(text(),'#{identifier}')]","#{identifier} Condition from a group")
    @util.logging("Clicking the Delete button")
    #@test.click_element(:xpath,"//*[contains(text(),'Delete')]","Delete button")
    @driver.action.send_keys("\u0009").perform
    @driver.action.send_keys("\ue007").perform

    confirmationDialog = wait_for_element(:xpath,"//span[contains(text(),'Confirmation')]",": Confirmation Dialog for Delete")
    confirmationDialogText = get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]/span","Confirmation Dialog Box Text")
    if (confirmationDialogText.include?("Are you sure you want to delete?") != true)
      errorMsg ="The confirmation dialog does not have the correct message"
      @util.logging(errorMsg)
      check_override(true,errorMsg,false)
    elsif
      @util.logging("The confirmation dialog has the correct message\n#{confirmationDialogText}")
    end
    click_element(:xpath,"//button/span[contains(text(),'Yes')]","Yes button on Delete Condition window")
    sleep(5)
  end
   # Deletes a lookup. Checks whether the delete should check all delete options or just the no
   #   Precondition-  On the Zenith Mappings > Lookups page
   #   identifier the full name of the lookup
   #   confirmation check  Full to check each of the possible confirmations of the delete(yes,X, no)
    def delete_lookup(identifier,confirmationCheck)
    if confirmationCheck == "Full"
      #right_click_element(:xpath,"//div[contains(text(),'#{identifier}')]","#{identifier} Condition from a group")
      right_click_element(:xpath,"//span[contains(text(),'#{identifier}')]","#{identifier} Condition from a group")
      sleep(1)
      @util.logging("Clicking the Delete button")
      click_element(:xpath,"//p-contextmenusub/ul/li[2]/a/span[contains(text(),'Delete')]","Delete button")
      # binding.pry
      # @driver.action.send_keys("\u0009").perform
      # @driver.action.send_keys("\ue007").perform

      confirmationDialog = wait_for_element(:xpath,"//span[contains(text(),'Confirmation')]",": Confirmation Dialog for Delete")
      confirmationDialogText = get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]/span","Confirmation Dialog Box Text")
      if (confirmationDialogText.include?("Are you sure you want to delete?") != true)
        errorMsg ="The confirmation dialog does not have the correct message"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The confirmation dialog has the correct message\n#{confirmationDialogText}")
      end
      click_element(:xpath,"//button/span[contains(text(),'No')]","No button on Delete Condition window")
      right_click_element(:xpath,"//span[contains(text(),'#{identifier}')]","#{identifier} Condition from a group")
      @util.logging("Clicking the Delete button")
      click_element(:xpath,"//p-contextmenusub/ul/li[2]/a/span[contains(text(),'Delete')]","Delete button")
      #binding.pry
      #@driver.action.send_keys("\u0009").perform
      #@driver.action.send_keys("\ue007").perform

      confirmationDialog = wait_for_element(:xpath,"//span[contains(text(),'Confirmation')]",": Confirmation Dialog for Delete")
      confirmationDialogText = get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]/span","Confirmation Dialog Box Text")
      if (confirmationDialogText.include?("Are you sure you want to delete?") != true)
        errorMsg ="The confirmation dialog does not have the correct message"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
      elsif
        @util.logging("The confirmation dialog has the correct message\n#{confirmationDialogText}")
      end
      click_element(:xpath,"//span[contains(text(),'Confirmation')]/../a","X button on Delete Condition window")
    end
    right_click_element(:xpath,"//span[contains(text(),'#{identifier}')]","#{identifier} Condition from a group")
    @util.logging("Clicking the Delete button")
    click_element(:xpath,"//p-contextmenusub/ul/li[2]/a/span[contains(text(),'Delete')]","Delete button")

    confirmationDialog = wait_for_element(:xpath,"//span[contains(text(),'Confirmation')]",": Confirmation Dialog for Delete")
    confirmationDialogText = get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]/span","Confirmation Dialog Box Text")
    if (confirmationDialogText.include?("Are you sure you want to delete?") != true)
      errorMsg ="The confirmation dialog does not have the correct message"
      @util.logging(errorMsg)
      check_override(true,errorMsg,false)
    elsif
      @util.logging("The confirmation dialog has the correct message\n#{confirmationDialogText}")
    end
    click_element(:xpath,"//button/span[contains(text(),'Yes')]","Yes button on Delete Condition window")
    sleep(5)
  end
   # Adds a new  non SQL lookup
   #   Precondition - On the Zenith Mappings > Lookups page
   #   lookupName
   #   outputColumn
   #   dataType
   #   description
  def add_new_lookup(lookupName,outputColumn,dataType,description)
    @util.logging("Clicking the Add button")
    addButtons= @driver.find_elements(:xpath,"//button")
    addButtons[0].click
    click_element(:xpath,"//a[@href ='/lookup/add']","Lookup from Add button")
    enter_text(:xpath,"//input[@id='lookupName_ct']","#{lookupName}","Lookup Name")
   
    enter_text(:xpath,"//input[@id='columnDefinition_ct']","#{outputColumn}","Output Column")
   # @driver.action.send_keys("\ue015").perform #down arrow
   # @driver.action.send_keys("\ue007").perform  #enter
    click_element(:xpath,"//li/a[contains(text(),'#{outputColumn}')]","Output Column containing #{outputColumn}") 
    click_element(:xpath,"//option[contains(text(),'#{dataType}')]","The #{dataType} button on Data Types")
    enter_text(:xpath,"//textarea[@id='description_ct']","#{description}","Description Field")
    @util.logging("Clicking the Add button at the bottom of the Lookups page")
    addButtons= @driver.find_elements(:xpath,"//button")
    addButtons[9].click  #Add button at the bottom of the Lookups Page
    sleep(5)
  end
   # Adds a new SQL lookup.  
   #   Precondition - On the Zenith Mappings > Lookups page
   #   lookupName
   #   startDate
   #   endDate
   #   description
   #   query
  def add_new_sql_lookup(lookupName,startDate,endDate,description,query)
    @util.logging("Clicking the Add button")
    addButtons= @driver.find_elements(:xpath,"//button")
    addButtons[0].click
    click_element(:xpath,"//a[@href ='/lookup/add/hybrid']","SQL Editor from Add button")
    enter_text(:xpath,"//input[@id='lookupName_ct']","#{lookupName}","Lookup Name")
    enter_text(:xpath,"//input[@id='startEffectiveDate_ct']","#{startDate}","Start Effective Date")
    enter_text(:xpath,"//input[@id='endEffectiveDate_ct']","#{endDate}","End Effective Date")
    enter_text(:xpath,"//textarea[@id='description_ct']","#{description}","Description Field")
    enter_text(:xpath,"//textarea[@id='query_ct']","#{query}","SQL Query")
    @util.logging("Clicking the Add button")
    addButtons= @driver.find_elements(:xpath,"//button")
    addButtons[0].click
    sleep(5)
  end
   # Adds a new lookup output code.  
   #   precondition is that the lookup has been created and the test is on the edit page of the lookup
   #   outputCodeValue
   #   startDate
   #   endDate
  def add_lookup_output_code(outputCodeValue,startDate,endDate)
    addButtons= @driver.find_elements(:xpath,"//button")
    @util.logging("Clicking the Add for Lookup Output Codes page")
    addButtons[0].click  #Add button for Lookup Output Codes
    enter_text(:xpath,"//input[@id='outputValue_ct']","#{outputCodeValue}")
    @driver.action.send_keys("\ue015").perform #down arrow
    @driver.action.send_keys("\ue007").perform  #enter
    enter_text(:xpath,"//input[@id='startEffectiveDate_ct']","#{startDate}","Start Effective Date")
    enter_text(:xpath,"//input[@id='endEffectiveDate_ct']","#{endDate}","End Effective Date")
    @util.logging("Clicking the Add button")
    addButtons= @driver.find_elements(:xpath,"//button[contains(text(),'Add')]")
    addButtons[1].click
    sleep(5)
  end
   # Checks that the add button is available on a given page
   #   page The page to check.  A string, based off of the main zenith menu with the menu name, a > and the dropdown value ie Zenith Mappings > Client Files
   #   shouldExist true or false 
  def check_for_add(page,shouldExist)
    enabledAdd = false
    if page =="Zenith Mappings > Lookup"
      checkForAdd = @driver.find_elements(:xpath,"//button")
    else
      checkForAdd = @driver.find_elements(:xpath,"//*[contains(text(),'Add')]")

    end
    checkForAdd.each do |addInstance|
      if addInstance.text.strip == "Add"
        enabledAdd = true
      end
    end
    if enabledAdd != shouldExist
      errorText = shouldExist ? "is not" : "is"
      errorMsg = "There #{errorText} an Add button on the #{page} page"
      @util.logging(errorMsg)
      check_override(true,errorMsg,true)
      return false
    else
      errorText = shouldExist ? "is" : "is not"
      @util.logging("There #{errorText} an Add button on the #{page} page")
    end
  end
   # Performs a basic search on each page. The searches are based off of values that should be in the baseline code. Used for permission tests
   #   page The page to check.  A string, based off of the main zenith menu with the menu name, a > and the dropdown value ie Zenith Mappings > Client Files  
  def standard_search_each_page(page)
    searchWorked = false
    case page
    when 'Zenith Mappings > Client Files'
      enter_text(:xpath,"//input[@id ='cmpSearch_ct']","9999")
      click_element(:xpath,"//a[contains(text(),'9999 - Integration Test Company')]","9999 - Integration Test Company the search dropdown")
      enter_text(:xpath,"//span[contains(text(),'Fourth Qualifier')]/../input","Test", "Fourth Qualifier Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("Test")
    when 'Zenith Mappings > Lookup'
    
      enter_text(:xpath,"//span[contains(text(),'Lookup Name')]/../input","Bad Lvl4_UAT_ONLY_DoNotDelete", "Lookup Name Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("Bad Lvl4_UAT_ONLY_DoNotDelete")
    when 'Zenith Mappings > Output Company Criteria'
      enter_text(:xpath,"//span[contains(text(),'Output Criteria')]/../input","Integration Testing OCC", "Output Criteria Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("Integration Testing OCC")
    when 'Business Reference > Column Definitions'
      enter_text(:xpath,"//span[contains(text(),'Column Short Name')]/../input","O_Original_Periodic_Annuity", "Column Short Name Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("O_Original_Periodic_Annuity")
    when 'Business Reference > Company'
      enter_text(:xpath,"//span[contains(text(),'Company Number')]/../input","9999", "Company Number Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("9999")
    when 'Business Reference > Entity'
      enter_text(:xpath,"//span[contains(text(),'Entity')]/../input","HRUK", "Entity Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("HRUK")
    when 'Business Reference > Standard Output Codes'
      enter_text(:xpath,"//span[contains(text(),'Column Full Name')]/../input","O_Account_Period", "Standard Outpu Codes Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("O_Account_Period")
    when 'Business Reference > Validation Rules'
      enter_text(:xpath,"//span[contains(text(),'Rule Name')]/../input","Life 1 Gender", "Validation Rules Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("Life 1 Gender")
    when 'System Reference > Data Types'
      enter_text(:xpath,"//span[contains(text(),'Data Type')]/../input","TANN", "Data Type Search")
      searchText = @driver.find_element(:xpath,"//p-datatable/div/div/table/tbody/tr[1]").text
      searchWorked = searchText.include?("TANN")
    when 'System Reference > Database Tables'
      enter_text(:xpath,"//span[contains(text(),'Table')]/../input","CT_ADDRESS", "Table Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("CT_ADDRESS")
    when 'System Reference > Event Status'
      enter_text(:xpath,"//span[contains(text(),'Status')]/../input","Cancelled", "Status Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("Cancelled")
    when 'System Reference > Operators'
      @util.logging("There is no search on Operators")
      searchWorked = true
    when 'System Reference > Target Databases'
      enter_text(:xpath,"//span[contains(text(),'Target Database')]/../input","RCdB", "Target Database Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("RCdB")
    when 'System Reference > Workflow Status'
      enter_text(:xpath,"//span[contains(text(),'Status')]/../input","Ready for Review", "Status Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("Ready for Review")
    when 'System Reference > Settings'
      @util.logging("There is no search on Settings")
      searchWorked = true
    when 'Workflow > Reporting Period Logs'
      enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_file_search],"9999","for Company ID in RPL search")
      sleep(5)
      @driver.action.send_keys("\ue015").perform #down arrow
      @driver.action.send_keys("\ue007").perform  #enter
      sleep(10)
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("Test")
    when 'Security > Roles'
      enter_text(:xpath,"//span[contains(text(),'Role Name')]/../input","PermissionsTesting", "Role Name Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("PermissionsTesting")
    when 'Security > Users'
      enter_text(:xpath,"//span[contains(text(),'Name')]/../input","Goodnight", "User Name Search")
      searchText = @driver.find_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]").text
      searchWorked = searchText.include?("Goodnight")
    end
    if searchWorked == false
      errorMsg = "The search on #{page} failed"
      @util.logging(errorMsg)
      check_override(true,errorMsg,true)
      return false
    else
      @util.logging("The search on #{page} got results")
    end

  end
   # Checks if the specified page has the edit and delete functions are available. Used for permission tests
   #   page The page to check.  A string, based off of the main zenith menu with the menu name, a > and the dropdown value ie Zenith Mappings > Client Files
   #   editShouldPass  true or false  
   #   deleteShouldPass true or false 
  def standard_edit_delete_each_page(page,editShouldPass,deleteShouldPass)
    deleteExist = false
    editExist = false
    case page
    when 'Zenith Mappings > Client Files'
      right_click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
     # binding.pry
      @util.logging("Checking that Delete is enabled")
      deleteExist = @driver.find_element(:xpath,"//span[contains(text(),'Delete')]/..").attribute("class").include?("ui-state-disabled") ? false : true
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      editExist = check_if_exist(:xpath,"//ul[@class='ui-menu-list']/li/a/span[contains(text(),'Edit')]","Checking for Edit")
     # binding.pry
    when 'Zenith Mappings > Lookup'
      right_click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")

     deleteButtons = @driver.find_elements(:xpath,"//ul[@class='ui-menu-list']/li[2]/a/span[contains(text(),'Delete')]/..")
    #  deleteButtons = @driver.find_elements(:xpath,"//ul[@class='ui-menu-list ui-helper-reset']/li[2]/a/span[contains(text(),'Delete')]/..")
      deleteExist = deleteButtons[0].attribute("class").include?("ui-state-disabled") ? false : true
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")

      @util.logging("Checking if the Lookup name is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='lookupName_ct']").attribute("disabled") ? false : true
      @driver.navigate.back()
    when 'Zenith Mappings > Output Company Criteria'
      right_click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking that Delete is enabled")
      deleteExist = @driver.find_element(:xpath,"//span[contains(text(),'Delete')]/..").attribute("class").include?("ui-state-disabled") ? false : true
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking if the Output Company Criteria is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='occName_ct']").attribute("disabled") ? false : true
      @driver.navigate.back()


    when 'Business Reference > Column Definitions'
      right_click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
     deleteExist = @driver.find_element(:xpath,"//span[contains(text(),'Delete')]/..").attribute("class").include?("ui-state-disabled") ? false : true
#binding.pry
     # deleteExist = check_if_exist(:xpath,"//span[contains(text(),'Delete')]","Checking for Delete")
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      sleep(5)
      @util.logging("Checking if the Database Table is editable")
      #binding.pry
      editExist = @driver.find_element(:xpath,"//input[@id ='dbTable_ct']").attribute("disabled") ? false : true
      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")

    when 'Business Reference > Company'
      right_click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking that Delete is enabled")
      deleteExist = @driver.find_element(:xpath,"//span[contains(text(),'Delete')]/..").attribute("class").include?("ui-state-disabled") ? false : true
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking if the Company Number is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='number_ct']").attribute("disabled") ? false : true
      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")


    when 'Business Reference > Entity'
      right_click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking that Delete is enabled")
      deleteExist = @driver.find_element(:xpath,"//span[contains(text(),'Delete')]/..").attribute("class").include?("ui-state-disabled") ? false : true
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking if the Entity is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='entityCode_ct']").attribute("disabled") ? false : true
      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")



    when 'Business Reference > Standard Output Codes'
      @util.logging("Delete is NEVER available for Standard Output Codes")
      deleteExist = "NA"
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking if the Column Full name is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='columnFull_ct']").attribute("disabled") ? false : true

    when 'Business Reference > Validation Rules'
      @util.logging("Delete is NEVER available for Validation Rules")
      deleteExist = "NA"
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking if the Entity is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='ruleName_ct']").attribute("disabled") ? false : true
      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")


    when 'System Reference > Data Types'
      right_click_element(:xpath,"//p-datatable/div/div/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking that Delete is enabled")
      deleteExist = @driver.find_element(:xpath,"//span[contains(text(),'Delete')]/..").attribute("class").include?("ui-state-disabled") ? false : true
      #binding.pry
      click_element(:xpath,"//p-datatable/div/div/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking if the Data Type is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='fileTypeCode_ct']").attribute("disabled") ? false : true

      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")



    when 'System Reference > Database Tables'
      right_click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      deleteExist = @driver.find_element(:xpath,"//span[contains(text(),'Delete')]/..").attribute("class").include?("ui-state-disabled") ? false : true
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking if the Database name is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='dbName_ct']").attribute("disabled") ? false : true

      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")

    when 'System Reference > Event Status'
      @util.logging("Delete and Edit is NEVER available for Event Status ")
      deleteExist = "NA"
      editExist = "NA"

    when 'System Reference > Operators'
      @util.logging("Delete is NEVER available for Operators")
      deleteExist = "NA"
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking if the Operator is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='operator_ct']").attribute("disabled") ? false : true

      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")

    when 'System Reference > Target Databases'
      right_click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      deleteExist = @driver.find_element(:xpath,"//span[contains(text(),'Delete')]/..").attribute("class").include?("ui-state-disabled") ? false : true
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking if the Validation Target Name is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='targetName_ct']").attribute("disabled") ? false : true

      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")
    when 'System Reference > Workflow Status'
      @util.logging("Delete and Edit are NEVER available for Workflow Status ")
      deleteExist = "NA"
      editExist = "NA"

    when 'System Reference > Settings'
      @util.logging("Delete is NEVER available for Settings")
      deleteExist = "NA"
      @util.logging("Checking if the Client Properties Table is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='item0']").attribute("disabled") ? false : true

    when 'Workflow > Reporting Period Logs'
      @util.logging("Delete is not available for RPLS that have been run")
      right_click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      deleteExist = "NA"
      click_element(:xpath,"//span[contains(text(),'Edit')]","Checking for Edit")
      @util.logging("Checking if the RPL Name is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='name_ct']").attribute("disabled") ? false : true
      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")
    when 'Security > Users'
      @util.logging("Delete is NEVER available for Users")
      deleteExist = "NA"
      click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      @util.logging("Checking if the Operator is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='userName_ct']").attribute("disabled") ? false : true

      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")
    when 'Security > Roles'
      right_click_element(:xpath,"//div[@class='ui-datatable-scrollable-table-wrapper']/table/tbody/tr[1]","The first row of the datatable")
      deleteExist = @driver.find_element(:xpath,"//span[contains(text(),'Delete')]/..").attribute("class").include?("ui-state-disabled") ? false : true
      click_element(:xpath,"//span[contains(text(),'Edit')]","Checking for Edit")
      @util.logging("Checking if the Role Name is editable")
      editExist = @driver.find_element(:xpath,"//input[@id ='roleName_ct']").attribute("disabled") ? false : true

      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")
    end
    if (editExist != editShouldPass) && (editExist !="NA")
      errorText = editShouldPass ? "should be enabled but is not" : "should not be enabled but is "
      errorMsg = "Edit #{errorText} on #{page}"
      @util.logging(errorMsg)
      check_override(true,errorMsg,true)
      return false
    elsif editExist == "NA"
      @util.logging("Edit is not available for #{page}")
    else
      errorText = editShouldPass ? "is enabled" : "is not enabled"
      @util.logging("Edit #{errorText} on #{page}")
    end
    if deleteExist != deleteShouldPass && (deleteExist !="NA")
      errorText = deleteShouldPass ? "should exist or be enabled but does not" : "should not exist or is not enabled but does "
      errorMsg = "Delete #{errorText} on #{page}"
      @util.logging(errorMsg)
      check_override(true,errorMsg,true)
      return false
    elsif deleteExist == "NA"
      @util.logging("Delete is not available for #{page}")
    else
      errorText = deleteShouldPass ? "does exist and is" : "does not exist or is not enabled"
      @util.logging("Delete #{errorText} on #{page}")
    end
  end
   # Adds or edits a column.  Uses the short name and the full name for the edit search
   #   add_or_edit_column(databaseTable, shortName, fullName, description, comment, addOrEdit)
   #   databaseTable string
   #   shortName string
   #   fullName string
   #   description string
   #   comment string
   #   addOrEdit flag either EDIT or ADD
   #   updatedShortName optional string for updating the short name in an edit
   #   updatedFullName  optional string for updating a full name
  def add_or_edit_column(*args)
 databaseTable = args[0]
 shortName = args[1]
 fullName= args[2]
 description = args[3]
 comment = args[4]
 addOrEdit = args[5]
 if args.size >=7
  updatedShortName = args[6]
end
 if args.size >=8
  updatedFullName = args[7]
end

    click_element(:xpath,Utilities.siteMap[:business_reference_mb],"Business Reference Drop down")
    click_element(:xpath,"//a[@id='navBizColumnDef']","Column Definitions from Business Reference Dropdown")
    if addOrEdit.upcase == "EDIT"
      enter_text(:xpath,"//span[contains(text(),'Column Short Name')]/../input","#{shortName}", "Search Column Short Name")
      click_element(:xpath,"//span[contains(text(),'#{fullName}')]","Selecting '#{fullName}'")
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//button[contains(text(),'Add')]","Add button")
    end
    click_element(:xpath,"//span[@id = 'dbTable_ct_fb']","Database Table Dropdown")
    click_element(:xpath,"//a[contains(text(),'#{databaseTable}')]", "#{databaseTable} from Database Table Dropdown")
   if updatedShortName
       enter_text(:xpath,"//input[@id='shortName_ct']","#{updatedShortName}","Short Name")
   else
    enter_text(:xpath,"//input[@id='shortName_ct']","#{shortName}","Short Name")
  end
  if updatedFullName
     enter_text(:xpath,"//input[@id='fullName_ct']","#{updatedFullName}","Full Name field")
   else
    enter_text(:xpath,"//input[@id='fullName_ct']","#{fullName}","Full Name field")
    end
    enter_text(:xpath,"//textarea[@id='desc_ct']","#{description}","Description Field")
    enter_text(:xpath,"//textarea[@id='comments_ct']","#{comment}","Comments Field")
    if addOrEdit.upcase == "EDIT"
      click_element(:xpath,"//div[@class='modal-footer']/div/button","Save button")
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//div[@class='modal-footer']/div/button","Add button")
    end
  end
   # Adds or edits a company.  Uses the Company Number and Company Name for the edit search.
   #   add_or_edit_company(companyNumber, companyName, description, comment, addOrEdit)
   #   companyNumber string
   #   companyName string
   #   description string
   #   comment string
   #   addOrEdit flag either EDIT or ADD
   #   updatedComanyNumber optional  string for updating the company number
   #   updatedCompanyName optional string for updating the company name
  def add_or_edit_company(*args)
    companyNumber = args[0]
    companyName =args[1]
    description =args[2]
    comment = args[3]
    addOrEdit = args[4]
    if args.size >=6
      updatedCompanyNumber = args[5]
    end
    if args.size >=7
      updatedCompanyName = args[6]
    end
    click_element(:xpath,Utilities.siteMap[:business_reference_mb],"Business Reference Drop down")
    click_element(:xpath,"//a[@id='navBizCompany']","Company from Business Reference Dropdown")
    if addOrEdit.upcase == "EDIT"
      enter_text(:xpath,"//span[contains(text(),'Company Number')]/../input","#{companyNumber}", "Search Company Number")
      click_element(:xpath,"//span[contains(text(),'#{companyName}')]","Selecting '#{companyName}'")
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//button[contains(text(),'Add')]","Add button")
    end
    if updatedCompanyNumber
      enter_text(:xpath,"//input[@id='number_ct']","#{updatedCompanyNumber}","Company Number field")
    else
    enter_text(:xpath,"//input[@id='number_ct']","#{companyNumber}","Company Number field")
    end
    if updatedCompanyName
      enter_text(:xpath,"//input[@id='name_ct']","#{updatedCompanyName}","Company Name field")
    else
    enter_text(:xpath,"//input[@id='name_ct']","#{companyName}","Company Name field")
    end
    enter_text(:xpath,"//textarea[@id='desc_ct']","#{description}","Description Field")
    enter_text(:xpath,"//textarea[@id='comments_ct']","#{comment}","Comments Field")
    if addOrEdit.upcase == "EDIT"
      click_element(:xpath,"//div[@class='modal-footer']/div/button","Save button")
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//div[@class='modal-footer']/div/button","Add button")
    end
  end
   # Adds or edits an entity. Uses the entityCode for the edit search
   #   add_or_edit_entity(entityCode, description, comment, addOrEdit)
   #   entityCode string
   #   description string
   #   comment string
   #   addOrEdit flag either EDIT or ADD
   #   updatedEntityCode optional string for updating the entity code
  def add_or_edit_entity(*args)
    entityCode = args[0]
    description = args[1]
    comment = args[2]
    addOrEdit = args[3]
    if args.size >=5
      updatedEntityCode = args[4]
    end

    click_element(:xpath,Utilities.siteMap[:business_reference_mb],"Business Reference Drop down")
    click_element(:xpath,"//a[@id='navBizEntity']","Entity from Business Reference Dropdown")
    if addOrEdit.upcase == "EDIT"
      enter_text(:xpath,"//span[contains(text(),'Entity')]/../input","#{entityCode}", "Search Entity")
      click_element(:xpath,"//span[contains(text(),'#{entityCode}')]","Selecting '#{entityCode}'")
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//button[contains(text(),'Add')]","Add button")
    end
    if updatedEntityCode
      enter_text(:xpath,"//input[@id='entityCode_ct']","#{entityCode}","Entity Code field")
    else
    enter_text(:xpath,"//input[@id='entityCode_ct']","#{entityCode}","Entity Code field")
    end 

    enter_text(:xpath,"//textarea[@id='desc_ct']","#{description}","Description Field")
    enter_text(:xpath,"//textarea[@id='comments_ct']","#{comment}","Comments Field")
    if addOrEdit.upcase == "EDIT"
      click_element(:xpath,"//div[@class='modal-footer']/div/button","Save button")
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//div[@class='modal-footer']/div/button","Add button")
    end

  end
  # Check for Duplicate-  switches between two methods depending on branch
  def check_for_duplicate
    if @@branch.include?("v.2")
      check_for_duplicate_v2()
    elsif @@branch.include?("v.1")
      check_for_duplicate_v1()
    else
     errorMsg = "Branch is not set could not continue"
      @util.logging(errorMsg)
      check_override(true,errorMsg,true)
    end
      
  end
   # Check for Duplicate-  Checks for a duplicate column in V2
   def check_for_duplicate_v2()
     errorExists = check_if_exist(:xpath,"//div[@id = 'toast-container']","Check for the Error toaster message")
     errorText = get_element_text(:xpath, "//div[@id = 'toast-container']","Toaster Error modal text")
    if errorExists == false
      errorMsg = "Duplicate error did not appear"
      @util.logging(errorMsg)
      check_override(true,errorMsg,true)
      return false
    else
        @util.logging("Got an error popup with the message '#{errorText}'")  
        browserLog = @driver.manage.logs.get(:browser)
       @util.logging("Console log has #{browserLog.to_s}")
  
       click_element(:xpath,"//button[@aria-label = 'Close']","Cancel X on Toaster message")
       click_element(:xpath,"//div[@class='modal-footer']/div/button[contains(text(),'Cancel')]","Cancel button")
    end
  end

   # Check for Duplicate-  Checks for a duplicate column in V1
  def check_for_duplicate_v1()
    errorExists = check_if_exist(:xpath,"//span[contains(text(),'Error')]","Check for the Error message on the duplicate")
    if errorExists == false
      errorMsg = "No Duplicate error came up"
      @util.logging(errorMsg)
      check_override(true,errorMsg,true)
      return false
    else
      errorText =  get_element_text(:xpath,"//span[contains(text(),'Error')]/..","Error Text")
      @util.logging("Got the expected error message #{errorText}")
      click_element(:xpath,"//button[contains(text(),'Cancel')]","Cancel button")
    end
  end
   # Adds or edits a standard output code. Uses the output code in the edit
   #   add_or_edit_standard_output_code(columnFullName, outputCode, description, comment, addOrEdit)
   #   columnFullName string
   #   outputCode string
   #   description string
   #   comment string
   #   addOrEdit flag  either EDIT or ADD
   #   updatedOutputCode optional string 
  def add_or_edit_standard_output_code(*args)
    columnFullName = args[0]
    outputCode = args[1]
    description = args[2]
    comment = args[3]
    addOrEdit = args[4]
    if args.size >=6
      updatedOutputCode = args[5]
    end
    click_element(:xpath,Utilities.siteMap[:business_reference_mb],"Business Reference Drop down")
    click_element(:xpath,"//a[@id='navBizCodes']","Standard Output Codes from Business Reference Dropdown")
    
    if addOrEdit.upcase == "EDIT"
      wait_for_element(:xpath,"//span[contains(text(),'Column Full Name')]/../input","#{columnFullName}",120)
     
      enter_text(:xpath,"//span[contains(text(),'Column Full Name')]/../input","#{columnFullName}", "Standard Outpu Codes Search")
      click_element(:xpath,"//span[contains(text(),'#{columnFullName}')]","Selecting '#{columnFullName}'")
    elsif addOrEdit.upcase =="ADD"
      click_element(:xpath,"//button[contains(text(),'Add')]","Add button")
    end

    click_element(:xpath,"//span[@id='columnFull_ct_fb']","Column Full Name Dropdown")
    wait_for_element(:xpath,"//a[contains(text(),'#{columnFullName}')]", "#{columnFullName} from Column Full Name Dropdown",120)
    click_element(:xpath,"//a[contains(text(),'#{columnFullName}')]", "#{columnFullName} from Column Full Name Dropdown")
    sleep(10)
    if addOrEdit.upcase == "EDIT"
      
      if @@filebase.include?("UAT0")
      click_element(:xpath,"//span[contains(text(),'UAT0')]","Selecting 'UAT0'")
    else
      click_element(:xpath,"//span[contains(text(),'#{outputCode}')]","Selecting '#{outputCode}'")
      end
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//button[contains(text(),'Add')]","Add button to Create the Standard output code")
      sleep(5)
      click_element(:xpath,"//button[contains(text(),'Add')]","Add button to add an Output Code value")
    end
    errorExists = check_if_exist(:xpath,"//span[contains(text(),'Error')]","Check for the Error message on the duplicate")
    if errorExists == true
      errorText =  get_element_text(:xpath,"//span[contains(text(),'Error')]/..","Error Text")
      @util.logging("Got the error message #{errorText}")
      click_element(:xpath,"//a[contains(text(),'Home')]","Clicking the Home button")
      alert = @driver.switch_to.alert
      alert.accept
    else
      if updatedOutputCode
        enter_text(:xpath,"//input[@id='codeValue_ct']","#{updatedOutputCode}","Output Code Value field")
      else
      enter_text(:xpath,"//input[@id='codeValue_ct']","#{outputCode}","Output Code Value field")
    end
      enter_text(:xpath,"//textarea[@id='desc_ct']","#{description}","Description Field")
      enter_text(:xpath,"//textarea[@id='comments_ct']","#{comment}","Comments Field")
      if addOrEdit.upcase == "EDIT"
        click_element(:xpath,"//div[@class='modal-footer']/div/span/button[contains(text(),'Save')]","Save button on output code values")
        sleep(5)
        click_element(:xpath,"//button[contains(text(),'Save')]","Save button on Standard Output Codes page")
      elsif addOrEdit.upcase == "ADD"
        click_element(:xpath,"//div[@class='modal-footer']/div/span/button[contains(text(),'Add')]","Add button")
      end
    end
  end
   # Adds or edits a validation rule in Zenith. For edit does the search on the rule name
   #   add_or_edit_validation_rule(ruleName, ruleField, target, description, comment, addOrEdit)
   #   ruleName 
   #   ruleField
   #   target
   #   description
   #   comment
   #   addOrEdit flag  either EDIT or ADD
   #   updatedRuleName  optional
  def add_or_edit_validation_rule(*args)
    ruleName = args[0]
    ruleField = args[1]
    target = args[2]
    description = args[3]
    comment = args[4]
    addOrEdit = args[5]
    if args.size >= 7 
      updatedRuleName = args[6]
    end

    click_element(:xpath,Utilities.siteMap[:business_reference_mb],"Business Reference Drop down")
    click_element(:xpath,"//a[@id='navBizValidations']","Entity from Business Reference Dropdown")
    if addOrEdit.upcase == "EDIT"
      enter_text(:xpath,"//span[contains(text(),'Rule Name')]/../input","#{ruleName}", "Search Rule Name")
      click_element(:xpath,"//span[contains(text(),'#{ruleName}')]","Selecting '#{ruleName}'")
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//button[contains(text(),'Add')]","Add button")
    end
    if updatedRuleName
        enter_text(:xpath,"//input[@id='ruleName_ct']","#{updatedRuleName}","Rule Name field")
      else  
    enter_text(:xpath,"//input[@id='ruleName_ct']","#{ruleName}","Rule Name field")
     end
    enter_text(:xpath,"//input[@id='rule_ct']","#{ruleField}","Rule field")
    click_element(:xpath,"//span[@id = 'target_ct_fb']","Target Dropdown")
    click_element(:xpath,"//a[contains(text(),'#{target}')]", "#{target} from Target Dropdown")
    enter_text(:xpath,"//textarea[@id='desc_ct']","#{description}","Description Field")
    enter_text(:xpath,"//textarea[@id='comments_ct']","#{comment}","Comments Field")

    if addOrEdit.upcase == "EDIT"
      click_element(:xpath,"//div[@class='modal-footer']/div/button","Save button")
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//div[@class='modal-footer']/div/button","Add button")
    end
  end
   # Adds or edits an existing data type in Zenith.  Edit searches off the data type 
   #   add_or_edit_data_type(dataType, clientPropertiesKey, rcdbTable, rcdbTableKey, cds2Table, cds2TableKey, description, comment, addOrEdit)
   #   dataType string
   #   clientPropertiesKey string
   #   rcdbTable string
   #   rcdbTableKey string
   #   cds2Table string
   #   cds2TableKey string
   #   description string
   #   comment string
   #   addOrEdit flag  either EDIT or ADD
   #   updatedDataType optional string
  def add_or_edit_data_type(*args)
    dataType = args[0]
    clientPropertiesKey = args[1]
    rcdbTable = args[2]
    rcdbTableKey = args[3]
    cds2Table = args[4]
    cds2TableKey = args[5]
    description = args[6]
    comment = args[7]
    addOrEdit = args[8]
    if args.size >= 10
      updatedDataType = args[9]
    end
    click_element(:xpath,Utilities.siteMap[:system_reference_mb],"System Reference Drop down")
    click_element(:xpath,"//a[@id='navSysFileTypes']","Data Types from System Reference Dropdown")
    if addOrEdit.upcase == "EDIT"
      enter_text(:xpath,"//span[contains(text(),'Data Type')]/../input","#{dataType}", "Search Data Type")
      click_element(:xpath,"//span[contains(text(),'#{dataType}')]","Clicking '#{dataType}'")
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//button[contains(text(),'Add')]","Add button")
    end
    if updatedDataType
     enter_text(:xpath,"//input[@id='fileTypeCode_ct']","#{updatedDataType}","Data Type")
    else
    enter_text(:xpath,"//input[@id='fileTypeCode_ct']","#{dataType}","Data Type")
    end
    enter_text(:xpath,"//input[@id='keyName_ct']","#{clientPropertiesKey}","Client Properties Key")
    click_element(:xpath,"//span[@id='rcdbTable_ct_fb']","RCdB Table Dropdown")

    enter_text(:xpath,"//input[@id='rcdbTable_ct']","#{rcdbTable}","#{rcdbTable} from RCdB Table Dropdown")
    @driver.action.send_keys("\ue015").perform
    @driver.action.send_keys("\ue007").perform
    enter_text(:xpath,"//input[@id='rcdbTableKey_ct']","#{rcdbTableKey}","RCdB Table Key")
    enter_text(:xpath,"//input[@id='cds2Table_ct']","#{cds2Table}","CDS2 Table")
    enter_text(:xpath,"//input[@id='cds2TableKey_ct']","#{cds2TableKey}","CDS2 Table Key")

    enter_text(:xpath,"//textarea[@id='description_ct']","#{description}","Description Field")
    enter_text(:xpath,"//textarea[@id='comments_ct']","#{comment}","Comments Field")

    if addOrEdit.upcase == "EDIT"
      click_element(:xpath,"//div[@class='modal-footer']/div/button","Save button")
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//div[@class='modal-footer']/div/button","Add button")
    end
  end
   # Adds or edits an existing database type in Zenith.  Uses the description for the edit search  
   #   add_or_edit_database_type(databaseName, schemaName, tableName, lookupCategory, description, comment, addOrEdit)
   #   databaseName string
   #   schemaName string
   #   tableName string
   #   lookupCategory string
   #   description string
   #   comment string
   #   addOrEdit flag  either EDIT or ADD
   #   updatedDescription optional string
  def add_or_edit_database_type(*args)
    databaseName = args[0]
    schemaName = args[1]
    tableName = args[2]
    lookupCategory = args[3]
    description = args[4]
    comment = args[5]
    addOrEdit = args[6]
    if args.size >=8
      updatedDescription = args[7]
    end
    click_element(:xpath,Utilities.siteMap[:system_reference_mb],"System Reference Drop down")
    click_element(:xpath,"//a[@id='navSysDb']","Database Tables from System Reference Dropdown")
    if addOrEdit.upcase == "EDIT"
         enter_text(:xpath,"//span[contains(text(),'Description')]/../input","#{description}", "Search Description")
        click_element(:xpath,"//span[contains(text(),'#{tableName}')]","Clicking '#{tableName}'")
     
     elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//button[contains(text(),'Add')]","Add button")
    end

    enter_text(:xpath,"//input[@id='dbName_ct']","#{databaseName}","Database Name")
    enter_text(:xpath,"//input[@id='schema_ct']","#{schemaName}","Schema Name")
    enter_text(:xpath,"//input[@id='tableName_ct']","#{tableName}","Table Name")
    click_element(:xpath,"//span[@id='lookupCategory_ct_fb']","Lookup Category dropdown ")
   
    enter_text(:xpath,"//input[@id='lookupCategory_ct']","#{lookupCategory}","#{lookupCategory} from Lookup Category Dropdown")
    @driver.action.send_keys("\ue015").perform
    @driver.action.send_keys("\ue007").perform   
    if updatedDescription
       enter_text(:xpath,"//textarea[@id='desc_ct']","#{updatedDescription}","Description Field")
    else
    enter_text(:xpath,"//textarea[@id='desc_ct']","#{description}","Description Field")
    end
    enter_text(:xpath,"//textarea[@id='comments_ct']","#{comment}","Comments Field")
  if addOrEdit.upcase == "EDIT"
      click_element(:xpath,"//div[@class='modal-footer']/div/button[contains(text(),'Save')]","Save button")
    elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//div[@class='modal-footer']/div/button","Add button")
    end
  end
   # Adds or edits an existing target databases in Zenith. Uses the validation target for the edit search
   #   add_or_edit_target_databases(validationTarget, description, comment, addOrEdit)
   #   validationTarget string
   #   description string
   #   comment string
   #   addOrEdit flag  either EDIT or ADD
   #   updatedValidationTarget optional string
  def add_or_edit_target_databases(*args)
    validationTarget = args[0]
    description = args[1]
    comment = args[2]
    addOrEdit = args[3]
    if args.size >= 5
      updatedValidationTarget = args[4]
    end

  	click_element(:xpath,Utilities.siteMap[:system_reference_mb],"System Reference Drop down")
    click_element(:xpath,"//a[@id='navSysValTgt']","Target Database from System Reference Dropdown")
    if addOrEdit.upcase == "EDIT"
         enter_text(:xpath,"//span[contains(text(),'Target Database')]/../input","#{validationTarget}", "Search Target Database")
         click_element(:xpath,"//span[contains(text(),'#{validationTarget}')]","Clicking '#{validationTarget}'")
     elsif addOrEdit.upcase == "ADD"
      click_element(:xpath,"//button[contains(text(),'Add')]","Add button")
    end
   if updatedValidationTarget
      enter_text(:xpath,"//input[@id='targetName_ct']","#{updatedValidationTarget}","Validation Target Name")
   else
    enter_text(:xpath,"//input[@id='targetName_ct']","#{validationTarget}","Validation Target Name")
    end
    enter_text(:xpath,"//textarea[@id='description_ct']","#{description}","Description Field")
    enter_text(:xpath,"//textarea[@id='comments_ct']","#{comment}","Comments Field")
 
    if addOrEdit.upcase == "EDIT"
    click_element(:xpath,"//div[@class='modal-footer']/div/button[contains(text(),'Save')]","Save button")
    elsif addOrEdit.upcase == "ADD"
    click_element(:xpath,"//div[@class='modal-footer']/div/button","Add button")
    end 

  end
   # Adds or edits an existing reporing period log. Usesthe RplName for the edit search
   #   add_or_edit_reporting_period_logs(companyId, clientFileName, rplName, startEffectiveDate, endEffectiveDate, comment, addOrEdit)
   #   companyId string
   #   clientFileName string
   #   rplName string
   #   startEffectiveDate string
   #   endEffectiveDate string
   #   comment string
   #   addOrEdit flag  either EDIT or ADD
   #   updatedRplName optional string
  def add_or_edit_reporting_period_logs(*args)
    companyId = args[0]
    clientFileName = args[1]
    rplName = args[2]
    startEffectiveDate = args[3]
    endEffectiveDate = args[4]
    comment = args[5]
    addOrEdit = args[6]
    if args.size >= 8 
      updatedRplName = args[7]
    end
  	 click_element(:xpath,Utilities.siteMap[:workflow_mb],"Workflow Menu")
     click_element(:xpath,Utilities.siteMap[:reporting_period_logs],"Reporting Period Logs menu item")
     enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_file_search],companyId,"for Company ID in RPL search")
     click_element(:xpath,"//a[contains(text(),'#{clientFileName}')]","#{clientFileName} the search dropdown")
     if addOrEdit.upcase == "EDIT"
         right_click_element(:xpath,"//span[contains(text(),'#{rplName}')]","Newly Created RPL")
         click_element(:xpath,"//span[contains(text(),'Edit')]","Edit button on Newly Created RPL")
     elsif addOrEdit.upcase == "ADD"
         click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_btn],"Add a Reporting Period Log")
    end
    if updatedRplName 
    enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_rpl_name_text],"#{updatedRplName}"," for RPL name")
    else
    enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_rpl_name_text],"#{rplName}"," for RPL name")
    end
    enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_start_effective_text],"#{startEffectiveDate}"," for the Start Effective Date")
    enter_text(:xpath,Utilities.siteMap[:reporting_period_logs_add_end_effective_text],"#{endEffectiveDate}"," for the End Effective Date")
    enter_text(:xpath,"//textarea[@id='comments_ct']","#{comment}")
    if addOrEdit.upcase == "EDIT"
        click_element(:xpath,"//button[contains(text(),'Save')]","Save button on RPL modal window")
    elsif addOrEdit.upcase == "ADD"
    click_element(:xpath,Utilities.siteMap[:reporting_period_logs_add_add_btn],"Add button on Add Reporting Period Log")
    end
  end
   # Takes a string date and formats it for US format MM/DD/YYYY depending on the environment.  Takes dates in XX/XX/XXXX and  XXXXXXXX formats
   #   date as a string
   def datecleaner(date)
  	if (@@environment.upcase.include?("US"))
  		if date.include?("/")
  		date = date.gsub('/','')
  		datelength = date.length 
        newDate = "#{date[2]}#{date[3]}/#{date[0]}#{date[1]}/#{date[4..datelength]}"
    		date = newDate
  	else
  		newDate = "#{date[2]}#{date[3]}#{date[0]}#{date[1]}#{date[4..7]}"
  		date = newDate
  	end
  	end
  	return date
  end
  # Gets the userid for permission testing
  def get_user_id
    query = "select userId from  [Zenith].[dbo].[User] where UserName = 'Chris Goodnight'"  
  results,error = tds_query("Zenith",query)
  userId = ""
  results.each do |result|
  userId = result["userId"]

  end 
  return userId
  end
  # Deletes any type of zenith object (column, entity, etc) that shows in a table.  Searches a span for the object and right clicks it. 
  #    Confirms the object is deleted and takes a snapshot
  #    objectToDelete string the UNIQUE string that exists in a table span
  #    objectType string i.e. entity, column, etc
  #    full  optional runs through each of the delete options (clicking no on confirmation, clicking x, clicking yes)
  def zenith_object_delete(*args)
    objectToDelete = args[0]
    objectType = args[1]
    if args.size >= 3
      full = args[2]
    end
    if full
   
    right_click_element(:xpath,"//span[contains(text(),'#{objectToDelete}')]","Right Clicking '#{objectToDelete}'")
    click_element(:xpath,"//span[contains(text(),'Delete')]","Delete #{objectType}")
    confirmationText = get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]","Confirmation Modal window text")
    @util.logging("Got the message \n #{confirmationText}")    
    click_element(:xpath,"//button/span[contains(text(),'No')]","No button on confirmation window")
    #click_element(:xpath,"//span[contains(text(),'No')]", "No button on confirmation window")
    take_snapshot("No on delete confirmation #{objectType} #{objectToDelete}")

    right_click_element(:xpath,"//span[contains(text(),'#{objectToDelete}')]","Right Clicking '#{objectToDelete}'")
    click_element(:xpath,"//span[contains(text(),'Delete')]","Delete #{objectType}")
    confirmationText = get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]","Confirmation Modal window text")
    @util.logging("Got the message \n #{confirmationText}")   
     click_element(:xpath,"//span[contains(text(),'Confirmation')]/../a","X button on Delete Condition window")
    take_snapshot("X on delete confirmation #{objectType} #{objectToDelete}")
    end
    right_click_element(:xpath,"//span[contains(text(),'#{objectToDelete}')]","Right Clicking '#{objectToDelete}'")
    click_element(:xpath,"//span[contains(text(),'Delete')]","Delete #{objectType}")
    confirmationText = get_element_text(:xpath,"//span[contains(text(),'Confirmation')]/../../div[2]","Confirmation Modal window text")
    @util.logging("Got the message \n #{confirmationText}")
    click_element(:xpath,"//button/span[contains(text(),'Yes')]","Yes button on confirmation window")
    #click_element(:xpath,"//span[contains(text(),'Yes')]", "Yes button on confirmation window")
    take_snapshot("#{objectType} #{objectToDelete} deleted")
    result = check_if_exist(:xpath,"//span[contains(text(),'#{objectToDelete}')]",5)
    return result
  end
   # Takes a "Golden" yaml file ie one with expected results and compares it to the current hash from a SQL Query and compares each hash key from the  arrayOfCheckFields
   #   goldenReport the path and file name of the golden yml file
   #   currentReportHash  the hash from the current report
   #   nameOfReport the name of the report being checked
   #   arrayOfCheckFields  an array of the keys that the golden report should be compared to with the current report
  def compare_current_report_to_golden_report(goldenReport,currentReportHash,nameOfReport,arrayOfCheckFields)
     goldenReportHash = YAML.load_file("#{goldenReport}")

if (goldenReportHash.count.to_i != currentReportHash.count.to_i)
  errorMsg ="The count of records in the #{nameOfReport} does not meet the expected.  Expected #{goldenReportHash.count} got #{currentReportHash.count}"
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)
 else
  @util.logging("The count of records in the #{nameOfReport} meets the expected amount.")
 end
countOfRecords = goldenReportHash.count - 1
countOfCheckFields = arrayOfCheckFields.count -1
 for i in 0..countOfRecords
    arrayOfCheckStatus = Array.new
    for x in 0..countOfCheckFields
       arrayOfCheckStatus.push(goldenReportHash[i]["#{arrayOfCheckFields[x]}"] == currentReportHash[i]["#{arrayOfCheckFields[x]}"])
        if (arrayOfCheckStatus[x] == false)
             errorMsg ="Line #{i} of #{nameOfReport} did NOT match the golden file for #{arrayOfCheckFields[x]}. Golden file has #{goldenReportHash[i]["#{arrayOfCheckFields[x]}"]} but the report has #{currentReportHash[i]["#{arrayOfCheckFields[x]}"]}  "
             @util.logging(errorMsg)
             check_override(true,errorMsg,false)
        end
    end
      if (arrayOfCheckStatus.include? (false))
            errorMsg ="Line #{i} of #{nameOfReport} did NOT match the golden file for one of  #{arrayOfCheckFields}\n Expected #{goldenReportHash[i]} \n Got #{currentReportHash[i]} "
        @util.logging(errorMsg)
        check_override(true,errorMsg,false)

     else
       @util.logging("The #{nameOfReport} in Global Validations matched the golden file for #{arrayOfCheckFields} ")
    end
          
 end
  end
;end
