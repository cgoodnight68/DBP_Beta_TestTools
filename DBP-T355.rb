require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T355 < Test::Unit::TestCase
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

  def test_find_links_on_page_dbp
    #@base_url = "https://integration.deliverybizpro.com/admin/login"
    #@util.logging("BaseURL ) \n>")
    @test.goto_url("#{@base_url}/admin/login")
    timingFile=File.open("./logs/#{@base_url.gsub("https://","").gsub("/admin/login","")}.csv","a")

    menuFile = File.read("./MenuElements.csv")

    keys = ['menuItem','path','elementType','base','count','identifier','elementName']
    menuElements = CSV.parse(menuFile).map {|a| Hash[ keys.zip(a) ] }
    #@base_url= gets.chomp


    @driver.manage.window.maximize
    @test.login_to_admin()
  
    counter = 0
    menuElements.each do |menuElement|
      if (counter ==0) || (menuElement['menuItem'] =="") || (menuElement['menuItem'] == nil)
        counter = 1
      else
        startTime = Time.new
        tester= "//#{menuElement['elementType']}[text()=\"#{menuElement['menuItem']}\"]"
        
        found = @test.click_element_from_elements(:xpath,"//#{menuElement['elementType']}[text()=\"#{menuElement['menuItem']}\"]", menuElement['count'], menuElement['menuItem'])
        if (found == true)
        	error_logging(menuElement['menuItem'], startTime,timingFile)

        	error = @test.check_if_element_not_exist(:xpath,"//*[contains(text(),'502 Bad Gateway')]",2,"502 Bad Gateway found after clicking #{menuElement['path']}\">#{menuElement['menuItem']}\"")
        	if error == false
        	    @driver.navigate.back 
        	end
      end
        if (menuElement["menuItem"]== "Organize Load Sheet")

          @test.click_element(:xpath,"//*[@id=\"alert-message-modal\"]/div/div/div[3]/button", "Ok in Modal button")

        end
        if ( menuElement['menuItem']=="Financials Reporting") ||(menuElement['menuItem'] =="Product Reporting") ||(menuElement['menuItem'] =="Customer Reporting") ||(menuElement['menuItem'] =="Misc. Reporting") || (menuElement['menuItem']=="Negative Balances") || (menuElement['menuItem']=="Abandoned Signups") || (found != true) 
          ## do nothing
        else
        #  if (@test.check_if_exist(:xpath,"//input[@value ='Export to Excel']",2))
        #     startTime = Time.new
        #     @test.click_element_if_exists(:xpath,"//input[@value ='Export to Excel']",20)
        #     error_logging("#{menuElement['menuItem']} - Export to Excel",startTime,timingFile)
        #  end
        end
        sleep(1)
      end
    end

    # elName.each do |el|
    #   time = 0
    #   found = 0
    #   if (el=="Show Invalid Addresses")

    #     #  binding.pry
    #   end
    #   if (@test.check_if_exist(:xpath,"//a[text()=\"#{el}\"]",2))
    #     startTime = Time.new
    #     @test.click_element(:xpath,"//a[text()=\"#{el}\"]", el)
    #     error_logging(el, startTime,timingFile)
    #     found = 1
    #   elsif (@test.check_if_exist(:xpath,"//a[text()=\"#{el}\"]",2))
    #     if (el == "Edit/Create Membership Levels")
    #       ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
    #       @util.logging("-->Clicking on #{el} - #{count}\n")
    #       elements = @driver.find_elements(:xpath,"//a[text()=\"#{el}\"]")
    #       startTime = Time.new
    #       elements[count].click

    #       count = count +1
    #       error_logging(el,startTime,timingFile)
    #       found = 1
    #     elsif (el == "No Payment Customers")
    #       ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
    #       @util.logging("-->Clicking on #{el} - #{count2}\n")
    #       elements = @driver.find_elements(:xpath,"//a[text()=\"#{el}\"]")
    #       startTime = Time.new
    #       elements[count2].click

    #       count2 = count2 +1
    #       error_logging(el,startTime,timingFile)
    #       found = 1
    #     elsif (el == "Past Due Customers")
    #       ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
    #       @util.logging("-->Clicking on #{el} - #{count3}\n")
    #       elements = @driver.find_elements(:xpath,"//a[text()=\"#{el}\"]")
    #       startTime = Time.new
    #       elements[count3].click
    #       count3 = count3 +1
    #       error_logging(el,startTime,timingFile)
    #       found = 1
    #     elsif (el == "Inventory")
    #       ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
    #       @util.logging("-->Clicking on #{el} - #{count5}\n")
    #       elements = @driver.find_elements(:xpath,"//a[text()=\"#{el}\"]")
    #       startTime = Time.new
    #       elements[count5].click
    #       count5 = count5 +1
    #       error_logging(el,startTime,timingFile)
    #       elsif (el == "Top Customers")
    #         found = 1
    #     ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
    #     @util.logging("-->Clicking on #{el} - #{count3}\n")
    #     elements = @driver.find_elements(:xpath,"//a[text()=\"#{el}\"]")
    #     startTime = Time.new
    #     elements[count4].click

    #     count4 = count4 +1
    #     error_logging(el,startTime,timingFile)
    #     else
    #       startTime = Time.new
    #       @test.click_element(:xpath,"//span[text()=\"#{el}\"]",el)
    #       error_logging(el, startTime,timingFile)
    #       found = 1
    #     end

    #   elsif (el == "Today's Orders")
    #     ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
    #     @util.logging("-->Clicking on #{el} \n")
    #     startTime = Time.new
    #     @test.click_element(:xpath,"//p[text()=\"#{el}\"]")
    #     error_logging(el,startTime,timingFile)
    #     found = 1
    #   else
    #     print "#{el} doesn't exist as span or link\n"
    #   end

    #   #elements = @driver.find_elements(:xpath,"//span")
    #   sleep(1)
    #   if ( el=="Financials Reporting") ||(el =="Product Reporting") ||(el =="Customer Reporting") ||(el =="Misc. Reporting") || (el=="Negative Balances")
    #     ## do nothing
    #   else
    #     if (@test.check_if_exist(:xpath,"//input[@value ='Export to Excel']",2)) && (found ==1)
    #       startTime = Time.new
    #       @test.click_element(:xpath,"//input[@value ='Export to Excel']")
    #       error_logging("#{el} - Export to Excel",startTime,timingFile)
    #     end
    #   end
    # end

  end

  def error_logging(el,startTime,timingFile)
    begin
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      wait.until {
        @driver.execute_script("return document.readyState;") == "complete"
      }
      endTime = Time.new
      totalTime = (endTime.to_f - startTime.to_f)
      @util.logging ("#{totalTime}  seconds to load page")
      error = @driver.manage.logs.get(:browser)
      timingFile.write("#{el},#{totalTime},#{error}\n")
    rescue Net::ReadTimeout
      # binding.pry
      @util.logging "Net Read time out for #{el}"
      timingFile.write("Net Read time out for#{el},ERROR\n")
      true
    end

    #el = el.gsub("/","")

    # @test.take_snapshot("#{el}")
    #    error = @driver.manage.logs.get(:browser)
    #   @util.logging("Page loaded with the following error\n #{error}")

  end
end
