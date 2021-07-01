require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
#require "mysql2"
require "socket"
#require "oj"
require "open-uri"
require 'net/ssh'
require 'net/sftp'
require 'pg'
require "./libraries/testlogging.rb"
require "pry"
#require "tiny_tds"
require "./libraries/MacroUtilities.rb"
#require "google_drive"
#require "certified"
require 'mysql2'
require 'net/ssh/gateway'
require "csv.rb"
require "logging"
#require "./libraries/OldUtilities.rb"
#require "sauce"
#require "sauce-connect"
#require "factory_girl"
require "HTTParty"
#require 'viewpoint'
#include Viewpoint::EWS
require "roo"

class Utilities
  @@g_base_dir=""
  @@util=""
  @@environment=""
  @@driver=""
  @@host=""
  @@base_url=""
  @@brws=""
  @@filebase=""
  @@filedir=""
  @@driverVersion=""
  @@branch =""
  @@debug = 1
  @@actionsleep=1
  @@videoindexoffset=0
  @@nativeapp = 0
  @@os="#{RUBY_PLATFORM}"
  @@sqlDB_host = ""
  @@sqlDB_master=""
  @@sqlDB_tenant=""
  @@sqlUser =""
  @@sqlPassword =""
  @@loggingDb=""
  @@enviroDB =""
  @bs=""
  @@db_id=""
  @@test_case_fail=false
  @@test_case_fail_details = Array.new
  @@test_case_warn_details = Array.new
  @@test_case_fail_artifacts = Array.new
  @@azureuser=""
  @@azureHostShort=""
  @@azureHost=""
  @@azuredb=""
  @@azureColduser=""
  @@azureColdpassword = ""
  @@azureColdHostShort=""
  @@azureColdHost=""
  @@azureColddb=""
  @@utcoffsetMin=""
  @@logToQADatabase =1
  @@downOffset = 0
  # @@customerName="City of Sacramento"
  @@artifact_dir = ""
  @@rplId =""
  @@mainVersion =""
  @@conductorVersion =""
  @@cdsVersion =""
  @@lrmVersion =""
  @@zenithVersion =""
  @@deleteFiles = Array.new
  # Overrides the current browser that was chosen on startup of the test case
  #   newbrws string of the new browser type (ie firefox, chrome, ie)
  def override_brws(newbrws)
    @@brws=newbrws
  end
  # Depricated
  def set_native_app()
    @@nativeapp=1
  end
  # Sets the global offset for ie and firefox.  Used in the Bi symphony because of the iFrame problems
  def set_offset(x,y)
    if @@brws !='firefox'
      @@downOffset = y
    end
  end

  # Initializes utilities
  def initialize
    puts ""
  end
  # Turns on the debug level 1
  def debug_on
    @@debug =1
  end
  # Gets the global variables
  #   return @@g_base_dir, @@util, @@environment, @@driver,@@base_url, @@brws, @@filedir
  def get_globals
    return @@g_base_dir, @@util, @@environment, @@driver,@@base_url, @@brws, @@filedir
  end
  # Prompts the user for an environment.  Overridden if there is a environment.txt file
  #   returns the environment, brws choices
  def choose_environment
    @util.logging"\nEnter the baseurl of the environment do you want to test? Enter for default integration.deliverybizpro.com"
    environment = gets.chomp
    if environment ==""
      environment = "integration.deliverybizpro.com"
    end
    @util.logging"\nEnter the database name for the environment.  Default is integration"
    database = gets.chomp
    if database ==""
      database = "integration"
    end
    @@enviroDB = database

    #@util.logging"What browser do you want to test in (chrome, firefox, safari, ie (windows only), BS-Win10-Firefox,BS-IE10, BS-IE11,BS-Chrome)"
    @util.logging"What browser do you want to test in (chrome, firefox)"
    brws = gets.chomp
    if brws ==""
      brws = "chrome"
    end
    return environment,brws
  end
  # Verifies that an element is available, if not it throws a failure
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   acceptFailure boolean  (true accepts and logs an error, fail errors out and the test stops)
  def find_element_text(how, what,acceptFailure)
    begin
      element =@driver.find_element(how, what)
      return element.text
    rescue Selenium::WebDriver::Error::NoSuchElementError
      if acceptFailure == true
        @util.logging "Failed find element for #{how} and #{what}"
        return ""
      else
        return false
      end
    rescue Selenium::WebDriver::Error::ElementNotVisibleError
      if acceptFailure == true
        @util.logging "Failed find element for #{how} and #{what}"
        return ""
      else
        return false
      end
    else
      #logging "3 Failed find element for #{how} and #{what}"
      true
    end
  end
  # Checks if an element is present
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   may be depricated
  def element_present?(how, what)
    begin
      @driver.find_element(how, what)
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what}"
      false
    rescue Selenium::WebDriver::Error::ElementNotVisibleError
      @util.logging "2 Failed find element for #{how} and #{what}"
      false

    else
      #logging "3 Failed find element for #{how} and #{what}"
      true
    end
  end
  # Clicks an element
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   msg -  Optional logging message
  def click_element(*args)
    begin
      offset= false
      how = args[0]
      what =args[1]
      msg=""
      if (how.is_a? String)
        nLookup = get_element_from_navigation2(how,what)
        how = nLookup[0]
        what = nLookup[1]
      end
      if args.size >=3
        msg= args[2] + " ---->"
      end

      if args.size >=4
        offset= args[3]
      end
      if @@debug==1
        @util.logging("-->Clicking #{msg} #{what} of type #{how}")
      end
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)
      element =""
      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.displayed?
      }
      #cb.click
      if @@brws !='firefox' && offset==true
        @driver.action.move_to(element,0,@@downOffset).click.perform
      elsif @@brws=='firefox'
        @driver.find_element(how, what).click
      else
        #binding.pryt
        # startTime = Time.new
        @driver.find_element(how, what).click
        # endTime = Time.new
        # totalTime = (endTime.to_f - startTime.to_f)
        # @util.logging ("#{totalTime}  seconds to load page")
      end
      sleep(@@actionsleep)

      if what =="commit" || what == "submit"
        newUrl = @driver.current_url
        @util.logging("Current URL =#{newUrl}")
      end
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to click"
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what}"
      false

    rescue Net::ReadTimeout
      # binding.pry
      @util.logging "2 Failed find element for #{how} and #{what}"
      false
    rescue Selenium::WebDriver::Error::ElementClickInterceptedError
      check_override(true,"--> Element #{msg} #{what} of type #{how} was displayed but click would be intercepted")
      false
    rescue
      check_override(true,"Unknown error clicking on  #{how} and #{what} ",false)
    else

    end
  end

  def click_element_ignore_failure(*args)
    begin
      offset= false
      how = args[0]
      what =args[1]
      msg=""
      if (how.is_a? String)
        nLookup = get_element_from_navigation2(how,what)
        how = nLookup[0]
        what = nLookup[1]
      end
      if args.size >=3
        msg= args[2] + " ---->"
      end

      if args.size >=4
        offset= args[3]
      end
      if @@debug==1
        @util.logging("-->Clicking #{msg} #{what} of type #{how}")
      end
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)
      element =""
      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.displayed?
      }
      #cb.click
      if @@brws !='firefox' && offset==true
        @driver.action.move_to(element,0,@@downOffset).click.perform
      elsif @@brws=='firefox'
        @driver.find_element(how, what).click
      else
        #binding.pryt
        # startTime = Time.new
        @driver.find_element(how, what).click
        # endTime = Time.new
        # totalTime = (endTime.to_f - startTime.to_f)
        # @util.logging ("#{totalTime}  seconds to load page")
      end
      sleep(@@actionsleep)

      if what =="commit" || what == "submit"
        newUrl = @driver.current_url
        @util.logging("Current URL =#{newUrl}")
      end
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to click"
      true
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what}"
      true

    rescue Net::ReadTimeout
      # binding.pry
      @util.logging "2 Failed find element for #{how} and #{what}"
      true
     rescue StandardError => e
        @util.errorlogging("Unable to click #{msg} #{e}")
        check_override("warn","Unable to click #{msg} #{e} --->identifier #{what} of type #{how}",false)
      end
  end
  # Clicks an element
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   msg -  Optional logging message
  def click_element_from_elements(*args)
    found = false
    begin
      offset= false
      how = args[0]
      what =args[1]
      elementCount = args[2]
      msg=""
      if args.size >=4
        msg= args[3] + " ---->"
      end
      if args.size >=5
        offset= args[4]
      end
      if @@debug==1
        @util.logging("-->Clicking #{msg} #{what} of type #{how}")
      end
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)
      element =""
      found = false
      elements = @driver.find_elements(how , what)
      if (elements.count>0)
        elements[elementCount.to_i].click
        found = true
      else
        @util.logging "<font color=\"orange\"> --> Net read failureElement #{msg} #{what} of type #{how} </font>"
        @util.logging("</font>")
        found = false
      end
      sleep(@@actionsleep)

      if what =="commit" || what == "submit"
        newUrl = @driver.current_url
        @util.logging("Current URL =#{newUrl}")
      end
      return found
    rescue  Selenium::WebDriver::Error::ElementClickInterceptedError
      check_override(true,"--> Element #{msg} #{what} of type #{how} was displayed but click would be intercepted")
      
      false
    rescue Selenium::WebDriver::Error::ElementNotInteractableError
     check_override(true,"--> Element #{msg} #{what} of type #{how} was displayed but is not interactable")
      false
    rescue Selenium::WebDriver::Error::NoSuchElementError
     check_override(true,"--> Element #{msg} #{what} of type #{how} No such element")
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what} count #{elementCount} to click "
      false

    rescue Net::ReadTimeout
      # binding.pry
      check_override(true,"<font color=\"orange\"> --> Net read failureElement #{msg} #{what} of type #{how} </font>")
      @util.logging("</font>")
      false
    rescue StandardError => e
      @util.errorlogging("Unable to click on element  #{e}")
      throw ("Unable to click on element  #{e} ")
    end
    return found
  end

  # Right clicks an element to get the context click menu-  Use a separate click to select the specific menu item
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   msg -  Optional logging message
  def right_click_element(*args)
    begin
      offset= false
      how = args[0]
      what =args[1]
      msg=""
      if args.size >=3
        msg= args[2] + " ---->"
      end
      if args.size >=4
        offset= args[3]
      end
      if @@debug==1
        @util.logging("-->Right Clicking #{msg} #{what} of type #{how}")
      end
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)
      element =""
      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.displayed?
      }
      #cb.click
      if @@brws !='firefox' && offset==true
        @driver.action.move_to(element,0,@@downOffset).click.perform
      elsif @@brws=='firefox'
        a = @driver.find_element(how, what)
        @driver.action.context_click(a).perform
      else
        a = @driver.find_element(how, what)
        @driver.action.context_click(a).perform
      end
      sleep(@@actionsleep)

      if what =="commit" || what == "submit"
        newUrl = @driver.current_url
        @util.logging("Current URL =#{newUrl}")
      end
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to click"
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what}"
      false
    else

    end
  end
  # Moves to a specific element
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  def move_to_element(how,what)
    begin
      if @@debug==1
        @util.logging("-->Moving to #{what} of type #{how}")
      end
      element = @driver.find_element(how, what)
      @driver.action.move_to(element).perform
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to move to"
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what}"
      false
    else

    end
  end
  # Clicks an element and then refreshes the screen
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   msg -  Optional logging message
  def click_element_refresh(*args)
    begin
      how = args[0]
      what =args[1]
      msg=""
      if args.size ==3
        msg= args[2] + " ---->"
      end
      if @@debug==1
        @util.logging("-->Clicking #{msg} #{what} of type #{how}")
      end
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)
      if(element_present?(how, what))
        #cb.click

        @driver.find_element(how, what).click
        sleep(@@actionsleep)
      else
        @driver.navigate.refresh

        sleep(2)
        @driver.find_element(how, what).click
      end

      if what =="commit" || what == "submit"
        newUrl = @driver.current_url
        @util.logging("Current URL =#{newUrl}")
      end
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError

    rescue Selenium::WebDriver::Error::UnknownError

    else

    end
  end
  # Clicks an element if the element exists. If the element is not found, it logs a warning but proceeds
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   timeout  time to wait for the element to appear
  #   msg -  Optional logging message
  def click_element_if_exists(*args)
    begin
      how = args[0]
      what =args[1]
      timeout = args[2]
      msg=""
      if (how.is_a? String)
        nLookup = get_element_from_navigation2(how,what)
        how = nLookup[0]
        what = nLookup[1]
      end
      if args.size >=4
        msg= args[3] + " ---->"
      end
      @driver.manage.timeouts.implicit_wait = timeout
      element = @driver.find_element(how , what)
      #cb.click
      if element.displayed?
        if @@debug==1
          # binding.pry
          @util.logging("-->Clicking #{msg} #{what} of type #{how}")
        end
        @driver.find_element(how, what).click
        sleep(@@actionsleep)
      end
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      insert_warning("#{msg} --> #{what} of type #{how} did not exist to click")
      true
    rescue Selenium::WebDriver::Error::UnknownError
      insert_warning("#{msg} --> #{what} of type #{how} did not exist to click")
      true

    end
  end

  # Clicks an element if the element is enabled.  If the element is not enabled, it logs a warning but proceeds
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   timeout  how long to wait for in sec
  #   msg -  Optional logging message
  def check_if_element_enabled(*args)
    begin
      how = args[0]
      what =args[1]
      timeout = args[2]
      msg=""
      if args.size >=4
        msg= args[3] + " ---->"
      end
      @driver.manage.timeouts.implicit_wait = timeout
      element = @driver.find_element(how , what)
      #cb.click
      if element.enabled?
        if @@debug==1
          @util.logging("--> Element #{msg} #{what} of type #{how} exists")
        end
      end
      return 1
    rescue Selenium::WebDriver::Error::NoSuchElementError
      insert_warning("#{what} of type #{how} did not exist to click")
      0
    rescue Selenium::WebDriver::Error::UnknownError
      insert_warning"#{what} of type #{how} did not exist to click"
      0
    else

    end
  end
  # Check if an element exists.  If the element is not found, it logs a warning but proceeds
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   msg -  Optional logging message
  #   override= Optional true or false, Overrides a failure and allows processing to continue,
  #   but sets the test case to fail
  def check_if_element_exists(*args)
    begin
      how = args[0]
      what =args[1]
      timeout = args[2]
      msg=""
      override= false
      if (how.is_a? String)
        nLookup = get_element_from_navigation2(how,what)
        how = nLookup[0]
        what = nLookup[1]
      end
      if args.size >=4
        msg=  args[3]
      end
      if args.size >=5
        override =args[4]
      end

      @driver.manage.timeouts.implicit_wait = timeout
      wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.enabled?
      }



      #cb.click
      if cb.enabled?
        if @@debug==1
          @util.logging("--> #{msg}  exists ---->#{what} of type #{how}")

          # @util.logging("--> Element #{msg} exists")
        end
      else
        return check_override(override,"--> #{msg}  was not displayed---->#{what} of type #{how} ")
      end
      return 1
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "--> #{msg}  was not displayed---->#{what} of type #{how} "
      return check_override(override,"--> #{msg}  was not displayed---->#{what} of type #{how} ")
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "--> #{msg}  was not displayed---->#{what} of type #{how} "
      return check_override(override,"--> #{msg}  was not displayed---->#{what} of type #{how} ")
    rescue Selenium::WebDriver::Error::TimeoutError
      @util.logging "--> #{msg}  was not displayed---->#{what} of type #{how} "
      return check_override(override,"---> #{msg}  was not displayed---->#{what} of type #{how} ")
    else

    end
  end
  def check_if_element_exists_and_has_value(*args)
    begin
      how = args[0]
      what =args[1]
      value = args[2]
      timeout = args[3]
      msg=""
      override= false
      if (how.is_a? String)
        nLookup = get_element_from_navigation2(how,what)
        how = nLookup[0]
        what = nLookup[1]
      end
      if args.size >=5
        msg=  args[4]
      end
      if args.size >=6
        override =args[5]
      end

      @driver.manage.timeouts.implicit_wait = timeout
      wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.enabled?
      }



      #cb.click
      if cb.enabled?
        if @@debug==1
          if (cb.attribute("value") == value)
          @util.logging("--> #{msg} exists and has value of #{value}  ----> #{what} of type #{how}")
          else
            check_override(override,"--> #{msg} exists but does not have the expected value of #{value}. It has #{cb.attribute("value")} ---->    #{what} of type #{how} was not displayed")
          end
        end
      else
        return check_override(override,"--> #{msg}  ----> #{what} of type #{how} was not displayed")
      end
      return 1
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "#{what} of type #{how} is not displayed-  #{msg}"
      return check_override(override,"--> Element #{msg} #{what} of type #{how} was not displayed")
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "#{what} of type #{how} is not displayed - #{msg}"
      return check_override(override,"--> Element #{msg} #{what} of type #{how} was not displayed")
    rescue Selenium::WebDriver::Error::TimeoutError
      @util.logging "#{what} of type #{how} is not displayed - #{msg}"
      return check_override(override,"--> Element #{msg} #{what} of type #{how} was not displayed")
    else

    end
  end
  def check_if_element_exists_get_element_text(*args)
    begin
      how = args[0]
      what =args[1]
      timeout = args[2]
      if (how.is_a? String)
        nLookup = get_element_from_navigation2(how,what)
        how = nLookup[0]
        what = nLookup[1]
      end
      msg=""
      override= false

      if args.size >=4
        msg= args[3]
      end
      if args.size >=5
        override =args[4]
      end

      @driver.manage.timeouts.implicit_wait = timeout
      wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.displayed?
      }



      #cb.click
      if cb.displayed?
        if @@debug==1
          @util.logging("--> Verified #{msg} exists  with text \n #{cb.text}  ---->#{what} of type #{how} ")
          return cb.text
          # @util.logging("--> Element #{msg} exists")
        end
      else
        return check_override(override,"--> Not Displayed #{msg} #{what} of type #{how}")
      end
    
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "#{what} of type #{how} is not displayed-  #{msg}"
      return check_override(override,"--> Not Displayed #{msg} #{what} of type #{how} ")
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "#{what} of type #{how} is not displayed - #{msg}"
      return check_override(override,"--> Not Displayed #{msg} #{what} of type #{how} ")
    rescue Selenium::WebDriver::Error::TimeoutError
      @util.logging "#{what} of type #{how} is not displayed - #{msg}"
      return check_override(override,"--> Not Displayed #{msg} #{what} of type #{how} ")
    else

    end
  end


  # Check if an element exists.  If the element is not found, it logs a warning but proceeds
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   msg -  Optional logging message
  #   override= Optional true or false, Overrides a failure and allows processing to continue,
  #   but sets the test case to fail
  def check_if_element_not_exist(*args)
    begin
      how = args[0]
      what =args[1]
      timeout = args[2]
      msg=""
      override= false
      if args.size >=4
        msg=  args[3]
      end
      if args.size >=5
        override =args[4]
      end

      @driver.manage.timeouts.implicit_wait = timeout
      wait = Selenium::WebDriver::Wait.new(:timeout => timeout)
      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.enabled?
      }

      if cb.enabled?
        if @@debug==1
          check_override(override,"--> Element #{msg}  is displayed and should NOT be -->identifier #{what} of type #{how}")
          @util.logging("#{overide} --> Element #{msg} is displayed and should NOT be -->identifier #{what} of type #{how}")
        end
      else
        return  false
      end
      return false
    rescue Selenium::WebDriver::Error::NoSuchElementError
      return true
    rescue Selenium::WebDriver::Error::UnknownError

      return true
    rescue Selenium::WebDriver::Error::TimeoutError
      return true
    else

    end
  end
  # Check if an error message exists.  If the error message is not found it fails unless override is set to true
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   msg    Expected Error message
  #   override= Optional true or false, Overrides a failure and allows processing to continue,
  #   but sets the test case to fail
  #   logMsg -
  def check_if_error_message_exists(*args)
    begin
      how = args[0]
      what =args[1]
      timeout = args[2]
      override= false
      msg=""
      logMsg=""
      if args.size >=4
        msg= args[3]
      end
      if args.size >=5
        override =args[4]
      end
      if args.size >=6
        logMsg =args[5]
      end

      @driver.manage.timeouts.implicit_wait = timeout
      element = @driver.find_element(how , what)
      #cb.click
      if element.displayed?
        errorText=element.text
        if (@@debug==1)  && (msg == errorText)
          @util.logging("--> Error  #{what} of type #{how} is displayed with error text #{errorText}")
        elsif (@@debug==1) &&  (msg != errorText)
          @util.logging("--> Error  #{what} of type #{how} is displayed with error text #{errorText} but was expecting #{msg}")
          return check_override(override,"--> Error  #{what} of type #{how} is displayed with error text #{errorText} but was expecting #{msg}")
        end
      else
        @util.logging("--> Error #{msg} #{what} of type #{how} is not displayed")
        return check_override(override,"--> Error #{msg} #{what} of type #{how} was not displayed")

      end


    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "#{what} of type #{how} is not displayed-  #{msg}"
      return check_override(override,"--> Error #{msg} #{what} of type #{how} was not displayed")
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "#{what} of type #{how} is not displayed - #{msg}"
      return check_override(override,"--> Error #{msg} #{what} of type #{how} was not displayed")
    else

    end
  end
  # Override function,  if the override is true from any function it sets @@test_case_fail to true for the end of the test,
  #   logs an error, stores the error in an array of errors, clears the test unit failure by returning true. If override is false, it simply returns false.
  #   at the end of the test case the  teardown_tasks function checks for @@test_case_fail to be true to set the test as failed and logs the array of @@test_case_fail_details
  #   return true or false
  #   overide boolean if true, the failure is overriden and the test case continues but sets the @@test_case_fail to true
  #   failError error message
  #   takeShapshot  boolean true to take a picture of the browser with the error, false to not take a snapshot
  def check_override(*args)
    override = args[0]
    failError =args[1]
    takeSnapshot=true
    if args.size >=3
      takeSnapshot=args[2]
    end
    if (override==true)
      @@test_case_fail=true
      artifactLength = @@test_case_fail_artifacts.length
      newArrayStart = @@test_case_fail_details.length
      #binding.pry
      if takeSnapshot==true
        justFile =@@g_base_dir[(@@g_base_dir.rindex('/')+1)..@@g_base_dir.length]
        @@test_case_fail_details[newArrayStart] ="#{failError} -> Failed snapshot at #{@@artifact_dir}/#{justFile}_#{artifactLength}.png "
        @driver.save_screenshot("#{@@artifact_dir}/FAIL#{justFile}_#{artifactLength}.png")
        # shortArtifactDir = @@artifact_dir.gsub("\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs\\","")
       # binding.pry
        shortArtifactDir = @@artifact_dir.downcase.gsub("c:/automation/logs/","#{@@base_url[0..(@@base_url.length-2)]}:8001\\")
        #  shortArtifactDir = @@artifact_dir.gsub("c:/Automation/logs/","#{@@base_url[0..(@@base_url.length-2)]}:8001\\")

        @@test_case_fail_artifacts.push("#{shortArtifactDir}\\\\FAIL#{justFile}_#{artifactLength}.png")
      else
        @@test_case_fail_details[newArrayStart] ="#{failError}"
      end
      @util.logging(" <font color=\"red\">______FAILURE!!! Previous line failed-Continuing on__________</font>")
      # if takeSnapshot==true
      #  @util.logging("Failed snapshot at #{@@artifact_dir}\\\\#{justFile}_#{newArrayStart}.png ")
      # end

      return  true
    elsif (override=="warn")
     # binding.pry
      @@test_case_fail=false
      artifactLength = @@test_case_fail_artifacts.length
      newArrayStart = @@test_case_fail_details.length

      if takeSnapshot==true
        justFile =@@g_base_dir[(@@g_base_dir.rindex('/')+1)..@@g_base_dir.length]
        @@test_case_fail_details[newArrayStart] ="#{failError} -> Failed snapshot at #{@@artifact_dir}\\\\#{justFile}_#{artifactLength}.png "
        @driver.save_screenshot("#{@@artifact_dir}/FAIL#{justFile}_#{artifactLength}.png")
        # shortArtifactDir = @@artifact_dir.gsub("\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs\\","")
      # binding.pry
        shortArtifactDir = @@artifact_dir.downcase.gsub("c:/automation/logs/","#{@@base_url[0..(@@base_url.length-2)]}:8001\\")

        #  shortArtifactDir = @@artifact_dir.gsub("c:/Automation/logs/","#{@@base_url[0..(@@base_url.length-2)]}:8001\\")

        @@test_case_fail_artifacts.push("#{shortArtifactDir}/FAIL#{justFile}_#{artifactLength}.png")
      else

        insert_warning(failError)
      end
      @util.logging(" <font color=\"orange\">______Warning!! Previous line failed-Continuing on__________</font>")
      @util.logging("</font>")
      # if takeSnapshot==true
      #  @util.logging("Failed snapshot at #{@@artifact_dir}\\\\#{justFile}_#{newArrayStart}.png ")
      # end

      return  "warn"
    else
      @@test_case_fail=true
      artifactLength = @@test_case_fail_artifacts.length
      newArrayStart = @@test_case_fail_details.length
      if takeSnapshot==true
        justFile =@@g_base_dir[(@@g_base_dir.rindex('/')+1)..@@g_base_dir.length]
        @@test_case_fail_details[newArrayStart] ="#{failError} -> Failed snapshot at #{@@artifact_dir}\\\\#{justFile}_#{artifactLength}.png "
        @driver.save_screenshot("#{@@artifact_dir}/FAIL#{justFile}_#{artifactLength}.png")
        #shortArtifactDir = @@artifact_dir.gsub("\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs\\","")
      #    binding.pry
        shortArtifactDir = @@artifact_dir.downcase.gsub("c:/automation/logs/","#{@@base_url[0..(@@base_url.length-2)]}:8001\\")
        # shortArtifactDir = @@artifact_dir.gsub("c:/Automation/logs/","#{@@base_url[0..(@@base_url.length-2)]}:8001\\")

        #shortArtifactDir = @@artifact_dir.gsub("c:\\\\automation\\logs","\\#{@@enviroment}")
        # @@test_case_fail_artifacts.push("#{shortArtifacteDir}\\\\FAIL#{justFile}_#{artifactLength}.png")
      else
        @@test_case_fail_details[newArrayStart] ="#{failError}"
      end
      return false
    end
  end
  # Inserts a test case warning that shows up in the test case and at the end of the test case either in a pass or fail
  #    warn string with the warning to insert
  def insert_warning(warning)
    @util.logging("<font color =\"orange\">WARN --> Failed (to) -#{warning}</font>")
    @util.logging("</font>")
    nextWarning = @@test_case_warn_details.count
    @@test_case_warn_details[nextWarning] = warning
    # @@test_case_warn_details.push(warning)
  end

  # Drags and drops an element from one positon to another.  have to add a midpoint element to drag to before final
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   mid_how= midpoint to drag to element type
  #   mid_what= midpoint to drag to element identifier
  #   to_how =  end point to drag to element type
  #   to_what= end point to drag to element identifier
  #   msg -  Optional logging message
  def drag_and_drop_element_to(*args)
    begin
      how = args[0]
      what =args[1]
      mid_how= args[2]
      mid_what=args[3]
      to_how =  args[4]
      to_what= args[5]
      msg=""
      if args.size ==7
        msg= args[6] + " ---->"
      end
      if @@debug==1
        @util.logging("-->Clicking #{msg} #{what} of type #{how}")
      end
      el1 = @driver.find_element(how, what)
      el_in_between = @driver.find_element(mid_how,mid_what)
      el2 = @driver.find_element(to_how, to_what)
      #@driver.action.drag_and_drop(el1, el2).perform
      @driver.action.click_and_hold(el1).perform

      sleep 1
      puts"clicked"

      @driver.action.move_to(el_in_between).perform
      puts"move mid"
      sleep 1
      @driver.action.move_to(el2).perform
      puts"move final"
      sleep 1
      @driver.action.release.perform
      @driver.action.release(el1).perform
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to click or Failed find element for #{to_how} and #{to_what} "
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what} to click or Failed find element for #{to_how} and #{to_what}"
      false
    else

    end
  end
  # Waits for element to exists.
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   msg -  Optional logging message
  def wait_for_element(*args)
    begin
      how = args[0]
      what =args[1]
      msg=""
      timeout = 60
      if (how.is_a? String)
        nLookup = get_element_from_navigation2(how,what)
        how = nLookup[0]
        what = nLookup[1]
      end
      if args.size >= 3
        msg= args[2] + " ---->"
      end
      if args.size >= 4
        timeout= args[3]
      end
      if @@debug==1
        @util.logging("-->Waiting for #{msg} #{what} of type #{how}")
      end
      wait = Selenium::WebDriver::Wait.new(:timeout => timeout)

      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.enabled?
      }
      if (cb.enabled? != true)
        false
      end

      #@driver.find_element(how, what).click
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to click"
      sleep(1)
      false
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      @util.logging "Selenium::WebDriver::Error::StaleElementReferenceError: stale element reference: element is not attached to the page document"
      sleep(5)
      true
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what}"
      sleep(1)
      false
    else

    end

  end
  # Clicks on an element and waits
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #    msg -  Optional logging message
  def click_and_wait_element(*args)
    begin
      how = args[0]
      what =args[1]
      msg=""
      if args.size ==3
        msg= args[2] + " ---->"
      end
      if @@debug==1
        @util.logging("-->Clicking #{msg} #{what} of type #{how}")
      end
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)

      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.displayed?
      }
      cb.click

      #@driver.find_element(how, what).click

      Boolean element = wait.until(ExpectedConditions.invisibilityOfElementLocated(By.id(cb.IS_WAIT_PRESENT)))
      sleep(@@actionsleep)
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to click"
      sleep(1)
      true

    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what}"
      sleep(1)
      true
    else

    end
  end
  # Check if an element exists, if the element does not exist, it clicks another element.
  #   searchHow the first element to search for type
  #   searchWhat the first element to search for identifier
  #   clickHow the failure element to click type
  #   clickWhat the failure element to click type
  #   msg -  Optional logging message
  def click_if_something_not_exist(*args)
    searchforHow= args[0]
    searchforWhat=args[1]
    clickHow=args[2]
    clickWhat=args[3]
    if args.size ==5
      msg= args[4] + " ---->"
    end
    Selenium::WebDriver::Wait.new(:timeout => 3)
    @driver.find_element(searchforHow,searchforWhat)
    Selenium::WebDriver::Wait.new(:timeout => 20)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    @util.logging("-->Clicking #{clickHow} with #{clickWhat}")
    @driver.find_element(clickHow,clickWhat).click

    Selenium::WebDriver::Wait.new(:timeout => 20)
    true
  end
  # Click an element , then checks that another element (or the same) shows
  #   searchHow the first element to search for type
  #   searchWhat the first element to search for identifier
  #   clickHow the failure element to click type
  #   clickWhat the failure element to click type
  #   msg -  Optional logging message
  def click_element_verify(how,what,vhow,vwhat)
    begin
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)

      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.displayed?
      }
      #cb.click

      @driver.find_element(how, what).click
      sleep(@@actionsleep)
      if !(@driver.find_element(vhow,vwhat))
        @util.logging("Click did not take #{how}, #{what}. Retry")
        @driver.find_element(how, what).click
        sleep(2)
      end
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to click"
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what}"
      false
    else

    end
  end
  # Enters text into an element.
  #   how type of element
  #   what element identifier
  #   message  - the text to send
  #   msg -  Optional logging message
  def enter_text(*args)
    begin
      how = args[0]
      what =args[1]
      message =args[2]
      msg=""
      sendTextDirect = false

      if  (how.is_a? String)
        nLookup = get_element_from_navigation2(how,what)
        how = nLookup[0]
        what = nLookup[1]
      end

      if args.size >=4
        msg= args[3] + "---->"
      end
      if args.size >=5
        sendTextDirect= args[4]
      end
      if @@debug==1
        @util.logging("-->Entering '#{message}' into #{msg} #{what} of type #{how}")
      end
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)

      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.displayed?
      }
      #cb.click

      @driver.find_element(how, what).clear

      sleep(1)
      if !(@bs.nil?)
        bsFirefoxOverride = @bs.include?("Firefox")
      else
        bsFirefoxOverride = false
      end
      if (sendTextDirect == false) || (bsFirefoxOverride)
        @driver.find_element(how, what).send_keys message
      else
        @driver.action.send_keys(message).perform
      end
      sleep(1)
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to enter text into"
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what} to enter text into"
      false
    else

    end
  end
  # Enters text into an element without clearing the data first
  #   how type of element
  #   what element identifier
  #   message  - the text to send
  #   msg -  Optional logging message
  def enter_text_no_clear(*args)
    begin
      how = args[0]
      what =args[1]
      message =args[2]
      msg=""
      sendTextDirect = false
      if args.size >=4
        msg= args[3] + "---->"
      end
      if args.size >=5
        sendTextDirect= args[4]
      end

      if @@debug==1
        @util.logging("-->Entering '#{message}' into #{msg} #{what} of type #{how}")
      end
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)

      # cb = wait.until {
      #   element = @driver.find_element(how , what)
      #   element if element.displayed?
      # }
      #cb.click

      if !(@bs.nil?)
        bsFirefoxOverride = @bs.include?("Firefox")
      else
        bsFirefoxOverride = false
      end
      if (sendTextDirect == false) || (bsFirefoxOverride)
        @driver.find_element(how, what).send_keys message
      else
        @driver.action.send_keys(message).perform
      end
      sleep(1)
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to enter text into"
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what} to enter text into"
      false
    else

    end
  end
  # Depricated
  #   Enter the TEXT you want to find, TEXT COLUMN, LINK & LINK COLUMN

  def click_tablerow_links(*arg) #(txt,txtCol,link,linkCol)
    begin
      txt = arg[0]
      txtCol = arg[1]
      link  = arg[2]
      linkCol = arg[3]
    end
    click_element(:xpath,"//td[#{txtCol}][cz4/../td[#{linkCol}]/a[contains(text(),'#{link}')]"," Find #{txt} in table, click #{link} link")
  end

  # Sets the value of an element through java script.
  #   how type of element  either :id or :class
  #   what element identifier
  #   value  the value to set the element
  #   msg -  Optional logging message
  def set_value_of_element(how,what,value)
    if how ==:id
      puts @driver.execute_script("$(document.getElementById('#{what}').value='#{value}').change()")
    elsif how ==:class
      puts @driver.execute_script("$(document.getElementsByClassName('#{what}')).val('#{value}').change()")
    end


  end

  # Waits till an element exists for the alotted time.
  #   how type of element
  #   what element identifier
  #   time  the time to wait in seconds
  def wait_till_exist(how,what,time)
    begin
      wait = Selenium::WebDriver::Wait.new(:timeout => time)
      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.displayed?
      }
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} "
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what}"
      false
    end
  end
  # Waits till an element is visible for the alotted time.
  #   how type of element
  #   what element identifier
  #   time  the time to wait in seconds
  def check_if_exist(how,what,time)
    begin
      @driver.manage.timeouts.implicit_wait = time

      element =@driver.find_elements(how , what)
      if element.length >=1
        #Update this to check the the first element of the array is displayed......  duh this is a find elements
        # element.displayed?
        true
        @driver.manage.timeouts.implicit_wait = 120
      else
        false
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} "
      @driver.manage.timeouts.implicit_wait = 120
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "2 Failed find element for #{how} and #{what}"
      @driver.manage.timeouts.implicit_wait = 120
      false
    end
  end
 def set_iframe(how,what)
  begin
      how = args[0]
      what =args[1]
      if  (how.is_a? String)
        nLookup = get_element_from_navigation2(how,what)
        how = nLookup[0]
        what = nLookup[1]
      end
      frame = @driver.find_element(how,what)
    @driver.switch_to.frame(frame)
    if frame['name'] != ''
      frameLocator= frame['name']
    elsif frame['class'] != ''
      frameLocator = frame['class']
    elsif frame['id'] != ''
      frameLocator = frame['id']
    else
      @util.errorlogging ("Unknown frame name: #{frame['name']} class: #{frame['class']} id: #{frame['id']}")
       throw ("Unknown frame name: #{frame['name']} class: #{frame['class']} id: #{frame['id']}")
    end

      @util.logging("Switched to #{frameLocator}")
        rescue
      check_override(true,"Unable to switch to iFrame  #{how} and #{what} ",false)
    end
