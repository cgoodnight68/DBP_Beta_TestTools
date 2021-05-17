require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class FindLinksOnPageDBP < Test::Unit::TestCase
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
    print("Enter the base url to check \n>")
    @base_url =  gets.chomp

    print("Do you want to click the Export to Excel on pages where it exists (y/n)  \n>")
    exportExcel =  gets.chomp
    #@base_url = "https://test-4p.deliverybizpro.com/admin/login"
    #@base_url = 'https://4pfoods-vpc.deliverybizpro.com/admin/login'
    #@base_url = "https://4pfoods.deliverybizpro.com/admin/login"
    #@base_url = "https://integration.deliverybizpro.com/admin/login"
    timingFile=File.open("./logs/#{@base_url.gsub("https://","").gsub("/admin/login","")}.csv","a")

    #@base_url= gets.chomp
    @test.goto_url(@base_url)

    @driver.manage.window.maximize
    @test.enter_text(:xpath,"//input[@name='username']","master", "Sign Username")
    @test.enter_text(:xpath,"//input[@name='password']","5vRefGEXMcu9uqpqmkKq", "Password")
    @test.click_element(:xpath,"//div[@class='icheckbox_flat-green']", "Agree to terms")
    @test.click_element(:xpath,"//button[@class='btn secure-login']","Sign in Button")


    #taken out "Show Currently Owed"
    elName = ["Dashboard","Customers","Search for Customers","Create Customer Profile","Import Customers","Export Customers","Export Customer Emails","Edit\/Create Membership Levels","Customer Notes","Administrators","Search for Admins","Create Admin Profile","Access Control","Edit/Create Membership Levels","Drivers","Search for Drivers","Create Driver Profile","Edit/Create Membership Levels","Suppliers","Search for Suppliers","Create Supplier Profile","Edit/Search Products","Add New Product","Import products","Export products","Product Categories","Extra fields","Warehouse Locations","Localness Icons","Change/Assign Routes","Create/Edit Routes","GPS Import/Export","Organize Route Stops","Pickup Locations","Organize Pickup Locations","Manage KML File","Display Route/KML Issues","Organize Load Sheet","Print Route Sheets","Print Bag Labels","Show Invalid Addresses","Billing","Paper/Email Billing","Electronic Billing","Mass Update Payments","Mass Deposit Returns/Charges","Global Invoice Notes","View GC Purchase Log","Sales Reporting","Top Customers","Countdown Sales Report","Cross-Selling Report","Discount Coupon Report","Manage Cross-Selling","Ordered Products Reports","Overall Sales","Sales By Route","Financials Reporting","Average Order Report","Credits Report","Effective Margin Report","Financials Export","No Payment Customers","Payments On Review","Payments Posted Report","Profit Report","Recent Payments Report","Taxes Report","Product Reporting","Bagged Items Report","Customized Products","Forecast","Inventory","Product Reporting","Load Sheet Report","Out Of Stock Report","Customer Reporting","Top Customers","Customer Reporting","Customer Count Report","Deposit Report","Followup Report","Friend Referral Report","Minimum Order Report","Negative Balances","New Customers","No Order Customers Report","No Payment Customers","Customer Reporting","On Hold Report","Past Due Customers","Customer Reporting","Recurring Order Report","Retention Report","Show Inactive Customers","Total Customers Report","Vacation Report","Misc\. Reporting","Birthday Report","Contact Us Report","Coupon Usage","Missing Orders","Coupons","Coupon Events","Countdown Products","Global Discounts","Featured Products","Sale Items","Manage Cross-Selling","First Time Order Specials","Search Orders", "Today\'s Orders","This Week\'s Orders","Next Week\'s Orders","Create Purchase Order","View Purchase Orders","Autoresponders","General News List","Unsubscribers","Manage Files","301 Redirects","Company Settings","States/Counties","Taxes","Taxing Zones","Taxing System","Minimum Orders Settings","Zip Codes","Fees","Delivery Charges","Deposit Charges","Registration Fees","Settings","Store Locations","DBP Settings","DBP Billing","Countries","States","Settings","Export/Import Cities","Summary","Credit card types","Languages","Modules","Payment Methods","Clear templates cache","System Logs","DBP Overview","Inventory","Tasks","Periodic tasks"]
    count = 0
    count2 = 0
    count3 = 1
    count4 = 0
    count5 = 0
    elName.each do |el|
      time = 0
      sleep(5)
      if (el=="Cross-Selling Report") || (el=="Financials Export")
binding.pry
          sleep(60)
      end
    
      if (@test.check_if_exist(:xpath,"//span[text()=\"#{el}\"]",2))
        startTime = Time.new
        @test.click_element(:xpath,"//span[text()=\"#{el}\"]", el)
        error_logging(el, startTime,timingFile)
      elsif (@test.check_if_exist(:xpath,"//a[text()=\"#{el}\"]",2))
        if (el == "Edit/Create Membership Levels")
          ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
          @util.logging("-->Clicking on #{el} - #{count}\n")
          elements = @driver.find_elements(:xpath,"//a[text()=\"#{el}\"]")
          startTime = Time.new
          elements[count].click

          count = count +1
          error_logging(el,startTime,timingFile)
        elsif (el == "No Payment Customers")
          ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
          @util.logging("-->Clicking on #{el} - #{count2}\n")
          elements = @driver.find_elements(:xpath,"//a[text()=\"#{el}\"]")
          startTime = Time.new
          elements[count2].click

          count2 = count2 +1
          error_logging(el,startTime,timingFile)
        elsif (el == "Past Due Customers")
          ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
          @util.logging("-->Clicking on #{el} - #{count3}\n")
          elements = @driver.find_elements(:xpath,"//a[text()=\"#{el}\"]")
          startTime = Time.new
          elements[count3].click
          count3 = count3 +1
          error_logging(el,startTime,timingFile)
        elsif (el == "Inventory")
          ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
          @util.logging("-->Clicking on #{el} - #{count5}\n")
          elements = @driver.find_elements(:xpath,"//a[text()=\"#{el}\"]")
          startTime = Time.new
          elements[count5].click
          count5 = count5 +1
          error_logging(el,startTime,timingFile)
        else
          startTime = Time.new
          @test.click_element(:xpath,"//a[text()=\"#{el}\"]",el)
          error_logging(el, startTime,timingFile)
        end
      elsif (el == "Top Customers")
        ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
        @util.logging("-->Clicking on #{el} - #{count3}\n")
        elements = @driver.find_elements(:xpath,"//p[text()=\"#{el}\"]")
        startTime = Time.new
        elements[count4].click

        count4 = count4 +1
        error_logging(el,startTime,timingFile)
      elsif (el == "Today's Orders")
        ## @test.click_element(:xpath,"//a[contains(text(),\"#{el}\")][#{count}]")
        @util.logging("-->Clicking on #{el} \n")
        startTime = Time.new
        @test.click_element(:xpath,"//p[text()=\"#{el}\"]")
        error_logging(el,startTime,timingFile)
      else
        print "#{el} doesn't exist as span or link\n"
      end
      if (el == "Organize Load Sheet")
        #binding.pry
        @test.click_element(:xpath,"//button[@class='btn primary modal-ok']","Ok button")
      end
      #elements = @driver.find_elements(:xpath,"//span")
      sleep(1)
      if ( el=="Financials Reporting") ||(el =="Product Reporting") ||(el =="Customer Reporting") ||(el =="Misc. Reporting") || (el=="Negative Balances") || (el == "Countdown Sales Report ")
        ## do nothing
      else
        if (@test.check_if_exist(:xpath,"//input[@value ='Export to Excel']",2)) && ( exportExcel == "y")
          startTime = Time.new
          @test.click_element(:xpath,"//input[@value ='Export to Excel']")
          error_logging("#{el} - Export to Excel",startTime,timingFile)
        end
      end
    end

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