end

def return_to_default_frame()
    @driver.switch_to.default_content
    @util.logging("Returning to default content")
end
  # Selects a value from a dropdown list element
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   message  The option to select from the dropdown list.  If value = 'index' convert message to integer and select the option by index
  #   msg -optional-  the logging message
  #   value -optional- If value = 'index' convert message to integer and select the option by index otherwise selects the option by text

  def select_dropdown_list_text(*args)
    begin
      how = args[0]
      what =args[1]
      message =args[2]
      msg=""
      if  (how.is_a? String)
        nLookup = get_element_from_navigation2(how,what)
        how = nLookup[0]
        what = nLookup[1]
      end

      if args.size >=4
        msg= args[3] + "---->"
      end
      if args.size ==5
        value=args[4]
      end
      if @@debug==1
       if value !="index"
          @util.logging("-->Selecting  #{msg} '#{message}' from  #{what} of type #{how}")
        else
          @util.logging("-->Selecting  #{msg} #{message} from  #{what} of type #{how}")
        end
      end
      wait = Selenium::WebDriver::Wait.new(:timeout => 180)
    element =""
      cb = wait.until {
        element = @driver.find_element(how , what)
        
      }
        if (element.attribute("style")== "display: none;")
           @driver.execute_script("arguments[0].style='display: block;'", element) #hack to bypass the DBP implementation of multiselect
        end
      option = Selenium::WebDriver::Support::Select.new( @driver.find_element(how, what))
      if value=='index'
        option.select_by(:index, message.to_i)
      else
        option.select_by(:text, message)
      end
      # cb = @driver.find_element(how,what)
      # @driver.action.send_keys(cb,message).perform  #select
      # cb.click
      #@driver.action.send_keys(cb,:tab)#move off of the selected element

      sleep(2)
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to select #{message} from"
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "1 Failed find element for #{how} and #{what} to select #{message} from"
      false
    else

    end

  end
    # Selects a value from a dropdown list element
  #   how  element type (i.e. xpath, id etc)
  #   what element identifier
  #   message  The option to select from the dropdown list.  If value = 'index' convert message to integer and select the option by index
  #   msg -optional-  the logging message
  #   value -optional- If value = 'index' convert message to integer and select the option by index otherwise selects the option by text

  def select_dropdown_list_text_multi(*args)
    begin
      how = args[0]
      what =args[1]
      message =args[2]
      msg=""
      if  (how.is_a? String)
        nLookup = get_element_from_navigation2(how,what)
        how = nLookup[0]
        what = nLookup[1]
      end

      if args.size >=4
        msg= args[3] + "---->"
      end
      if args.size ==5
        value=args[4]
      end
      if @@debug==1
       if value !="index"
          @util.logging("-->Selecting  #{msg} '#{message}' from  #{what} of type #{how}")
        else
          @util.logging("-->Selecting  #{msg} #{message} from  #{what} of type #{how}")
        end
      end
      binding.pry
      wait = Selenium::WebDriver::Wait.new(:timeout => 180)

      cb = wait.until {
        element = @driver.find_element(how , what)
        binding.pry
          if (element.attribute("style")== "display: none;")
           @driver.execute_script("arguments[0].style='display: block;'", element)
        end
      }
      option = Selenium::WebDriver::Support::Select.new( @driver.find_element(how, what))
      if value=='index'
        option.select_by(:index, message.to_i)
      else
        option.select_by(:text, message)
      end
      # cb = @driver.find_element(how,what)
      # @driver.action.send_keys(cb,message).perform  #select
      # cb.click
      #@driver.action.send_keys(cb,:tab)#move off of the selected element

      sleep(2)
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.logging "1 Failed find element for #{how} and #{what} to select #{message} from"
      false
    rescue Selenium::WebDriver::Error::UnknownError
      @util.logging "1 Failed find element for #{how} and #{what} to select #{message} from"
      false
    else

    end

  end
  # reads the optional environment_variables.txt for use in batchfiles
  #   filedir -  the directory where the automation repository exits
  #   populates the environment, browser, branch and installDate variables
  def read_enviro_variables(filedir)
    counter =1
    enviro=""
    brws=""
    branch=""
    installDate=""
    File.open("#{filedir}/environment_variables.txt","r") do |infile|
      while (line = infile.gets)
        #  @util.logging"#{counter}: #{line}"
        if counter ==1
          enviro="#{line}"
          enviro=enviro.delete!("\r\n")
        end
        if counter ==2
          brws="#{line}"
          brws=brws.delete!("\r\n")
        end
        if counter ==3
          dbName="#{line}"
          @@enviroDB=dbName
        end
        if counter ==4
          installDate="#{line}"
          #installDate=installDate.delete!("")
        end
        counter = counter + 1
      end
      return enviro,brws,dbName,installDate
    end
  end
  # Helper function for modifying the path variable for Windows
  #   path - the path global variable
  def modify_path(path)
    if "#{RUBY_PLATFORM}" == "i386-mingw32" ||  "#{RUBY_PLATFORM}" == "x64-mingw32"
      path = path.gsub('\\','\\\\')
      path = path.gsub('/','\\')
      puts "The string sent is \n#{path}"

    end
    return path
  end
  # Takes program,days,endDays,curIteration,endIteration,skipEnabled
  #   required filedir
  #   required filebase
  #   headless allows this to run without a browser, default is no
  #   called in every test case
  #   checks if the script is set to log to the db.  If it is, it writes a temporary record and retrieves a db_id which is the unique testcase run identifier
  #   logs test information including environment, browser, browser type, machine run on, date time etc.
  def setup_tasks (*args)

    @@test_case_fail = false
    @@test_case_fail_details.clear
    @@test_case_fail_artifacts.clear
    @@test_case_warn_details.clear
    filedir= args[0]
    filebase = args[1]
    headless = false
    if args.size >=3
      if args[1].size >1
        headless= args[2]
      end
    end
    @@filebase = filebase
    @@filedir = modify_path(filedir)

    environment=""
    time = Time.new
    newRand = rand(10000)
    dateTime = "#{time.month}_#{time.day}_#{time.year}_#{time.hour}_#{time.min}"
    base_dir = filedir
    file_name= filebase[/.*(?=\..+$)/]
    file_name=  file_name+"results#{dateTime}.txt"

    full= "#{base_dir}/logs/#{file_name}"
    @@g_base_dir=full
    @util = Util.new("#{full}")
    set_artifact_dir()

    @@util=@util

    if File.exists?("#{filedir}/environment_variables.txt")
      @util.logging("Using the environment_variables.txt values")
      environment,brws,dbName,installDate = read_enviro_variables(filedir)
      @util.setUsingEnviro()
    end

    if headless==true
    end
    if environment  == ""
      environment,brws = choose_environment
    end

    if @@logToQADatabase ==1
      @@db_id=db_log_start(file_name)

    end

    if @@brws=="ie"
      if brws.include? "BS-"
        @@brws="BS-Chrome"
      end
      @util.logging "Test case only runs in #{@@brws}.  Forcing the browser to #{@@brws}"
      brws=@@brws
    end


    if brws=="BS-IE11"
      caps = Selenium::WebDriver::Remote::Capabilities.new

      caps['browser'] = 'IE'
      caps['browser_version'] = '11.0'
      caps['os'] = 'Windows'
      caps['os_version'] = '10'
      caps['resolution'] = '1024x768'
      caps['name'] = "#{filebase} #{@@db_id}"

      caps["browserstack.debug"] = "true"
      caps['browserstack.local'] = 'true'
      caps['javascriptEnabled'] = 'true'
      caps['takesScreenshot'] = 'true'
      caps['nativeEvents']='true'
      caps['cssSelectorsEnabled']='true'
      @driver = Selenium::WebDriver.for(:remote,
                                        :url => "http://chrisgoodnight3:Afzgzx7vxbAGd5zjvcp2@hub-cloud.browserstack.com/wd/hub",
                                        :desired_capabilities => caps)
      @@os="x64-mingw32"
      brws="ie"
      @bs="BS-IE11"
      bs_id=@driver.session_id
      @util.logging("The Browserstack session id = #{bs_id}")
    elsif brws=="BS-IE10"
      caps = Selenium::WebDriver::Remote::Capabilities.new

      caps['browser'] = 'IE'
      caps['browser_version'] = '10.0'
      caps['os'] = 'Windows'
      caps['os_version'] = '8'
      caps['resolution'] = '1024x768'
      caps['name'] = "#{filebase} #{@@db_id}"
      caps["browserstack.debug"] = "true"
      caps['browserstack.local'] = 'true'
      caps['javascriptEnabled'] = 'true'
      caps['takesScreenshot'] = 'true'
      caps['nativeEvents']='true'
      caps['cssSelectorsEnabled']='true'


      @driver = Selenium::WebDriver.for(:remote,
                                        :url => "http://chrisgoodnight3:Afzgzx7vxbAGd5zjvcp2@hub-cloud.browserstack.com/wd/hub",
                                        :desired_capabilities => caps)
      @@os="x64-mingw32"
      brws="ie"
      @bs = "BS-IE10"
      bs_id=@driver.session_id
      @util.logging("The Browserstack session id = #{bs_id}")
    elsif brws=="BS-Win10-Firefox"
      caps = Selenium::WebDriver::Remote::Capabilities.new

      caps['browser'] = 'Firefox'
      caps['browser_version'] = '54.0'
      caps['os'] = 'Windows'
      caps['os_version'] = '10'
      caps['resolution'] = '1024x768'
      caps['name'] = "#{filebase} #{@@db_id}"
      caps["browserstack.debug"] = "true"
      caps['browserstack.local'] = 'true'
      caps['javascriptEnabled'] = 'true'
      caps['takesScreenshot'] = 'true'
      caps['nativeEvents']='true'
      caps['cssSelectorsEnabled']='true'


      @driver = Selenium::WebDriver.for(:remote,
                                        :url => "http://chrisgoodnight3:Afzgzx7vxbAGd5zjvcp2@hub-cloud.browserstack.com/wd/hub",
                                        :desired_capabilities => caps)
      @@os="x64-mingw32"
      brws="firefox"
      @bs = "BS-Win10-Firefox"
      bs_id=@driver.session_id
      @util.logging("The Browserstack session id = #{bs_id}")

    elsif brws=="BS-IPadPro"
      caps['browserName']='iPad'
      caps['platform']='MAC'
      caps['device'] = 'iPad Pro'
      caps['name'] = "#{filebase} #{@@db_id}"
      caps["browserstack.debug"] = "true"
      caps['browserstack.local'] = 'true'
      caps['javascriptEnabled'] = 'true'
      caps['takesScreenshot'] = 'true'
      caps['nativeEvents']='true'
      caps['cssSelectorsEnabled']='true'


      @driver = Selenium::WebDriver.for(:remote,
                                        :url => "http://chrisgoodnight3:Afzgzx7vxbAGd5zjvcp2@hub-cloud.browserstack.com/wd/hub",
                                        :desired_capabilities => caps)
      @@os="darwin"
      brws="iPad"
      @bs = "BS-IPadPro"
      bs_id=@driver.session_id
      @util.logging("The Browserstack session id = #{bs_id}")
    elsif brws=="BS-IE9"
      caps = Selenium::WebDriver::Remote::Capabilities.new

      caps['browser'] = 'IE'
      caps['browser_version'] = '9.0'
      caps['os'] = 'Windows'
      caps['os_version'] = '7'
      caps['resolution'] = '1024x768'
      caps['name'] = "#{filebase} #{@@db_id}"
      caps["browserstack.debug"] = "true"
      caps['browserstack.local'] = 'true'
      caps['javascriptEnabled'] = 'true'
      caps['takesScreenshot'] = 'true'
      caps['nativeEvents']='true'
      caps['cssSelectorsEnabled']='true'


      @driver = Selenium::WebDriver.for(:remote,
                                        :url => "http://chrisgoodnight3:Afzgzx7vxbAGd5zjvcp2@hub-cloud.browserstack.com/wd/hub",
                                        :desired_capabilities => caps)
      @@os="x64-mingw32"
      brws="ie"
      @bs = "BS-IE10"
      bs_id=@driver.session_id
      @util.logging("The Browserstack session id = #{bs_id}")


    elsif brws=="BS-Edge"
      caps = Selenium::WebDriver::Remote::Capabilities.new

      caps['browser'] = 'Edge'
      caps['browser_version'] = '13.0'
      caps['os'] = 'Windows'
      caps['os_version'] = '10'
      caps['resolution'] = '1024x768'
      caps['name'] = "#{filebase} #{@@db_id}"
      caps["browserstack.debug"] = "true"
      caps['browserstack.local'] = 'true'
      caps['javascriptEnabled'] = 'true'
      caps['takesScreenshot'] = 'true'
      caps['nativeEvents']='true'
      caps['cssSelectorsEnabled']='true'


      @driver = Selenium::WebDriver.for(:remote,
                                        :url => "http://chrisgoodnight3:Afzgzx7vxbAGd5zjvcp2@hub-cloud.browserstack.com/wd/hub",
                                        :desired_capabilities => caps)
      @@os="x64-mingw32"
      brws="Google Chrome"
      @bs = "BS-Edge"
      bs_id=@driver.session_id
      @util.logging("The Browserstack session id = #{bs_id}")
    elsif brws=="BS-Chrome"
      caps = Selenium::WebDriver::Remote::Capabilities.new

      caps['browser'] = 'Chrome'
      caps['browser_version'] = '52.0'
      caps['os'] = 'Windows'
      caps['os_version'] = '10'
      caps['resolution'] = '1024x768'
      caps['name'] = "#{filebase} #{@@db_id}"
      caps["browserstack.debug"] = "true"
      caps['browserstack.local'] = 'true'
      caps['javascriptEnabled'] = 'true'
      caps['takesScreenshot'] = 'true'
      caps['nativeEvents']='true'
      caps['cssSelectorsEnabled']='true'


      @driver = Selenium::WebDriver.for(:remote,
                                        :url => "http://chrisgoodnight3:Afzgzx7vxbAGd5zjvcp2@hub-cloud.browserstack.com/wd/hub",
                                        :desired_capabilities => caps)
      @@os="x64-mingw32"
      brws="Google Chrome"
      @bs = "BS-Chrome"
      bs_id=@driver.session_id
      @util.logging("The Browserstack session id = #{bs_id}")
    elsif  brws =="BS-Mac-Safari"
      caps = Selenium::WebDriver::Remote::Capabilities.new

      caps['browser'] = 'Safari'
      caps['browser_version'] = '5.1'
      caps['os'] = 'OS X'
      caps['os_version'] = 'Snow Leopard'
      caps['resolution'] = '1024x768'
      caps['name'] = "#{filebase} #{@@db_id}"
      caps["browserstack.debug"] = "true"
      caps['browserstack.local'] = 'true'
      caps['javascriptEnabled'] = 'true'
      caps['takesScreenshot'] = 'true'
      caps['nativeEvents']='true'
      caps['cssSelectorsEnabled']='true'
      @driver = Selenium::WebDriver.for(:remote,
                                        :url => "http://chrisgoodnight3:Afzgzx7vxbAGd5zjvcp2@hub-cloud.browserstack.com/wd/hub",
                                        :desired_capabilities => caps)
      @@os="darwin"
      brws="safari"
      @bs="BS-MacSafari"
      bs_id=@driver.session_id
      @util.logging("The Browserstack session id = #{bs_id}")
    elsif  brws =="BS-Mac-Firefox"
      caps = Selenium::WebDriver::Remote::Capabilities.new

      caps['browser'] = 'Firefox'
      caps['browser_version'] = '42.0'
      caps['os'] = 'OS X'
      caps['os_version'] = 'Snow Leopard'
      caps['resolution'] = '1024x768'
      caps['name'] = "#{filebase} #{@@db_id}"
      caps["browserstack.debug"] = "true"
      caps['browserstack.local'] = 'true'
      caps['javascriptEnabled'] = 'true'
      caps['takesScreenshot'] = 'true'
      caps['nativeEvents']='false'
      caps['cssSelectorsEnabled']='true'
      @driver = Selenium::WebDriver.for(:remote,
                                        :url => "http://chrisgoodnight3:Afzgzx7vxbAGd5zjvcp2@hub-cloud.browserstack.com/wd/hub",
                                        :desired_capabilities => caps)
      @@os="darwin"
      brws="firefox"
      @bs="BS-Mac-Firefox"
      bs_id=@driver.session_id
      @util.logging("The Browserstack session id = #{bs_id}")
    elsif  brws =="BS-Mac-Chrome"
      caps = Selenium::WebDriver::Remote::Capabilities.new

      caps['browser'] = 'Chrome'
      caps['browser_version'] = '49.0'
      caps['os'] = 'OS X'
      caps['os_version'] = 'Snow Leopard'
      caps['resolution'] = '1024x768'
      caps['name'] = "#{filebase} #{@@db_id}"
      caps["browserstack.debug"] = "true"
      caps['browserstack.local'] = 'true'
      caps['javascriptEnabled'] = 'true'
      caps['takesScreenshot'] = 'true'
      caps['nativeEvents']='true'
      caps['cssSelectorsEnabled']='true'
      @driver = Selenium::WebDriver.for(:remote,
                                        :url => "http://chrisgoodnight3:Afzgzx7vxbAGd5zjvcp2@hub-cloud.browserstack.com/wd/hub",
                                        :desired_capabilities => caps)
      @@os="darwin"
      brws="chrome"
      @bs="BS-Mac-Chrome"
      bs_id=@driver.session_id
      @util.logging("The Browserstack session id = #{bs_id}")
    elsif brws=="Sauce"

      caps = Selenium::WebDriver::Remote::Capabilities.android
      caps['browserName'] = "Browser"
      caps['appiumVersion'] = "1.3.4"
      caps['deviceName'] = "LG Nexus 4 Emulator"
      caps['device-orientation'] = "portrait"
      caps['platformVersion'] = "4.4"
      caps['platformName'] = "Android"
      caps[:name] = "#{@@filebase} on Sauce"

      @driver = Selenium::WebDriver.for(
        :remote,
        :url => "http://chrisgoodnight:c786b307-083c-4503-a57d-d7e1b27b14f1@ondemand.saucelabs.com:80/wd/hub",
      :desired_capabilities => caps)
      brws = "Nexus7"
    elsif brws == "chrome"
      ## Use below to specify a specific chrome instance
      # Selenium::WebDriver::Chrome.path=("C:\\Users\\g0h\\Downloads\\chrome32_57.0.2987.133\\chrome.exe")
      options = Selenium::WebDriver::Chrome::Options.new

      # options.binary_location("C:\\Users\\g0h\\Downloads\\chrome32_57.0.2987.133\\chrome.exe")
      #  options.add_argument('--enable-automation')
      options.add_argument('--disable-extensions')
      options.add_option("useAutomationExtension",false)

      options.add_argument('--ignore-certificate-errors')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-gpu')
      #  options.add_argument("--remote-debugging-port")
      # options.add_argument('--disable-infobars')

      # options.add_argument('--disable-translate')
      #@driver = Selenium::WebDriver.for :chrome, options: {options: {'useAutomationExtension' => false}}
      @driver = Selenium::WebDriver.for :chrome, options: options
      brws="Google Chrome"
    elsif brws == "firefox"
      ff_profile = Selenium::WebDriver::Firefox::Profile.new
      ff_profile.assume_untrusted_certificate_issuer=false
      #   ff_profile.setAcceptUntrustedCertificates(true)
      #@driver = Selenium::WebDriver.for :firefox, :profile => ff_profile
      # @driver =Selenium::WebDriver::Firefox::Options#profile= ff_profile
      #@driver = Selenium::WebDriver.for :firefox
      #  brws = "firefox"
      #capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
      # ff_profile = Selenium::WebDriver::Firefox::Profile.new
      # #output =ff_profile.assume_untrusted_certificate_issuer?
      # # ff_profile.accept_untrusted_certs = true
      # ff_profile.assume_untrusted_certificate_issuer=false
      # # output =ff_profile.assume_untrusted_certificate_issuer
      # #ff_profile.assume_untrusted_certificate_issuer = false
      # #ff_profile.set_accepted_untrusted_certificates=true
      # #ff_profile.setAcceptUntrustedCertificates(true)
      # default_profile = Selenium::WebDriver::Firefox::Profile.from_name "default"
      # default_profile.assume_untrusted_certificate_issuer = false

      # @driver = Selenium::WebDriver.for :firefox, profile: default_profile
      @driver = Selenium::WebDriver.for :firefox, marionette: true, profile: ff_profile
      # #  @driver = Selenium::WebDriver.for :firefox
      # brws = "firefox"
    elsif brws =="safari"

      @driver = Selenium::WebDriver.for :safari
      brws="Safari"
    elsif brws =="ie"
      @driver = Selenium::WebDriver.for :ie
      brws="ie"

    elsif brws == "edge"
      @driver = Selenium::WebDriver.for :edge
      brws = "edge"
    elsif brws =="iphone"

      @driver = Selenium::WebDriver.for(
        :remote,
        url: "http://localhost:5555/wd/hub",
        desired_capabilities: desired_caps2
      )
      # driver = Selenium::WebDriver.for :remote, :url => "http://localhost:5555/wd/hub", :desired_capabilities => desired_caps
      brws="iphone"
    elsif brws =="iphoneNative"
      @driver = Selenium::WebDriver.for(
        :remote,
        url: "http://localhost:5555/wd/hub",
        desired_capabilities: desired_caps3
      )
      # driver = Selenium::WebDriver.for :remote, :url => "http://localhost:5555/wd/hub", :desired_capabilities => desired_caps
      brws="iphone"
    elsif brws =="iphone_4s"
      #DesiredCapabilities safari = IOSCapabilities.iphone("Safari")
      #safari.setCapability(IOSCapabilities.SIMULATOR, true)
      #safari.setCapability("simulatorVersion", "7.0.3")
      #safari.setCapability("sdkVersion", "7.0.3")
      #RemoteWebDriver @driver = new RemoteWebDriver(new URL("http://localhost:4444/wd/hub"), safari)
      @driver = Selenium::WebDriver.for(
        :remote,
        url: "http://localhost:4723/wd/hub",
        desired_capabilities: iphone_4S_caps
      )
      # driver = Selenium::WebDriver.for :remote, :url => "http://localhost:5555/wd/hub", :desired_capabilities => desired_caps
      brws="ipad"
    elsif brws =="ipad"
      #DesiredCapabilities safari = IOSCapabilities.iphone("Safari")
      #safari.setCapability(IOSCapabilities.SIMULATOR, true)
      #safari.setCapability("simulatorVersion", "7.0.3")
      #safari.setCapability("sdkVersion", "7.0.3")
      #RemoteWebDriver @driver = new RemoteWebDriver(new URL("http://localhost:4444/wd/hub"), safari)
      @driver = Selenium::WebDriver.for(
        :remote,
        url: "http://localhost:4723/wd/hub",
        desired_capabilities: ipad2_caps
      )
      # driver = Selenium::WebDriver.for :remote, :url => "http://localhost:5555/wd/hub", :desired_capabilities => desired_caps
      brws="ipad"
    elsif brws =="android"
      #DesiredCapabilities safari = IOSCapabilities.iphone("Safari")
      #safari.setCapability(IOSCapabilities.SIMULATOR, true)
      #safari.setCapability("simulatorVersion", "7.0.3")
      #safari.setCapability("sdkVersion", "7.0.3")
      #RemoteWebDriver @driver = new RemoteWebDriver(new URL("http://localhost:4444/wd/hub"), safari)
      @driver = Selenium::WebDriver.for(
        :remote,
        url: "http://localhost:4723/wd/hub",
        desired_capabilities: android_caps
      )
      # driver = Selenium::WebDriver.for :remote, :url => "http://localhost:5555/wd/hub", :desired_capabilities => desired_caps
      brws="android"
    elsif brws =="ipadapp"
      #DesiredCapabilities safari = IOSCapabilities.iphone("Safari")
      #safari.setCapability(IOSCapabilities.SIMULATOR, true)
      #safari.setCapability("simulatorVersion", "7.0.3")
      #safari.setCapability("sdkVersion", "7.0.3")
      #RemoteWebDriver @driver = new RemoteWebDriver(new URL("http://localhost:4444/wd/hub"), safari)
      @driver = Selenium::WebDriver.for(
        :remote,
        url: "http://localhost:4723/wd/hub",
        desired_capabilities: ipad2_app_caps
      )
      # driver = Selenium::WebDriver.for :remote, :url => "http://localhost:5555/wd/hub", :desired_capabilities => desired_caps
      brws="ipad"
    elsif brws =="ipadNative"
      #DesiredCapabilities safari = IOSCapabilities.iphone("Safari")
      #safari.setCapability(IOSCapabilities.SIMULATOR, true)
      #safari.setCapability("simulatorVersion", "7.0.3")
      #safari.setCapability("sdkVersion", "7.0.3")
      #RemoteWebDriver @driver = new RemoteWebDriver(new URL("http://localhost:4444/wd/hub"), safari)
      @driver = Selenium::WebDriver.for(
        :remote,
        url: "http://localhost:5555/wd/hub",
        desired_capabilities: desired_caps4
      )
      # driver = Selenium::WebDriver.for :remote, :url => "http://localhost:5555/wd/hub", :desired_capabilities => desired_caps
      brws="ipad"
    elsif brws =="ipadDevice"
      #DesiredCapabilities safari = IOSCapabilities.iphone("Safari")
      #safari.setCapability(IOSCapabilities.SIMULATOR, true)
      #safari.setCapability("simulatorVersion", "7.0.3")
      #safari.setCapability("sdkVersion", "7.0.3")
      #RemoteWebDriver @driver = new RemoteWebDriver(new URL("http://localhost:4444/wd/hub"), safari)
      @driver = Selenium::WebDriver.for(
        :remote,
        url: "http://localhost:4723/wd/hub",
        desired_capabilities:  desired_capsdevice
      )
      # driver = Selenium::WebDriver.for :remote, :url => "http://localhost:5555/wd/hub", :desired_capabilities => desired_caps
      brws="ipad"
    elsif brws =="iphoneDevice"
      #DesiredCapabilities safari = IOSCapabilities.iphone("Safari")
      #safari.setCapability(IOSCapabilities.SIMULATOR, true)
      #safari.setCapability("simulatorVersion", "7.0.3")
      #safari.setCapability("sdkVersion", "7.0.3")
      #RemoteWebDriver @driver = new RemoteWebDriver(new URL("http://localhost:4444/wd/hub"), safari)
      @driver = Selenium::WebDriver.for(
        :remote,
        url: "http://localhost:5555/wd/hub",
        desired_capabilities:  desired_capsdevice2
      )
      # driver = Selenium::WebDriver.for :remote, :url => "http://localhost:5555/wd/hub", :desired_capabilities => desired_caps
      brws="iphone"
    else
      if brws !="headless"
        @driver = Selenium::WebDriver.for :firefox
        brws = "firefox"
      end
    end
    @util.logging "You selected #{environment} with browser=#{brws}"
    @base_url = "https://#{environment}"

    @@base_url =@base_url
    @@brws = brws
    @util.share_driver(@driver)
    @accept_next_alert = true
    @verification_errors = []
    if brws !="headless" && brws !="edge"
      @driver.manage.timeouts.implicit_wait = 120
      if @@nativeapp ==0
        @@driverVersion=@driver.execute_script("return navigator.userAgent;")
      end
    end
    @@util.logging("\n\nStarted test #{filebase} at #{dateTime}")
    puts("\n\nStarted test #{filebase} at #{dateTime}")
    # @@util.logging ("Environment =#{@base_url}")
    if brws !="headless"
      @@util.logging ("Browser= #{@driver.browser} #{@@driverVersion}")
    end
    @@util.logging ("OS = #{RUBY_PLATFORM}")
    if(("#{RUBY_PLATFORM}"=="i386-mingw32")  || ("#{RUBY_PLATFORM}"=="x64-mingw32"))
      if brws=="ie" || brws=="Edge"
        @@actionsleep=1
        @@util.logging("set the actions sleep to #{@@actionsleep}")
      end
    end
    if brws =="ipad"

      @@actionsleep=3
      puts ("set the actions sleep to #{@@actionsleep}")
    end
    if ("#{brws}"=="Google Chrome" && "#{RUBY_PLATFORM}"=="x86_64-darwin13.0.0")
      @@actionsleep=2
      @@util.logging("set the actions sleep to #{@@actionsleep}")

    end

    #  @@util.logging(sockethack())
    # branch=""
    # @@util.logging ("Branch = #{branch}")
    # @@branch = "#{branch} - #{installDate}"
    # @@util.logging ("Branch InstallDate = #{installDate}")
    @@environment= environment.upcase
    #   get_stored_dc_versions

    if brws !="headless"
      @@driver = @driver
    end
    if brws == "ipad" || brws =="iphone" || brws == "headless"
      @util.logging("Ipad so no maximize")
    else
      @driver.manage.window.maximize
    end
    set_dbs_for_environment()
  end
  # Sets the global variables for the databases for the environment based off of the @@environment variable
  def set_dbs_for_environment

  end
  # Gets the sql DB
  def get_mySqlDB
    @@mySqlDB
  end
  # Gets the current url and logs it
  def log_current_url ()
    if @@brws !="headless"
      newUrl = @driver.current_url
      @@util.logging("Current URL = #{newUrl}")
    else
      newUrl="headless"
    end
    return newUrl

  end
  # Gets the current url
  def get_url ()
    if @@brws !="headless"
      newUrl = @driver.current_url
      # @@util.logging("Current URL = #{newUrl}")
    else
      newUrl="headless"
    end
    return newUrl

  end
  # Goes to a specific url
  def goto_url(url)
    @driver.get(url)
    newUrl = log_current_url()
  end
  # Deletes all the raw files
  def check_all_files_deleted
    begin
      @@deleteFiles.each do |file|
        File.delete(file)
      end
    rescue
    end
  end
  # Tears the test down. Checks for network directory to moves the end snapshot to.  If the network is not found, the snapshot remains in the filedir/logs folder
  #   checks for pass/fail in the @@test_case_fail.  If failed it unspools all of the failures and logs them.
  #   Checks if logging is set to log to the Automation database.  If it is it logs to that database under the specific db_id testcase identifier
  def teardown_tasks(passed)
    @util.logging("V______Teardown section_________V")
    networkShare=0
    justFile=""
    time = Time.new
    check_all_files_deleted


    justFileFolder = ""
    if @@brws=="ipad" || @@brws=="iphone" || @@brws=="ipadNative" || @@brws=="iphoneNative"
    else
      failUrl =log_current_url()
    end
    #"#{RUBY_PLATFORM}". == "x86_64-darwin13.0.0"
    if RUBY_PLATFORM.include? "darwin"
      if File.directory? "/Volumes/Quality Assurance/logs"
        justFileFolder =   "#{time.month}_#{time.day}_#{time.year}"
        @util.logging("found the network directory")
        endIndex = @@g_base_dir.rindex('/')
        # puts endIndex
        justFile =@@g_base_dir[(@@g_base_dir.rindex('/')+1)..@@g_base_dir.length]

        unless File.directory? "/Volumes/Quality Assurance/logs/#{justFileFolder}/"
          FileUtils.mkdir_p("/Volumes/Quality Assurance/logs/#{justFileFolder}/")
        end
        #  @driver.save_screenshot("/Volumes/Quality Assurance/logs/#{justFileFolder}/#{justFile}.png")
        networkShare=1
      end
    else
      # if File.directory? "\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs"
      if false
        justFileFolder =   "#{time.month}_#{time.day}_#{time.year}"
        @util.logging("Found the network directory")
        endIndex = @@g_base_dir.rindex('/')
        #puts endIndex
        justFile =@@g_base_dir[(@@g_base_dir.rindex('/')+1)..@@g_base_dir.length]
        #   unless File.directory? "\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs\\#{justFileFolder}\\"
        #     FileUtils.mkdir_p("\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs\\#{justFileFolder}\\")
        #     binding.pry
        #   end

        if @@brws !="headless"
          # @driver.save_screenshot("\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs\\#{justFileFolder}\\#{justFile}.png")
          networkShare=1
          # binding.pry
        end
      end

    end
    #puts "networkshare = #{networkShare}"
    # binding.pry
    if networkShare ==0
      if @@brws !="headless"
        justFile =@@g_base_dir[(@@g_base_dir.rindex('/')+1)..@@g_base_dir.length]
        take_snapshot("Final_")
        #@driver.save_screenshot("#{@@g_base_dir}.png")
      end
    end
    #@util.logging"THE BASE DIR IS #{@@g_base_dir}.png

    if @@brws =="ie"
    end
    sleep(5)
    # @driver.close()
    if @@brws == "headless"
      reportingBrowser = "headless"
    else
      reportingBrowser= " #{@bs} #{@driver.browser} #{@@driverVersion}"
    end
    #data = dbh.escape_string(data) #escape any quotes in the data
    if  @@test_case_fail ==true
      passed=false
      @util.logging("___________________________________________________________")
      @util.logging("<font color =\"red\">Test case failed with the following errors.</font>")
      count =0
      @@test_case_fail_details.each do |row|
        @util.logging("<font color =\"red\">failure #{count} </font> -> #{row} </font>")
        count = count +1
      end
      count =0
      @@test_case_warn_details.each do |row|
        @util.logging("<font color =\"orange\">warning #{count} </font> -> #{row} </font>")
        @util.logging("</font>")
        count = count +1
      end
    end
    #@util.logging("View http://dexw5171.hr-applprep.de:8000/specifictest?#{@@db_id}")
    #if @@rplId != ""
    #  @util.logging("RplId for this run is #{@@rplId}")
   # end
    if passed then
      @util.logging("<font color =\"green\">#{@@filebase} test passed</font>")
      count =0
      @@test_case_warn_details.each do |row|
        @util.logging("<font color =\"orange\">warning #{count} </font> -> #{row} </font>")
        @util.logging("</font>")
        count = count +1
      end

      filename = @util.getLog()
      data = File.read(filename) #get the data out of the file

      #  @util.logging("Just file = #{justFile}")
      if @@logToQADatabase ==1

        justFile =filename[(filename.rindex('/')+1)..filename.length]
        db_log_results(@@filebase, @@os,reportingBrowser,@@environment,"Passed",data,"#{justFileFolder}/#{justFile}")
      else
        justFile =filename[(filename.rindex('/')+1)..filename.length]
        google_driver_log_results(filename,justFile)
      end
    else
      @util.logging("<font color =\"red\">#{@@filebase} failed </font>")
      filename = @util.getLog()
      data = File.read(filename) #get the data out of the file
      #@util.logging("this is the result #{@@after_tests.reverse_each} #{@internal_data}")
      if @@logToQADatabase ==1
        justFile =filename[(filename.rindex('/')+1)..filename.length]
        db_log_results(@@filebase, @@os,reportingBrowser,@@environment,"Failed",data,"#{justFileFolder}/#{justFile}")
      else

        justFile =filename[(filename.rindex('/')+1)..filename.length]
        google_driver_log_results(filename,justFile)
      end
    end
    if @@brws !="headless"

      @driver.quit()
    end
  end
  # Depricated used for logging to googledrive
  def google_driver_log_results(folder,file)
    #puts ("---the file folder is #{folder}")
    #puts ("---the file is #{file}")
    session = GoogleDrive::Session.from_config("config.json")

    file = session.upload_from_file("#{folder}", "#{file}")
    folder = session.collection_by_title("")
    folder.add(file)
  end
  # Runs a query against the Automation database
  #   query - the SQL query to run passed in a string. Returns  the results of the query in a hash
  def run_automation_tds_db_query(query)
    client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation'
    client.execute('SET TEXTSIZE 2147483647;')
    results = client.execute(query)
    return results
  end
  def run_automation_db_query(query)
    begin
    gateway = Net::SSH::Gateway.new(
      'outofbox.client-staging.deliverybizpro.com',
      'ubuntu',:keys=>"/Users/cgoodnight/Documents/DBP/Judd.pem"
    )
    port = gateway.open('127.0.0.1', 3306, 3307)

    client = Mysql2::Client.new(
      host: "127.0.0.1",
      username: 'root',
      password: 'delivery4u',
      database: "#{@@enviroDB}",
      port: port
    )

    results = client.query(query)
    client.close

    gateway.close(port)
    return results
  rescue => e
    @util.errorlogging("Unable to connect to the customer db.  Are you VPN'd in? \n #{e.message}")
    throw (e)
  end
  end



  # Runs an update query against the Automation database to upload the log and update the test_name, os, browser, enviro,status,data, and image.
  #   Finds the record in the db with the db_id of the current run
  #   test_name  test name string
  #   os  operating system of the machine the test ran on
  #   browser  the full information about the browser that the test ran in
  #   enviro  the environment that the test was run in
  #   status pass/fail
  #   data  all the data in the logfile for the current run-  runs data cleaner to clean the file up for being put into a database varchar(max) field.
  #   image - the final snapshot image of the browser at the end of the test
  #   goes through the list of all artifacts from the test run (snapshots,datafiles, etc) stores them in the db in the artifacts field
  #   updates everything except data first, then does data incase there is a problem (data has an unsupported character)
  def db_log_results(test_name, os,browser,enviro,status,data,image)

    time = Time.new
    testCompleted = "#{time.year}-#{time.month}-#{time.day} #{time.hour}:#{time.min}"
    client = PG::Connection.open(:dbname => 'Automation', :host => '54.201.168.175', :user => 'postgres', :password =>'getswift' )
    #conn.exec('Select * from environments')
    #client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation', timeout: 600
    data = data_cleaner(data)

    #image = "#{image}\ #{@@test_case_fail_artifacts}"
    #binding.pry
    useEmailStartIndex =data.index /Use /
    if (useEmailStartIndex.to_i >0)
      useEmailStartIndex =useEmailStartIndex +4

      useEmailEndIndex =data.index /user id/
      if (useEmailEndIndex.to_i>0)
        useEmailEndIndex=useEmailEndIndex-2
      else
        useEmailEndIndex=useEmailStartIndex+25
      end
      userEmail =data[useEmailStartIndex..useEmailEndIndex]
    else
      userEmail =""
    end
    #  newQuery = "insert into results (test_name, os,browser,enviro,status,date_run,results,branch,image)
    #values(\"#{test_name}\",\"#{os}\",\"#{browser} #{@@driverVersion}\",\"#{enviro}\",\"#{status}\",\"#{testCompleted}\",\"#{data}\",\"#{@@branch}\",\"#{userEmail}\",\"#{image}\")"
    newQuery = "insert into results (test_name,os,browser,environment,status,date_run,results,branch) values('#{test_name}','#{os}','#{browser} #{@@driverVersion}','DBP','#{status}','#{testCompleted}','#{data}','#{enviro}');"
    #binding.pry
    results = client.exec(newQuery)
    # results.each do |rowset|
    #   @util.logging(rowset)
    # end

    #   newQuery = "update results
    # set results= '#{data}'
    # where id =#{@@db_id};"

    #   results = client.execute(newQuery)
    #   if results
    #     results.each do |rowset|
    #       @util.logging(rowset)
    #     end
    #   else
    #     @util.logging("This is the Query that failed #{newQuery}")
    #   end
    #   if results.affected_rows <1
    #     truncatedQuery = "update results
    # set test_name=\"#{test_name}\",
    # os =\"#{os}\",
    # browser=\"#{browser} #{@@driverVersion}\",
    # enviro=\"#{enviro}\",
    # status=\"#{status}\",
    # date_run=\"#{testCompleted}\",
    # results= \"Unable to parse the log file to the db.  See the text file for results\",
    # branch=\"#{@@branch}\",
    # image=\"#{image}\"
    # where id =#{@@db_id};"
    #        results = client.execute(truncatedQuery)
    #        if results.affected_rows <1
    #         @util.logging("still could not update the db.  Chris look at the query #{newQuery}")
    #       end
    #   end

  end
  # Run at the start of the test run.
  #   Logs the start time and the test name and retrieves the dbid for the test for the test run and for logging at the end
  #   test_name - the name of the test
  def db_log_start(test_name)
    #   time = Time.new
    #   teststarted= "#{time.year}-#{time.month}-#{time.day} #{time.hour}:#{time.min}"
    #   client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation'


    #   newQuery = "insert into results (test_name)
    # values(\"#{test_name}\");"

    #   results = client.execute(newQuery)
    #   results.do
    #   newQuery = "SELECT top 1 id FROM results ORDER BY id DESC;"

    #   results2 = client.execute(newQuery)

    #   id =""
    #   results2.each(:as => :array) do |row|
    #     id= "#{row[0]}"
    #   end

    #   @util.logging("----->Test run Id = #{id}")
    #   @util.logging("View http://dexw5171.hr-applprep.de:8000/specifictest?#{id}")
    #   client.close
    return 1
  end
  # Depricated Function for switching between databases
  def set_dbs
    client = TinyTds::Client.new username: 'username', password: 'password', dataserver: 'dataserver', database: 'database'
    newQuery = "select * from [dbo].[environments] where environment_name='#{@@environment}';"
    results = client.execute(newQuery)
    results.each do |row|

      @@sqlDB_host = row['db_server']
      @@sqlDB_master=""
      @@sqlDB_tenant=""
      @@sqlUser =row['']
      @@sqlPassword =row['']
    end
  end
  # Database query function.  Takes the database variables from the global values (@@sqlUser,etc) performs the query against it.  Returns values as a hash
  #   database - the name of the database to query against
  #   query - The SQL Query to perform
  def tds_query(database,query)
    begin
      error = ""
      #binding.pry
      client = TinyTds::Client.new username: "#{@@sqlUser}", password: "#{@@sqlPassword}", dataserver: "#{@@sqlDB_host}", database: "#{database}" , timeout: 2000
      client.execute('SET TEXTSIZE 2147483647;')
      client.execute('SET ANSI_DEFAULTS ON;')
      client.execute('SET QUOTED_IDENTIFIER ON;')
      client.execute('SET CURSOR_CLOSE_ON_COMMIT OFF;')
      client.execute('SET IMPLICIT_TRANSACTIONS OFF;')
      if @@environment.upcase.include?("UK")  #uk environment needs the dateformat explicity set.  Not needed in the us environments
        client.execute('SET DATEFORMAT DMY')
      end
      client.execute ("SET DEADLOCK_PRIORITY NORMAL;")
      # client.execute('SET CONCAT_NULL_YIELDS_NULL ON;')  don't use
      results = client.execute(query)
      results.count

      return results, error
    rescue TinyTds::Error => error
      @util.logging("The following query failed on #{@@sqlDB_host} #{database} with error \n #{error} \n query = #{query}")
      # binding.pry
      return results,error
    end
  end
  # Depricated.  Azure database query function.  Takes the database variables from the global values (@@sqlUser,etc) performs the query against it.  Returns values as a hash
  #   database - the name of the database to query against
  #   query - The SQL Query to perform
  def tds_query_azure(database,query)
    # client=TinyTds::Client.new(:username=>"Qasqlscript@ami-qa-lzdbserver01", :password=> "Secure#001", :dataserver=> "ami-qa-lzdbserver01.database.windows.net", :port=>1433, :azure=> true, :database=>"AMI-QA-LZDB01")
    #if @@environment=="10.1.15.251"
    # client=TinyTds::Client.new(:username=>"Devsqlscript@AMI-DEV-LZDB01", :password=> "Secure#001", :dataserver=> "AMI-DEV-LZDB01.DATABASE.WINDOWS.NET", :port=>1433, :azure=> true, :database=>"AMI-DEV-LZDB01")
    #puts @@azureuser
    #puts      @@azureHostShort
    #puts      @@azurePassword
    #puts     @@azureHost
    #puts      @azuredb
    #else
    if database =="COLD"
      user = @@azureColduser
      password = @@azureColdpassword
      hostShort =  @@azureColdHostShort
      host= @@azureColdHost
      db = @@azureColddb
    else
      user = @@azureuser
      password = @@azurePassword
      hostShort =  @@azureHostShort
      host= @@azureHost
      db = @@azuredb
    end
    #binding.pry
    client=TinyTds::Client.new(:username=>"#{user}@#{hostShort}", :password=> "#{password}", :dataserver=> "#{host}", :port=>1433, :azure=> true, :database=>"#{db}" , timeout: 600)
    client.execute('SET TEXTSIZE 2147483647;')



    results = client.execute(query)
    if results.affected_rows != 1
      @util.logging ("client.active = #{client.active?}  client.dead = #{client.dead?} ")
    end
    return results
  end
  # Depricated.  Azure database query function.  Takes the database variables from the global values (@@sqlUser,etc) performs the query against it.  Returns values as a hash
  #   database - the name of the database to query against
  #   query - The SQL Query to perform
  def tds_query_azure2(database,query)
    client=TinyTds::Client.new(:username=>"#{@@azureuser}@#{@@azureHostShort}", :password=> "#{@@azurePassword}", :dataserver=> "#{@@azureHost}", :port=>1433, :azure=> true, :database=>"#{database}", timeout: 6000, login_timeout: 600)
    client.execute('SET TEXTSIZE 2147483647;')
    #         @@sqlDB_master="qa-symphony-master"
    #         @@sqlDB_tenant="qa-symphony-tenant"
    #         @@sqlUser ="qaadmin"
    #         @@sqlPassword ="Secret2121$"
    client.execute('SET TEXTSIZE 2147483647;')
    #client.execute ("SET DEADLOCK_PRIORITY NORMAL;")
    #binding.pry
    results = client.execute(query)

    if results.affected_rows != 1
      @util.logging ("client.active = #{client.active?}  client.dead = #{client.dead?} ")
    end
    return results
  end
  # Data cleaner function for cleaning up the logfiles so that they can be put into a varchar(max) field in the database.  Used in teardown
  #   data  the text of the log file
  def data_cleaner(data)
    newData = data.gsub(/\"/,'')
    newData = newData.gsub('\'','')

    newData = newData.gsub(/[\n]/,'<br>')
    return newData
  rescue => msg
    newData ="unable to parse the logfile"

    return newData
  end
  # Depricated.  Azure database query function.  Takes the database variables from the global values (@@sqlUser,etc) performs the query against it.  Returns values as a hash
  #   database - the name of the database to query against
  #   query - The SQL Query to perform
  def tds_query_azure3(database,query)

    user = @@sqlUser
    password = @@sqlPassword
    hostShort =  @@sqlDB_host.gsub(".database.windows.net","")
    host= @@sqlDB_host
    db = database

    client=TinyTds::Client.new(:username=>"#{user}@#{hostShort}", :password=> "#{password}", :dataserver=> "#{host}", :port=>1433, :azure=> true, :database=>"#{db}" , timeout: 600)
    client.execute('SET TEXTSIZE 2147483647;')
    results = client.execute(query)
    if results.affected_rows != 1
      @util.logging ("client.active = #{client.active?}  client.dead = #{client.dead?} ")
    end
    return results
  end
  # Gets the text of a specific element
  #   how- the method of element location
  #   what - the identifier to search for
  #   needs additional work to handle errors
  def get_element_text(how,what,logText)
    element = @driver.find_element(how , what)
    @util.logging("The identifier #{logText}  text is \"#{element.text}\" ---->(element #{how} #{what})")
    element.text
  end
  # Test Tool for debugging.  Highlights the element that is selected
  #   how- the method of element location
  #   what - the identifier to search for
  #   time  how long to highlight the element for
  def highlight how,what, time = 3
    begin
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      element=""
      cb = wait.until {
        element = @driver.find_element(how , what)
        element if element.displayed?
      }
      orig_style = element.attribute("style")
      @driver.execute_script("arguments[0].setAttribute(arguments[1], arguments[2])", element, "style", "border: 2px solid yellow; color: yellow; font-weight: bold;")
      if time > 0
        sleep time
        @driver.execute_script("arguments[0].setAttribute(arguments[1], arguments[2])", element, "style", orig_style)
      end
    rescue
      puts("unable to highlight")
    end
  end
  # Depricated-  Used to break, but not using anymore
  def testingBreak()
    puts ("got to the break")
    if (@util.getUsingEnviro==false)
      @util.logging("At a breakpoint")
      #gets.chomp
      binding.pry
    end
  end
  # For getting the host name if there isn't a dns resolution
  def sockethack
    value ="127.0.0.1"
    machinetest = Socket.gethostname
    value ="Host=#{Socket.gethostname} - #{IPSocket.getaddress(Socket.gethostname)}"
    @@host = machinetest

    return value
  rescue => e
    @util.logging("couldn't get DNS resolution")
  end
  # Gets the current status of the test
  def get_test_fail_status()
    @util.logging("The test case fail is #{@@test_case_fail}")
    if @@test_case_fail_details.length>0
      count =0
      @@test_case_fail_details.each do |row|
        @util.logging(" <font color=\"red\"> failure #{count}</font> -> #{row}")
        count = count +1
      end
    end
  end
  # Depricated gets the utc off set of a remote server from global variables
  def get_utcoffset()
    return @@utcoffsetMin
  end
  # Depricated  Handles uploading a file to a web element
  def upload_handler(pathToFile)
    pathToFile = modify_path(pathToFile)
    if @@brws =="fixme"
      #click_element(:xpath,"//label[@class='qq-upload-button']")
      sleep(1)
      @util.logging("c:\\Desktop\\Scripts\\bin\\ie_send_text.exe param1 \"#{pathToFile}\" 99")

      system "c:\\Desktop\\Scripts\\bin\\ie_send_text.exe param1 \"#{pathToFile}\" 99"
      sleep(20)
      click_element_if_exists(:name,"commit",5)
    else
      elem = @driver.find_element(:xpath,"//input[@type='file']")
      elem.send_keys("#{pathToFile}")
      sleep(1)
      wait = Selenium::WebDriver::Wait.new(:timeout => 30)

      uploading= false
      count = 0
      while uploading ==false && count <30 do
          count +=1
          if !(element_present?(:xpath, "//div[@class='js-uploading']"))
            uploading = true
          else
            element = @driver.find_element(:xpath, "//div[@class='js-uploading']")
            elementstyle = element.attribute("style")
            if elementstyle =="display: none;"
              uploading = true
            end
          end
        end
      end
    end
    # Sets the environment to a specific environment
    def set_environment(enviro)
      @@environment = enviro
    end
    # Sets the browser to a specific browser
    def  set_browser(browser)
      @@brws = browser
    end
    # Sets the qa DB logging
    def turn_off_qa_db_logging()
      @@logToQADatabase =0
    end
    # Retrieves a csv to an array of hashes.
    #   dataFileWithPath takes the csv with the path in string format
    #   returns an array of hashes
    def retrieve_csv_to_array_of_hashes(dataFileWithPath)
      data_file = "#{dataFileWithPath}"
      data = []
      CSV.foreach(data_file, headers: true) do |row|
        data << row.to_hash
      end
      return data
    end
    # Depricated gets the customerName global variable
    def get_customerName
      return @@customerName
    end
    # Depricated sets the customerName global variable
    def set_customerName(newName)
      @@customerName = newName
      return @@customerName
    end
    # Checks if a test has failed  ?duplicate
    def has_test_failed?
      return @@test_case_fail
    end
    # Sets the test_case_fail manually
    #   status Passed or Failed
    def set_has_test_failed(status)
      @@test_case_fail = status
    end
    # Checks if the network location is available, if it is it sets the artifact directory to it, if not it stored is in the local filedir/logs directory
    def set_artifact_dir()
      # if File.directory? "\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs"
      if false #hack to never use the network
        time = Time.new
        justFileFolder =   "#{time.month}_#{time.day}_#{time.year}"
        @util.logging("Found the network directory")
        # unless File.directory? "\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs\\#{justFileFolder}\\"
        #  binding.pry
        #   FileUtils.mkdir_p("\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs\\#{justFileFolder}\\")
        # end
        # @@artifact_dir = "\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs\\#{justFileFolder}\\"
      else
        time = Time.new
        justFileFolder =   "#{time.month}_#{time.day}_#{time.year}"
        @@artifact_dir = @@g_base_dir[(0..@@g_base_dir.rindex('/'))] +justFileFolder

        unless File.directory?  @@artifact_dir
          #   binding.pry
          FileUtils.mkdir_p( @@artifact_dir)
        end
      end

    end
    # Gets the artifact directory
    def get_artifact_dir
      return @@artifact_dir
    end
    # Logs a new artifact into the artifact array
    #   artifactAndPath  takes the artifact name and the path that it exists in
    def log_new_artifact(identifier)
      # @@test_case_fail_artifacts.push("#{artifactandpath}")
      shortArtifactDir = @@artifact_dir.downcase.gsub("c:/automation/logs/","#{@@base_url[0..(@@base_url.length-2)]}:8001\\")
      #shortArtifactDir = @@artifact_dir.gsub("c:/Automation/logs/","#{@@base_url[0..(@@base_url.length-2)]}:8001\\")
      @@test_case_fail_artifacts.push("#{shortArtifactDir}\\#{identifier}")
    end
    # Takes a screenshot and saves the file in the artifact directory.  It then pushes the artifact onto the artifact array for DB/website logging
    #   identifier the name that the snapshot file will have
    def take_snapshot(identifier)
      newArrayStart= @@test_case_fail_artifacts.length
      justFile =@@g_base_dir[(@@g_base_dir.rindex('/')+1)..@@g_base_dir.length]
      @driver.save_screenshot("#{@@artifact_dir}/#{identifier}_#{justFile}_#{newArrayStart}.png")
      #shortArtifactDir = @@artifact_dir.gsub("\\\\hannover-re.grp\\shares\\hlrus_ex\\CDMI_Project\\Testing\\AutomationLogs\\","")

      shortArtifactDir = @@artifact_dir.downcase.gsub("c:/automation/logs/","#{@@base_url[0..(@@base_url.length-2)]}:8001\\")
      #shortArtifactDir = @@artifact_dir.gsub("c:/Automation/logs/","#{@@base_url[0..(@@base_url.length-2)]}:8001\\")

      @@test_case_fail_artifacts.push("#{shortArtifactDir}/#{identifier}_#{justFile}_#{newArrayStart}.png")
      @util.logging("#{identifier} Saved a screenshot at #{@@artifact_dir}/#{identifier}_#{justFile}_#{newArrayStart}.png ")
    end
    # Gets the db_id database id for the specific run of the test from the global value set by the startup tasks.
    def get_db_id
      return  @@db_id
    end
    # Waits a specified amount of time for an alert to come up. Loops through til the time is , looking for the alert to appear.
    #   seconds time to wait for
    def wait_for_alert(seconds)
      for i in 1..5
        begin
          @driver.switch_to.alert
        rescue
          binding.pry
          sleep(1)
          next    # do_something_* again, with the next i
        end
      end
    end
    def check_for_toaster_error_messages
      result = @driver.find_elements(:xpath, "//div[@id = 'toast-container']/div")
      if result.count >= 1
        resulttext = get_element_text(:xpath, "//div[@id = 'toast-container']","Toaster Error modal")
        errorMsg = "Got an error popup with the message '#{resulttext}'"
        check_override(true,errorMsg,false)
      end
    end
    def check_for_expected_toaster_messages
      result = @driver.find_elements(:xpath, "//div[@id = 'toast-container']/div")
      if result.count == 0
        errorMsg = "Did not get an expected toaster message"
        check_override(true,errorMsg,false)
      else
        resulttext = get_element_text(:xpath, "//div[@id = 'toast-container']","Toaster message")
        errorMsg = "Got an toaster popup with the message '#{resulttext}'"

      end

    end
    def check_for_alert
      begin
        alert =  @driver.switch_to.alert
        errorMsg = "Unexpected Alert present! Alert text is \n#{alert.text}"
        alert.accept
        check_override(true,errorMsg,false)
        true
      rescue
        @util.logging("No alert present.")
        return false
      end
    end

  end
