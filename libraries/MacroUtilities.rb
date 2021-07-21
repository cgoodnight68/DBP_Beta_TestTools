class Utilities;
  @navigationHash = Hash.new
  def load_admin_navigation_elements
    begin
      client = PG::Connection.open(:dbname => 'WebElements_pg_development', :host => '54.201.168.175', :user => 'postgres', :password =>'getswift' )
      environment = @base_url[8..(@base_url.index('.')-1)].downcase

      newQuery = "select * from dbpelements where environment ='integration' "
      results = client.exec(newQuery)


      @navigationHash = Array.new
      results.each do |lines|
        @navigationHash.push(lines)
      end

      if environment != "integration"
        replacementsQuery = "select * from dbpelements where environment = '#{environment}'"
        results2 = client.exec(replacementsQuery)

        results2.each do |lines|
          navigationItem = @navigationHash.select {|navigate| (navigate["element_name"] == lines["element_name"]) && navigate["element_path"] == lines["element_path"] }
          navigationItem[0].replace(lines)
        end
      end
      client.close
      # Uncomment this and comment above to run from a .csv file
      # menuFile = File.read("./MenuElements.csv")
      # keys = ['menu_item','element_path','element_type','base','count','element_selector','element_identifier','element_name','environment']
      # navigationHash = CSV.parse(menuFile).map {|a| Hash[ keys.zip(a) ] }
      # @navigationHash = navigationHash

    rescue
      @util.errorlogging("There is a failure in loading the navigation elements: ")
      throw("There is a failure loading the navigation elements")
    end
  end

  def admin_navigate_to(menu_item)
    begin
      navigationItem = @navigationHash.select {|navigate| navigate["menu_item"] == "#{menu_item}"}
      precursors = navigationItem[0]["element_path"].split(">")
      if (precursors.count >1)
        precursors.count.downto(2){ |i|  admin_navigate_to(precursors[i-1]) }
      end
      ## add check here to see if the element is already expanded....
      click_element_from_elements(:xpath,"//#{navigationItem[0]['element_type']}[text()=\"#{navigationItem[0]['menu_item']}\"]", navigationItem[0]['count'], navigationItem[0]['menu_item'])
    rescue =>e
      @util.errorlogging("Unable to navigate to #{menu_item} Error:#{e} ")
      throw ("Unable to navigate to #{menu_item} Error:#{e}")
    end

  end

  def login_to_admin
    goto_url("#{@base_url}/admin/login")
    enter_text(:xpath,"//input[@name='username']","master", "Sign Username")
    element = @driver.find_element(:xpath,"//input[@name='password']")
    # if @base_url.include?"integration"
    #    element.send_keys("WpxarUxg1X27nm290V6h")
    #  else
    #   element.send_keys("9OA33ULvSJDC12Kg7crJ")
    #  end

    element.send_keys("WpxarUxg1X27nm290V6h")

    #element.send_keys("FycAq8Sg5V2ov956mXD4")
    #element.send_keys("6a4GhvF3k@XwYMLCXFbad@v3")
    click_element_ignore_failure(:xpath,"//div[@class='icheckbox_flat-green']", "Agree to terms")
    click_element(:xpath,"//button[@class='btn secure-login']","Sign in Button")

    sleep(1)
    url = get_url()
    @util.logging("URL is #{url}")
    if (url.include?("admin/home.php"))
      @util.logging("Master is logged in")
    else
      @util.errorlogging("Master is not logged in")
      throw ("Master is not logged in")
      false
    end
  end
  def get_date(dateOffset)
    time = (Time.now - dateOffset*24*60*60)
    date = "#{time.month}_#{time.day}_#{time.year}"
    return date
  end

  def get_date_full()
    date =  Time.now.strftime("%m_%d_%Y")
    return date
  end
  def get_date_full_mmddyyyy()
    date =  Time.now.strftime("%m%d%Y")
    return date
  end

  def get_date_reversed()
    date =  Time.now.strftime("%Y_%m_%d")
    return date
  end

  def get_date_x_days_ago(days)
    date = (Time.now - days*24*60*60)
    date = date.strftime("%m/%d/%Y")
    return date
  end

  def get_date_dayname_dd_abr_mo_yyyy(dateOffset)
    time = (Time.now - dateOffset*24*60*60)
    date=time.strftime("%a, %d %b %Y")
    return date
  end
  def get_valid_customer_address
    street= ""
    city =""
    zipcode= ""
    state = ""
    while street ==""
      results = run_automation_db_query("select cust.s_address,cust.s_city,cust.s_zipcode from dbp_customers as cust, dbp_orders as orders  where cust.s_address is not null  and cust.s_city is not null and cust.s_zipcode is not null and cust.usertype = 'C' and cust.login != 'master'  and cust.user_active ='Y' and orders.login = cust.login and orders.status='P' order by rand() limit 1")
      results.each do |row|
        street= row["s_address"]
        city =row["s_city"]
        zipcode = row["s_zipcode"]
        state = row["s_state"]
      end
    end
    return "#{street} #{city},#{state} #{zipcode}"
  end


  def create_default_customer_for_the_day
    begin
      date = get_date(0)
      count = ""
      results = run_automation_db_query("select count(*) from dbp_customers")
  
      results.each do |row|
        count = row["count"]
      end
      street= ""
      city =""
      zipcode= ""
      while street ==""
        results = run_automation_db_query("select cust.s_address,cust.s_city,cust.s_zipcode from dbp_customers as cust, dbp_orders as orders  where cust.s_address is not null  and cust.s_city is not null and cust.s_zipcode is not null and cust.usertype = 'C' and cust.login != 'master'  and cust.user_active ='Y' and orders.login = cust.login and orders.status in ('P','C') order by rand() limit 1")
        results.each do |row|
          street= row["s_address"]
          city =row["s_city"]
          zipcode = row["s_zipcode"]
        end
      end
      enter_text("FirstName","User Management>Customers>Create Customer Profile", "#{date}_Default", "First Name")
      enter_text("LastName","User Management>Customers>Create Customer Profile", "Cust","Last Name")
      #binding.pry
      birthdayCheck = check_if_element_exists("Birthday","User Management>Customers>Create Customer Profile",10,"Birthday","warn")
      if birthdayCheck != "warn"
        enter_text("Birthday","User Management>Customers>Create Customer Profile","#{date}")
      end

      enter_text("Email","User Management>Customers>Create Customer Profile", "#{date}_Default_Cust@mailinator.com","Email")
      enter_text("Email2","User Management>Customers>Create Customer Profile", "#{date}_Default_Cust@mailinator.com","Confirm Email")
      phoneProviderCheck = check_if_element_exists("Phone Provider selector","User Management>Customers>Create Customer Profile",5,"Phone provider","warn")
      if phoneProviderCheck != "warn"

        click_element("Phone Provider selector","User Management>Customers>Create Customer Profile","Phone Provider selector")
        enter_text("Phone Provider","User Management>Customers>Create Customer Profile", "AT&T\n\t ","Phone Provider and Accept SMS")
      end

      enter_text("Delivery Address","User Management>Customers>Create Customer Profile", "#{street}","Delivery Address")

      enter_text("Delivery City","User Management>Customers>Create Customer Profile", "#{city}","Delivery City")
      enter_text("Zipcode","User Management>Customers>Create Customer Profile", "#{zipcode}","Delivery Zipcode")
      countryCheck = check_if_element_exists("County Selector","User Management>Customers>Create Customer Profile",10,"County Selector","warn")
      if countryCheck != "warn"
        click_element("County Selector","User Management>Customers>Create Customer Profile","County Selector")
        @driver.action.send_keys("\ue015\ue015\ue007").perform #big hack. just sending down down and enter
      end
      click_element_if_exists("Billing Address is the same checkbox","User Management>Customers>Create Customer Profile",10,"Billing Address is the same checkbox")

      enter_text("Phone","User Management>Customers>Create Customer Profile", "6122326519","Phone")
      creditCardMobile = check_if_element_exists("CreditCardDetailModal","User Management>Customers>Create Customer Profile",10,"Credit Card Detail Modal Button","warn")
      if creditCardMobile != "warn"

        click_element("CreditCardDetailModal","User Management>Customers>Create Customer Profile","Credit Card Detail Modal Button")
        credit_card_modal_entry()
        ## sends enter to the modal ok confirmation
      elsif (check_if_element_exists(:xpath,"//iframe",10,"Payment method selector","warn") != "warn")
        credit_card_modal_entry()

      else

        enter_text("Card Number","User Management>Customers>Create Customer Profile", "4111111111111111","Credit Card")
        enter_text("Name On Card","User Management>Customers>Create Customer Profile", "#{date}_Default_Cust","Name On card")
        enter_text("Card expire month","User Management>Customers>Create Customer Profile", "0826","Expire Month")
        enter_text("Card CCV","User Management>Customers>Create Customer Profile", "123","Card CCV")
      end
      enter_text("Password","User Management>Customers>Create Customer Profile", "getswift","Password")
      enter_text("Confirm Password","User Management>Customers>Create Customer Profile", "getswift","Confirm Password")

      ### extra customer specific elements below
      if (check_if_element_exists("NDIS participant","User Management>Customers>Create Customer Profile",10,"Are you an NDIS participant","warn") != "warn")
        click_element_ignore_failure("NDIS participant","User Management>Customers>Create Customer Profile","Are you an NDIS participant")
        @driver.action.send_keys("\ue015\ue015\ue007").perform #big hack. just sending down down and enter
      end



      ######

      click_element("Save","User Management>Customers>Create Customer Profile","Save button")

      sleep(20)

      wait_for_element("Profile sucessfully created","User Management>Customers>Create Customer Profile","Verifying profile sucessfully created",180)
      check_if_element_exists_get_element_text("Profile sucessfully created","User Management>Customers>Create Customer Profile",60,"Verifying profile sucessfully created")
    rescue =>e
      @util.errorlogging("Unable to create user for the day: Error:#{e} ")
      throw ("Unable to create user for the day: Error:#{e}")
    end
  end

  def credit_card_modal_entry()
    begin

      date = get_date(0)
      frame = @driver.find_element(:xpath,"//iframe")
      @util.logging("switching to frame class:#{frame['class']} name:#{frame['name']} id:#{frame['id']}")
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
      if frameLocator.include?('__privateStripeFrame')
        frameLocator = "__privateStripeFrame"
      end

      @driver.switch_to.frame( @driver.find_element(:xpath,"//iframe"))

      case frameLocator
      when "stripe_checkout_app"
        enter_text(:xpath,"//label[contains(text(),'Email')]/../input","#{date}_Default_Cust@mailinator.com","Stripe email input")
        enter_text(:xpath,"//label[contains(text(),'Card number')]/../input","4111111111111111","Stripe card number")
        enter_text(:xpath,"//label[contains(text(),'Expiry')]/../input","0826","Stripe card exipration")
        enter_text(:xpath,"//label[contains(text(),'CVC')]/../input","123","Stripe card CVC")
        click_element(:xpath,"//button[@type='submit']","Submit on Modal")
        sleep(5)
        click_element("Ok On Credit Card Saved Modal","User Management>Customers>Create Customer Profile","Submit on Modal")

      when 'nmiFrame'
        enter_text("Card Number on Modal","User Management>Customers>Create Customer Profile", "4111111111111111","Credit Card on Modal")
        enter_text("Expiration date on Modal","User Management>Customers>Create Customer Profile", "0826","Expiration date on Modal")
        enter_text("CVV2 on Modal","User Management>Customers>Create Customer Profile", "123","Card CCV on Modal")
        click_element("Submit on Modal","User Management>Customers>Create Customer Profile","Submit on Modal")
        @driver.switch_to.default_content
        @driver.action.send_keys("\t\t\n").perform

      when 'monerisFrame'
        enter_text(:xpath,"//input[@name='cardnumber']","4111111111111111","Moneris card number")
        enter_text(:xpath,"//input[@name='exp-date']","0826","Moneris card exipration")
        enter_text(:xpath,"//input[@name='cvc']","123","Monaris card CVC")
        @driver.switch_to.default_content
        click_element(:xpath,"//button[@id='monerisSubmitButton']","Monaris Save Card")
      when '__privateStripeFrame'
        enter_text("Credit Card alt1","User Management>Customers>Create Customer Profile", "4111111111111111\t","Credit Card alt1")

        sleep(1)
        @driver.action.send_keys("08//26").perform
        sleep(1)
        @driver.action.send_keys("123").perform
        #this is a major hack above, because selenium will not find the elements below to enter text in them.
        #enter_text("Expiration Date alt1","User Management>Customers>Create Customer Profile", "0826","Expiration Date ")
        #enter_text("CVC alt1","User Management>Customers>Create Customer Profile", "123","Card CCV")

        @driver.switch_to.default_content
      else
        binding.pry
        #unknown frame
      end
    rescue =>e
      @util.errorlogging("Unable to do enter credit card detail: Error:#{e} ")
      throw ("Unable to do enter credit card detail: Error:#{e}")
    end

  end


  def get_element_from_navigation(element_name,element_path)

    navigationItem = @navigationHash.select {|navigate| (navigate["element_name"] == "#{element_name}") && navigate["element_path"] =="#{element_path}" }

    if navigationItem.count ==0
      @util.errorlogging("element_name: #{element_name} at element_path : #{element_path} not found")
      throw ("Unable to locate #{element_name} #{element_path} in the loaded navigation hash")
    end
    return navigationItem[0]["element_identifier"]

  end
  def get_element_from_navigation2(element_name,element_path)

    navigationItem = @navigationHash.select {|navigate| (navigate["element_name"] == "#{element_name}") && navigate["element_path"] =="#{element_path}" }

    if navigationItem.count ==0
      @util.errorlogging("element_name: #{element_name} at element_path : #{element_path} not found")
      throw ("Unable to locate #{element_name} #{element_path} in the loaded navigation hash")

    end
    return navigationItem[0]["element_selector"].gsub(':',"").to_sym,navigationItem[0]["element_identifier"]

  end

  def create_new_user_customer_side
    begin
      goto_url("#{@base_url}/register.php?step=first&viewing_step=first")

      date = get_date(0)

      street= ""
      city =""
      zipcode= ""
      while street ==""
        results = run_automation_db_query("select s_address,s_city,s_zipcode from dbp_customers  where s_address is not null  and s_city is not null and s_zipcode is not null order by rand() limit 1")
        results.each do |row|
          street= row["s_address"]
          city =row["s_city"]
          zipcode = row["s_zipcode"]
        end
      end
      randadressid = rand(100)
      enter_text("Address","UserApp>Register", "#{street} #{city} \n\n","Address")

      wait_for_element("Continue from delivery confirmation","UserApp>Register","Continue from Delivery Confirmation",120)
      sleep(5)
      click_element_if_exists("Continue from delivery confirmation","UserApp>Register",10)
      sleep(10)

      click_element_if_exists("Continue","UserApp>Register",10,"Continue on Register")
      click_element_if_exists("Continue from delivery confirmation","UserApp>Register",10,"Continue on Delivery Confirmation")

      enter_text("FirstName","UserApp>Register", "#{date}_Default_Cust", "First Name")
      enter_text("LastName","UserApp>Register", "#{randadressid}","Last Name")
      enter_text("E-Mail Address","UserApp>Register", "#{date}_Default_Cust_#{randadressid}@mailinator.com","Email")

      confirmEmailCheck = check_if_element_exists("Confirm Email","UserApp>Register",5,"Confirm Email field", "warn")
      if confirmEmailCheck != "warn"
        enter_text("Confirm Email","UserApp>Register", "#{date}_Default_Cust_#{randadressid}@mailinator.com","Email")
      end

      enter_text("Phone","UserApp>Register", "6122326519","Phone")
      enter_text("Password","UserApp>Register", "getswift","Password")
      click_element("Continue","UserApp>Register","Continue")
      if (check_if_element_exists("Display Credit Card Entry modal","UserApp>Register",5,"Display Credit Card Modal","warn") != "warn")
        click_element("Display Credit Card Entry modal","UserApp>Register","User Display Credit card modal")

        @driver.switch_to.frame('nmiFrame')
        enter_text("Card Number on Modal","UserApp>Register", "4111111111111111","Card Number on Modal")
        enter_text("Card expire month on Modal","UserApp>Register","0826","Card expire month on Modal")
        enter_text("Card CCV on Modal","UserApp>Register","123","Card CCV on Modal")
        click_element("Submit on Modal","UserApp>Register","Submit")
        sleep(3)

        @driver.switch_to.default_content
        @driver.action.send_keys("\t\t\n").perform  ## sends enter to the modal ok confirmation


      else
        enter_text("Card Number","UserApp>Register", "4111111111111111","Card Number")
        enter_text("Name On Card","UserApp>Register","#{date}_Default_Cust","Name On Card")
        enter_text("Card expire month","UserApp>Register","0826","Card expire month")
        enter_text("Card CCV","UserApp>Register","123","Card CCV")
      end

      phoneProviderCheck = check_if_element_exists("Phone Provider Drop Down","UserApp>Register",5)

      if phoneProviderCheck != false

        click_element("Phone Provider Drop Down","UserApp>Register","Phone Provider selector")
        click_element("Phone Provider Sprint","UserApp>Register","Phone Provider Sprint")
      end
      click_element("Finish Registration","UserApp>Register","Finish Registration")
    rescue =>e
      @util.errorlogging("Unable to create user from the app side: Error:#{e} ")
      throw ("Unable to create user from the app side: Error:#{e}")
    end
  end

  def login_as_customer(user,password)
    goto_url("#{@base_url}/login")
    enter_text("Username","UserApp>Login",user,"Username")
    enter_text("Password","UserApp>Login",password,"Password")
    click_element("Login Button","UserApp>Login","Login Button")
    sleep(1)
    url = get_url()
    @util.logging("URL is #{url}")

    url = get_url()
    @util.logging("URL is #{url}")
    if (url.include?("summary.php"))
      @util.logging("User: #{user} is logged in")
    else
      @util.errorlogging("User: #{user} is not logged in")
      throw ("User is not logged in")
      false
    end
  end

  def get_default_user_for_day
    time = Time.new
    date = "#{time.month}_#{time.day}_#{time.year}"
    username = "#{date}_Default_Cust@mailinator.com"
    password= "getswift"
    return username,password
  end

  def select_random_item_from_shop_page(quantity,frequency)
    begin
      click_element_if_exists(:xpath,"//*[@id='alert-message-modal']/div/div/div[3]/button",10,"Find any open modal close it when loging to User App")
      returnValue = false
      cartElementsBefore = @driver.find_elements(:xpath ,"//div[@class='table-cell product_name']/div/a/span")

      @util.logging("There are #{cartElementsBefore.count} item(s) in the cart before adding a new item")

      elements = @driver.find_elements(:xpath ,"//div[@class='product-wrapper']/..")
      if (elements.count>0)
        productWrapperToClick = rand(elements.count.to_i) - 1

        productId = elements[productWrapperToClick].attribute("data-productid")


        productDescription = elements[productWrapperToClick].find_elements(:xpath,"//div[@class ='product-labeling ']/div/h2")

        @util.logging("-->Clicking on product number #{productId}  Description: <br><font color =\"blue\"> #{productDescription[productWrapperToClick].text} </font>")
        returnValue = productDescription[productWrapperToClick].text
        #binding.pry

        sleep(5)
        click_element_from_elements(:xpath,"//label[contains(text(),'Frequency')]/span",productWrapperToClick)

        # productFrequency = elements[productWrapperToClick].find_elements(:xpath,"//label[contains(text(),'Frequency')]/span")
        # productFrequency[productWrapperToClick].click
        found = click_element_if_exists(:xpath,"//li[contains(text(),'#{frequency}')]",10,"Clicking the Frequency of #{frequency}")
        if found == true
          found = click_element_if_exists(:xpath,"//li[contains(text(),'#{frequency}')]",10,"Clicking the Frequency of #{frequency}")
        end

        if (frequency == "Weekly") && (found == false)
          altFrequency = "Every Week"
          click_element_if_exists(:xpath,"//li[contains(text(),'#{altFrequency}')]",10,"Clicking the Frequency of #{altFrequency}")
          click_element_if_exists(:xpath,"//li[contains(text(),'#{altFrequency}')]",10,"Clicking the Frequency of #{altFrequency}")
        end
        # newElements = @driver.find_elements(:xpath,"//li[contains(text(),'#{frequency}')]")
        # if newElements.count >0
        #   newElements[0].click
        #   @util.logging("Setting Frequency #{productDescription[productWrapperToClick].text} to #{frequency}")
        # end
        #addToCart =elements[productWrapperToClick].find_elements(:xpath,"//a[@class='button-add-to-cart add']")
        # addToCart[productWrapperToClick].click



        click_element(:xpath,"//a[@id='button-add-to-cart-#{productId}']", "Add to Delivery Button for product no. #{productId}")
        productStartDelivery = elements[0].find_elements(:xpath,"//div[@class ='product-overlay']")
        if (productStartDelivery[productWrapperToClick].text != "")
          @util.logging("Delivery options <br><font color =\"blue\">#{productStartDelivery[productWrapperToClick].text}</font>")
          productStartDeliveryOK = elements[0].find_elements(:xpath,"//div[@class ='overlay-buttons']/div[2]")
          productStartDeliveryOK[productWrapperToClick].click
        end
        sleep(5)

        cartElementsAfter = @driver.find_elements(:xpath ,"//div[@class='table-cell product_name']/div/a/span")
        if cartElementsAfter.count > cartElementsBefore.count
          @util.logging("There are #{cartElementsAfter.count} item(s) in the cart after adding #{returnValue}")
        else
          @util.errorLogging("There are #{cartElementsAfter.count} item(s) in the cart after attempting to add #{returnValue}. Which is the same as before #{cartElementsBefore.count}")
         throw("There are #{cartElementsAfter.count} item(s) in the cart after attempting to add #{returnValue}. Which is the same as before #{cartElementsCount.count}")
       end
        click_element_if_exists("OK button","UserApp>ImportantInformationModal",20,"OK button for add to cart confirmation")
        return returnValue
      end

    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.errorlogging "No such element to click. #{error.message}"
      throw ("No such element to click. #{error.message}")
    rescue Selenium::WebDriver::Error::UnknownError
      @util.errorlogging "Unknown error. #{error.message}"
      throw ("Unknown error. #{error.message}")

    rescue Net::ReadTimeout
      # binding.pry
      @util.errorlogging "Net Read timeout failure #{error.message} "
      throw ("Net Read timeout failure #{error.message} ")
    rescue Selenium::WebDriver::Error::ElementClickInterceptedError
      @util.errorlogging "--> Element  was displayed but click would be intercepted #{error.message}"
      throw("--> Element  was displayed but click would be intercepted #{error.message}")
    rescue =>e
      @util.errorlogging("Unknown error in select random item Error:#{e} ")
      throw ("Unknown error in select random item Error:#{e}")
    end

  end
  def select_random_item_from_shop_page_select_delivery_enter_address(address)
    begin
      click_element_if_exists(:xpath,"//*[@id='alert-message-modal']/div/div/div[3]/button",10,"Find any open modal close it when loging to User App")
      elements = @driver.find_elements(:xpath ,"//div[@class='product-wrapper']/..")
      if (elements.count>0)
        productWrapperToClick = rand(elements.count.to_i) - 1

        productId = elements[productWrapperToClick].attribute("data-productid")


        productDescription = elements[productWrapperToClick].find_elements(:xpath,"//div[@class ='product-labeling ']")
        @util.logging("-->Clicking on product number #{productId}  Description: <br><font color =\"blue\"> #{productDescription[productWrapperToClick].text} </font>")
        sleep(5)
        click_element(:xpath,"//a[@id='button-add-to-cart-#{productId}']", "Add to Delivery Button for product no. #{productId}")
        click_element(:xpath,"//div[@data-productid = '#{productId}']/div/div/div/div[1]/div[1]/div/div[1]/b/span[1]","Delivery")
        enter_text(:xpath,"//div[@data-productid = '#{productId}']/div/div/div/div[1]/div[1]/div/div[2]/input",address,"Entering #{address} into the 'Please enter your delivery address input")

      end

    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.errorlogging "No such element to click. #{error.message}"
      throw ("No such element to click. #{error.message}")
    rescue Selenium::WebDriver::Error::UnknownError
      @util.errorlogging "Unknown error. #{error.message}"
      throw ("Unknown error. #{error.message}")

    rescue Net::ReadTimeout
      # binding.pry
      @util.errorlogging "Net Read timeout failure #{error.message} "
      throw ("Net Read timeout failure #{error.message} ")
    rescue Selenium::WebDriver::Error::ElementClickInterceptedError
      @util.errorlogging "--> Element  was displayed but click would be intercepted #{error.message}"
      throw("--> Element  was displayed but click would be intercepted #{error.message}")
    rescue =>e
      @util.errorlogging("Unknown error in select random item Error:#{e} ")
      throw ("Unknown error in select random item Error:#{e}")
    end

  end

  def select_specific_item_from_shop_page(productName,quantity,frequency)
    begin
      click_element_if_exists(:xpath,"//*[@id='alert-message-modal']/div/div/div[3]/button",10,"Check if any modal is open and click on it at login")
      elements = @driver.find_elements(:xpath ,"//div[@class='product-wrapper']/..")
      productWrapperToClick =0
      if (elements.count>0)
        elementCounter= 0
        elements.each do |element|
          if element.text.include?(productName)
            productWrapperToClick = elementCounter
          end
          elementCounter = elementCounter +1
        end

        productId = elements[productWrapperToClick].attribute("data-productid")


        productDescription = elements[productWrapperToClick].find_elements(:xpath,"//div[@class ='product-labeling ']")
        @util.logging("-->Clicking on product number #{productId}  Description: <br><font color =\"blue\"> #{productDescription[productWrapperToClick].text} </font>")

        click_element_from_elements(:xpath,"//label[contains(text(),'Frequency')]/span",productWrapperToClick)

        # productFrequency = elements[productWrapperToClick].find_elements(:xpath,"//label[contains(text(),'Frequency')]/span")
        # productFrequency[productWrapperToClick].click
        found = click_element_if_exists(:xpath,"//li[contains(text(),'#{frequency}')]",10,"Clicking the Frequency of #{frequency}")

        if (frequency == "Weekly") && (found == false)
          altFrequency = "Every Week"
          click_element_if_exists(:xpath,"//li[contains(text(),'#{altFrequency}')]",10,"Clicking the Frequency of #{altFrequency}")
        end
        # newElements = @driver.find_elements(:xpath,"//li[contains(text(),'#{frequency}')]")
        # if newElements.count >0
        #   newElements[0].click
        #   @util.logging("Setting Frequency #{productDescription[productWrapperToClick].text} to #{frequency}")
        # end
        #addToCart =elements[productWrapperToClick].find_elements(:xpath,"//a[@class='button-add-to-cart add']")
        # addToCart[productWrapperToClick].click
        sleep(5)

        click_element(:xpath,"//a[@id='button-add-to-cart-#{productId}']", "Add to Delivery Button for product no. #{productId}")
        productStartDelivery = elements[0].find_elements(:xpath,"//div[@class ='product-overlay']")
        if (productStartDelivery[productWrapperToClick].text != "")
          @util.logging("Delivery options <br><font color =\"blue\">#{productStartDelivery[productWrapperToClick].text}</font>")
          productStartDeliveryOK = elements[0].find_elements(:xpath,"//div[@class ='overlay-buttons']/div[2]")
          productStartDeliveryOK[productWrapperToClick].click
        end
        sleep(5)
        click_element_if_exists("OK button","UserApp>ImportantInformationModal",20,"OK button for add to cart confirmation")
        #binding.pry
        @driver.navigate().refresh();

      end

    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.errorlogging "No such element to click. #{error.message}"
      throw ("No such element to click. #{error.message}")
    rescue Selenium::WebDriver::Error::UnknownError
      @util.errorlogging "Unknown error. #{error.message}"
      throw ("Unknown error. #{error.message}")

    rescue Net::ReadTimeout
      # binding.pry
      @util.errorlogging "Net Read timeout failure #{error.message} "
      throw ("Net Read timeout failure #{error.message} ")
    rescue Selenium::WebDriver::Error::ElementClickInterceptedError
      @util.errorlogging "--> Element  was displayed but click would be intercepted #{error.message}"
      throw("--> Element  was displayed but click would be intercepted #{error.message}")
    rescue =>e
      @util.errorlogging("Unable to select product Error:#{e} ")
      throw ("Unable to select product Error:#{e}")
    end
  end

  def verify_items_are_on_shop_page()
    begin
      click_element_if_exists(:xpath,"//*[@id='alert-message-modal']/div/div/div[3]/button",10,"Find any open modal close it when loging to User App")
      elements = @driver.find_elements(:xpath ,"//div[@class='product-wrapper']/..")
      if (elements.count>0)
        @util.logging("There are #{elements.count} products on the page")
        for productWrapperToClick in 0..(elements.count-1)
          productId = elements[productWrapperToClick].attribute("data-productid")
          productDescription = elements[productWrapperToClick].find_elements(:xpath,"//div[@class ='product-labeling ']")
          @util.logging("-->Found product number #{productId}  Description: <br><font color =\"blue\"> #{productDescription[productWrapperToClick].text} </font>")
        end

      end

    rescue Selenium::WebDriver::Error::NoSuchElementError
      @util.errorlogging "No such element to click. #{error.message}"
      throw ("No such element to click. #{error.message}")
    rescue Selenium::WebDriver::Error::UnknownError
      @util.errorlogging "Unknown error. #{error.message}"
      throw ("Unknown error. #{error.message}")

    rescue Net::ReadTimeout
      # binding.pry
      @util.errorlogging "Net Read timeout failure #{error.message} "
      throw ("Net Read timeout failure #{error.message} ")
    rescue Selenium::WebDriver::Error::ElementClickInterceptedError
      @util.errorlogging "--> Element  was displayed but click would be intercepted #{error.message}"
      throw("--> Element  was displayed but click would be intercepted #{error.message}")
    rescue =>e
      @util.errorlogging("Unable to verify items are on the shop page Error:#{e} ")
      throw ("Unable to verify items are on the shop page Error:#{e}")
    end

  end

  def go_to_cart
    click_element("Cart","UserApp","User Cart")
    # need some validation here
  end

  def remove_item_from_cart_and_verify(itemNumber)
    itemNumber = itemNumber-1
    elements = @driver.find_elements(:xpath ,"//div[@class='table-cell product_name']/div/a/span")
    returnValue = false
    if(elements.count>0)
      productToRemove =elements[itemNumber].text
      @util.logging("There are #{elements.count} item(s) in the cart before removing #{productToRemove}")
      beforeItemsCount = elements.count
      removeElements = @driver.find_elements(:xpath ,"//div[@class='table-cell remove-product-cell']")
      removeElements[itemNumber].click
      @util.logging("-->Clicking the X next to #{productToRemove} in the cart")
      # binding.pry
      #if (check_if_element_exists(:xpath,get_element_from_navigation("Remove Recurring Product Modal","UserApp>Cart"),10,"Check for remove Recurring item modal","warn") ==1)
      # binding.pry
      # highlight(:xpath,get_element_from_navigation("Remove All Future Deliveries button","UserApp>Cart"),10)
      sleep(20)

      click_element_if_exists("Remove All Future Deliveries button","UserApp>Cart",10,"Remove All Future Recurring Deliveries in item modal","warn")
      click_element_if_exists("OK button","UserApp>ImportantInformationModal",20,"OK button","warn")
      #end
      sleep(20)
      elementsAfter = @driver.find_elements(:xpath ,"//div[@class='table-cell product_name']")

      if ((beforeItemsCount -1) >= elementsAfter.count)
        @util.logging("There are #{elementsAfter.count} item(s) in the cart after removing #{productToRemove} -- Pass product removed")
        returnValue = true
      else
        @util.errorlogging("#{productToRemove} not removed from the cart")
        throw ("#{productToRemove} not removed from the cart")

      end
      return returnValue
    end
  end

  def search_for_customer(orderStatus)

    searchCriteria =""
    login = ""
    lastName =""
    userRow = ""
    if orderStatus == "Recurring"
      results = run_automation_db_query("select c.* from dbp_customers as c left join dbp_recurring_orders as r on r.login=c.login where c.usertype = 'C' and c.login not like 'dbp_an0nym0us_%' and c.user_active ='Y' and r.recurring_order not like '\%s:8:\"products\";a:0\%' order by rand() limit 1;")
    else
      results = run_automation_db_query("select cust.* from dbp_customers as cust ,dbp_orders as orders where cust.usertype = 'C' and cust.login != 'master'  and cust.user_active ='Y' and orders.login = cust.login and orders.status='#{orderStatus}' order by rand() limit 1")
    end
    results.each do |row|
      searchCriteria = row["email"]
      login = row["login"]
      lastName = row["lastname"]
      userRow = row
    end

    enter_text("Search for Input Field","User Management>Customers>Search for Customers","#{login}","Search for Customer: #{login}")
    click_element("Search Button","User Management>Customers>Search for Customers","Search Button")
    click_element(:xpath,"//p[contains(text(),'#{searchCriteria}')]/a", "Clicking on results table full name and email column  on row with #{searchCriteria}")
    url = get_url()
    @util.logging("URL is #{url}")
    if (url.include?("admin/customer/") && url.include?("usertype=C"))
      check_if_element_exists(:xpath,"//input[@value='#{searchCriteria}']",10,"Customer email on customer card")
      return userRow
    else
      @util.errorlogging("Not on customer #{searchCriteria} customer page")
      throw("Not on customer #{searchCriteria} customer page")
    end
  end

  def click_on_row_in_table(searchCriteria,tableName)
    begin
      click_element(:xpath,"//p[contains(text(),'#{searchCriteria}')]/a", "Clicking on results table #{tableName} and email column  on row with #{searchCriteria}")
    rescue StandardError => e
      @util.errorlogging("Unable to click on row in table#{e}")
      throw ("Unable to click on row in table#{e}")
    end
  end

  def search_for_administrator()
    adminlogin =""
    results = run_automation_db_query("select email from dbp_customers where usertype = 'P' and login != 'master' order by rand() limit 1")
    results.each do |row|
      adminlogin = row["email"]
    end
    enter_text("Search Text Field","User Management>Administrators>Search for Admins",adminlogin,"Search text field")

    click_element("Search Button","User Management>Administrators>Search for Admins","Search Button")

    click_element(:xpath,"//p[contains(text(),'#{adminlogin}')]/a", "Clicking on results table full name and email column on row with #{adminlogin}")

    url = get_url()
    @util.logging("URL is #{url}")

    if (url.include?("admin/user_modify.php?user") && url.include?("usertype=P"))
      check_if_element_exists(:xpath,"//input[@value='#{adminlogin}']",10,"Admin email on admin card")
    else
      @util.errorlogging("Not on Admin #{adminlogin} page")
      throw("Not on Admin #{adminlogin} page")
    end

  end
  def search_for_supplier()
    begin
      supplierlogin =""
      searchCriteria = ""
      results = run_automation_db_query("select * from dbp_suppliers order by rand() limit 1")
      results.each do |row|
        supplierlogin = row["login"]
        searchCriteria = row['email']

      end
      enter_text("Search Text Field","User Management>Suppliers>Search for Suppliers",supplierlogin,"Search text field text #{supplierlogin}")

      click_element("Search Button","User Management>Suppliers>Search for Suppliers","Search Button")
      sleep(20)
      click_element(:xpath,"//p[contains(text(),'#{searchCriteria}')]/a", "Clicking on results table full name and email column  on row with #{searchCriteria}")

      # elements  = @driver.find_elements(:xpath,"//td[@data-id ='full_name']/p/a")
      # found = false
      # suppliersArray = Array.new
      # elements.each do |element|
      #   suppliersArray.push(element.text)
      #   # puts element.text
      #   #   if (element.text.include?(supplierlogin))
      #   #    element.click
      #   #     @util.logging("Clicking on results table full name and email column on row with  #{supplierlogin}")
      #   #     found = true
      #   #   end
      # end

      # elementCounter= 0
      # suppliersArray.each do |supplierText|
      #   if supplierText.include?(supplierlogin)
      #     elements[elementCounter].click
      #   else
      #     elementCounter = elementCounter +1
      #   end
      # end
      url = get_url()
      @util.logging("URL is #{url}")
      if (url.include?("admin/user_modify.php?user") && url.include?("usertype=U"))
        check_if_element_exists(:xpath,"//input[@value='#{supplierlogin}']",10,"Supplier Card")
      else
        @util.errorlogging("Not on supplier #{supplierlogin} page")
        throw("Not on supplier #{supplierlogin} page")
      end
    rescue StandardError => e
      @util.errorlogging("Unable to search for supplier.  Error:#{e}")
      throw ("Unable to search for supplier.  Error:#{e}")
    end
  end
  def search_for_driver()
    driverLogin =""
    results = run_automation_db_query("select email from dbp_customers where usertype = 'D'  order by rand() limit 1")
    results.each do |row|
      driverLogin = row["email"]
    end
    enter_text("Search Text Field","User Management>Drivers>Search for Drivers",driverLogin,"Search text field")

    click_element("Search Button","User Management>Drivers>Search for Drivers","Search Button")
    click_element(:xpath,"//p[contains(text(),'#{driverLogin}')]/a", "Clicking on results table full name and email column  on row with  #{driverLogin}")
    url = get_url()
    @util.logging("URL is #{url}")
    if (url.include?("admin/user_modify.php") && url.include?("usertype=D"))
      check_if_element_exists(:xpath,"//input[@value='#{driverLogin}']",10,"Driver Email on driver modify page")
    else
      @util.errorlogging("Not on driver #{driverLogin} page")
      throw("Not on driver #{driverLogin} page")
    end

  end
  def search_for_product()
    productCode =""
    productName=""
    results = run_automation_db_query("select * from dbp_products order by rand() limit 1")
    results.each do |row|
      productCode = row["productcode"]
      productName = row["product"]
    end
    enter_text("Search by keyword","Products>Edit/Search Products",productCode,"Search by Keyword")

    click_element("Search Button","Products>Edit/Search Products","Search Button")
    click_element(:xpath,"//a[contains(text(),'#{productCode}')]", "Clicking on results table in SKU column on row with#{productCode}")
    url = get_url()
    @util.logging("URL is #{url}")
    if (url.include?("admin/products"))
      check_if_element_exists(:xpath,"//input[@value='#{productCode}']",10,"SKU on product edit page")
      check_if_element_exists(:xpath,"//input[@value='#{productName}']",10,"Product Name on product edit page")
    else
      @util.errorlogging("Not on product #{productCode} page")
      throw("Not on product #{productCode} page")
    end


    @driver.navigate.back
    @util.logging("Navigating back to the search page and clicking on the Product name")
    click_element(:xpath,"//a[contains(text(),'#{productName}')]", "Clicking on results table in Product column on row with  #{productName}")
    url = get_url()
    @util.logging("URL is #{url}")
    if (url.include?("admin/products"))
      check_if_element_exists(:xpath,"//input[@value='#{productCode}']",10,"SKU on product edit page")
      check_if_element_exists(:xpath,"//input[@value='#{productName}']",10,"Product Name on product edit page")
    else
      @util.errorlogging("Not on product #{productCode} page")
      throw("Not on product #{productCode} page")
    end

  end

  def add_new_product_for_day()
    begin
      date = get_date(0)
      sku = "sku#{date}"

      enter_text("Product Name","Products>Add New Product","Product for #{date}", "Product Name")
      enter_text("SKU","Products>Add New Product",sku, "sku")
      randSupplier = rand(5)
      select_dropdown_list_text("Supplier select","Products>Add New Product",randSupplier,"Supplier option #{randSupplier}" ,"index")

      click_element("Product Teaser Frame","Products>Add New Product","Product Teaser Frame")
      @util.logging("Entering the following into the product teaser -  Product for #{date} teaser information-  buy me  ")
      @driver.action.send_keys("Product for #{date} teaser information-  buy me").perform


      click_element("Short description Frame","Products>Add New Product","Short Description Frame")
      @util.logging("Entering the following into the product teaser -  This is a short description of  the Product for #{date}  ")
      @driver.action.send_keys("This is a short description of  the Product for #{date} ").perform

      select_dropdown_list_text("Main Category select","Products>Add New Product",1,"Main Category select 'Featured Products'","index" )
      select_dropdown_list_text("Availability select","Products>Add New Product","Available for sale","Availability selecting 'Available for sale'" )
      enter_text("Quantity on Hand","Products>Add New Product","100","Quantity on Hand")
      enter_text("Product Price","Products>Add New Product","19.99","Product Price")
      enter_text("Product retail price","Products>Add New Product","19.00", "Product retail price")
      enter_text("Our Cost","Products>Add New Product","10.00","Our cost")
      enter_text("First time price","Products>Add New Product","19.00","First Time price")
      click_element("Save","Products>Add New Product","Save")
      productCreated = check_if_element_exists_get_element_text("Product Succesfully Created","Products>Add New Product",60,"Verifying new product sucessfully created")
      if !(productCreated.include?("The product has been successfully created"))
        @util.errorlogging("Unable to create new product for the day. Because of the error: #{productCreated}")
        throw ("Unable to create new product for the day. Because of the error:#{productCreated}")
      end
      return "Product for #{date}"

    rescue StandardError => e
      @util.errorlogging("Unable to create new product for the day.  Error:#{e}")
      throw ("Unable to create new product for the day.  Error:#{e}")
    end
  end
  def login_as_random_customer_from_backend_with_upcoming_orders()
    begin

      userRow = search_for_customer("P")
      get_url()

      click_element("Login as this Customer","User Management>Customers>Search for Customers>Customer Card","Login as customer")
      sleep(2)
      click_element("Login as customer link","User Management>Customers>Search for Customers>Customer Card","Login as customer link")
      return userRow
    rescue StandardError => e
      @util.errorlogging("Unable to login as random customer from the backend with upcoming orders  Error:#{e}")
      throw ("Unable to login as random customer from the backend  with upcoming orders#{e}")
    end
  end
  def login_as_random_customer_from_backend_with_recurring_orders()
    begin

      userRow = search_for_customer("Recurring")
      get_url()

      click_element("Login as this Customer","User Management>Customers>Search for Customers>Customer Card","Login as customer")
      sleep(2)
      click_element("Login as customer link","User Management>Customers>Search for Customers>Customer Card","Login as customer link")
      return userRow
    rescue StandardError => e
      @util.errorlogging("Unable to login as random customer from the backend with upcoming orders  Error:#{e}")
      throw ("Unable to login as random customer from the backend  with upcoming orders#{e}")
    end
  end

  def login_as_random_customer_from_backend_with_order_history()
    begin

      userRow = search_for_customer("C")
      get_url()

      click_element("Login as this Customer","User Management>Customers>Search for Customers>Customer Card","Login as customer")
      sleep(2)
      click_element("Login as customer link","User Management>Customers>Search for Customers>Customer Card","Login as customer link")
      return userRow
    rescue StandardError => e
      @util.errorlogging("Unable to login as random customer from the backend with order history Error:#{e}")
      throw ("Unable to login as random customer from the backend with order history Error:#{e}")
    end
  end
  def create_default_admin_for_the_day()
    begin
      date =get_date(0)

      enter_text("First Name","User Management>Administrators>Create Admin Profile","Default Admin","First Name")
      enter_text("Last Name","User Management>Administrators>Create Admin Profile","for #{date}","Last Name")
      enter_text("Phone","User Management>Administrators>Create Admin Profile","5555555","Phone")
      enter_text("E-mail","User Management>Administrators>Create Admin Profile","DefaultAdmin#{date}@mailinator.com","Email")
      enter_text("Confirm E-mail","User Management>Administrators>Create Admin Profile","DefaultAdmin#{date}@mailinator.com","Confirm Email")
      enter_text("Username","User Management>Administrators>Create Admin Profile","DefaultAdmin#{date}","Username")
      enter_text("Password","User Management>Administrators>Create Admin Profile","getswift","Password")
      enter_text("Confirm Password","User Management>Administrators>Create Admin Profile","getswift","Confirm Password")
      click_element("Show Dashboard Widgets checkbox","User Management>Administrators>Create Admin Profile","Show Dashboard Widgets")
      click_element("Save","User Management>Administrators>Create Admin Profile","Save")
      check_if_element_exists_get_element_text("Profile sucessfully created","User Management>Customers>Create Customer Profile",60,"Verifying profile sucessfully created")

    rescue StandardError => e
      @util.errorlogging("Unable to create default admin for the day.  Error:#{e}")
      throw ("Unable to create default admin for the day.  Error:#{e}")
    end
  end

  def create_default_driver_for_the_day()
    begin
      date =get_date(0)

      enter_text("First Name","User Management>Drivers>Create Driver Profile","Default Driver","First Name")
      enter_text("Last Name","User Management>Drivers>Create Driver Profile","for #{date}","Last Name")
      enter_text("Phone","User Management>Drivers>Create Driver Profile","5555555","Phone")
      enter_text("E-mail","User Management>Drivers>Create Driver Profile","DefaultDriver#{date}@mailinator.com","Email")
      enter_text("Confirm E-mail","User Management>Drivers>Create Driver Profile","DefaultDriver#{date}@mailinator.com","Confirm Email")
      enter_text("Username","User Management>Drivers>Create Driver Profile","DefaultDriver#{date}","Username")
      enter_text("Password","User Management>Drivers>Create Driver Profile","getswift","Password")
      enter_text("Confirm Password","User Management>Drivers>Create Driver Profile","getswift","Confirm Password")
      click_element("Save","User Management>Drivers>Create Driver Profile","Save")
      check_if_element_exists_get_element_text("Profile sucessfully created","User Management>Customers>Create Customer Profile",60,"Verifying profile sucessfully created")

    rescue StandardError => e
      @util.errorlogging("Unable to create default driver for the day.  Error:#{e}")
      throw ("Unable to create default driver for the day.  Error:#{e}")
    end
  end
  def check_for_file_download(filename,timeInSeconds)
    begin
      startTime = Time.now
      endTime = startTime + timeInSeconds
      found = false
      fileDirArray = @@filedir.split('/')
      date = get_date(0)

      while ((found ==  false) && (Time.now < endTime)) do
          sleep(5)
          found =File.file?("/Users/#{fileDirArray[2]}/Downloads/#{filename}")
        end
        if found == false
          throw ("Unable to find the file #{filename} after #{timeInSeconds} seconds")
        else
          @util.logging("#{filename} found. Moving to #{@@filedir}/logs/#{date}/#{filename}")

          File.rename "/Users/#{fileDirArray[2]}/Downloads/#{filename}","#{@@filedir}/logs/#{date}/#{filename}"
        end

      rescue StandardError => e
        @util.errorlogging("Error trying to find the file.  Error:#{e}")
        throw ("Error trying to find the file.  Error:#{e}")
      end
    end
    def verify_print_route_sheets_show_return_route_name()
      begin
        headerText =   check_if_element_exists_get_element_text("Show Results Header","Route Management>Print Route Sheets",60,"Verifying Show Results Header exists")
        count =0
        while ((headerText =="") && count <5)
          headerText =   check_if_element_exists_get_element_text("Show Results Header","Route Management>Print Route Sheets",60,"Verifying Show Results Header exists")

          count = count +1
        end
        route = headerText[(headerText.index('Route')+6)..(headerText.index('Total Deliveries')-2)]
        @util.logging("Route selected is #{route}")

        return route
      rescue StandardError => e
        @util.errorlogging("Unable to verify the results of clicking the show button Error:#{e}")
        throw ("Unable to verify the results of clicking the show button.  Error:#{e}")
      end
    end
    def choose_a_route_multiselect()
      #this is a hack since the option select does not work on this element
      element = @driver.find_element(:xpath,"//select[@id='mult-route-id']/../label")
      element.click
      @util.logging ("-->Clicking on the choose a route label to get the dropdown")

      elements = @driver.find_elements(:xpath,"//*[@id='driving-dir-mult']/div[1]/div/div/ul/li/label")
      elements[1].click
      elements[2].click
      @util.logging("Choosing the first two options from the dropdown")

      element = @driver.find_element(:xpath,"//select[@id='mult-route-id']/../label")
      element.click

    end
    def check_columns_count(filename,numberToVerify)
      if (filename[(filename.index('.'))..(filename.length)] == ".csv")
        check_columns_count_csv(filename,numberToVerify)
      elsif (filename[(filename.index('.'))..(filename.length)] == ".xls") ||(filename[(filename.index('.'))..(filename.length)] == ".xlsx")
        check_columns_count_xls(filename,numberToVerify)
      else
        throw("unknown file format of #{filename[(filename.index('.'))..(filename.length)]}")
      end

    end

    def check_columns_count_xls(filename,numberToVerify)
      begin

        fileDirArray = @@filedir.split('/')
        wait_for_file(filename,180)
        xlsx = Roo::Spreadsheet.open("/Users/#{fileDirArray[2]}/Downloads/#{filename}")
        @util.logging("Basic info about the file\n  #{xlsx.info}")
        @util.logging("The default sheet is #{xlsx.default_sheet}")
        @util.logging("The first 3 lines of the first sheet #{xlsx.sheets[0]} of the file are:\n <font color=\"blue\"> #{xlsx.sheet(0).row(1)}\n#{xlsx.sheet(0).row(2)}\n#{xlsx.sheet(0).row(3)}</font> ")
        if (numberToVerify == 0)
          @util.logging("The column count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename} is #{xlsx.sheet(0).last_column}")
          return
        end
        if xlsx.sheet(0).last_column != numberToVerify
          @util.errorlogging("The column count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename} of #{xlsx.sheet(0).last_column} does not equal the expected #{numberToVerify}")
          check_override(true,"The column count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename}of #{xlsx.sheet(0).last_column} does not equal the expected #{numberToVerify}",true)
        else
          @util.logging("The column count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename} of #{xlsx.sheet(0).last_column} equals the expected column count #{numberToVerify}")
        end

      rescue StandardError => e
        @util.errorlogging("Error trying verify the column count in xls Error:#{e}")
        check_override(true,"Error trying verify the column count in xls Error:#{e}",true)
      end
    end

    def check_columns_count_csv(filename,numberToVerify)
      begin
        fileDirArray = @@filedir.split('/')
        wait_for_file(filename,180)

        fileArray = CSV.read("/Users/#{fileDirArray[2]}/Downloads/#{filename}")

        @util.logging("The first line   of the file is:\n <font color=\"blue\">#{fileArray[0]}\n</font> ")
        columns = fileArray[0]
        if (numberToVerify == 0)
          @util.logging("The column count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename} is #{columns.count}")
          return
        end
        if (columns.count != numberToVerify)
          @util.errorlogging("The column count in the file /Users/#{fileDirArray[2]}/Downloads/#{filename} of #{columns.count} does not equal the expected #{numberToVerify}")
          check_override(true,"The column count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename}of #{columns.count} does not equal the expected #{numberToVerify}",true)
        else
          @util.logging("The column count in the file /Users/#{fileDirArray[2]}/Downloads/#{filename} of #{columns.count} equals the expected column count #{numberToVerify}")
        end

      rescue StandardError => e
        @util.errorlogging("Error trying verify the column count in csv. Error:#{e}")
        check_override(true,"Error trying verify the column count in csv Error:#{e}",true)
      end
    end
    def check_rows_count(filename,numberToVerify)
      if (filename[(filename.index('.'))..(filename.length)] == ".csv")
        check_rows_count_csv(filename,numberToVerify)
      elsif (filename[(filename.index('.'))..(filename.length)] == ".xls") ||(filename[(filename.index('.'))..(filename.length)] == ".xlsx")
        check_rows_count_xls(filename,numberToVerify)
      else
        throw("unknown file format of #{filename[(filename.index('.'))..(filename.length)]}")
      end

    end
    def check_rows_count_xls(filename,numberToVerify)
      begin

        fileDirArray = @@filedir.split('/')
        wait_for_file(filename,180)
        xlsx = Roo::Spreadsheet.open("/Users/#{fileDirArray[2]}/Downloads/#{filename}")
        @util.logging("Basic info about the file\n  #{xlsx.info}")
        @util.logging("The default sheet is #{xlsx.default_sheet}")
        @util.logging("The first 3 lines of the first sheet #{xlsx.sheets[0]} of the file are:\n <font color=\"blue\"> #{xlsx.sheet(0).row(1)}\n#{xlsx.sheet(0).row(2)}\n#{xlsx.sheet(0).row(3)}</font> ")
        if (numberToVerify == 0)
          @util.logging("The row count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename} is #{xlsx.sheet(0).last_column}")
          return
        end
        if xlsx.sheet(0).last_row != numberToVerify
          @util.errorlogging("The row count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename} of #{xlsx.sheet(0).last_row} does not equal the expected #{numberToVerify}")
          check_override(true,"The row count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename}of #{xlsx.sheet(0).last_row} does not equal the expected #{numberToVerify}",true)
        else
          @util.logging("The row count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename} of #{xlsx.sheet(0).last_row} equals the expected column count #{numberToVerify}")
        end

      rescue StandardError => e
        @util.errorlogging("Error trying verify the row count in xls Error:#{e}")
        check_override(true,"Error trying verify the row count in xls Error:#{e}",true)
      end
    end

    def check_rows_count_csv(filename,numberToVerify)
      begin
        fileDirArray = @@filedir.split('/')
        wait_for_file(filename,180)

        fileArray= CSV.read("/Users/#{fileDirArray[2]}/Downloads/#{filename}")
        @util.logging("The first line of the file is:\n <font color=\"blue\">#{fileArray[0]}\n</font> ")

        if (numberToVerify == 0)
          @util.logging("The row count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename} is #{fileArray.count}")
          return
        end
        if (fileArray.count != numberToVerify)
          @util.errorlogging("The row count in the file /Users/#{fileDirArray[2]}/Downloads/#{filename} of #{fileArray.count} does not equal the expected #{numberToVerify}")
          check_override(true,"The row count in the first sheet of the file /Users/#{fileDirArray[2]}/Downloads/#{filename}of #{fileArray.count} does not equal the expected #{numberToVerify}",true)
        else
          @util.logging("The row count in the file /Users/#{fileDirArray[2]}/Downloads/#{filename} of #{fileArray.count} equals the expected row count #{numberToVerify}")
        end

      rescue StandardError => e
        @util.errorlogging("Error trying verify the row count in csv. Error:#{e}")
        check_override(true,"Error trying verify the row count in csv Error:#{e}",true)
      end
    end

    def wait_for_file(filename,timeToWait)
      startTime = Time.now
      endTime = startTime + timeToWait
      found = false
      fileDirArray = @@filedir.split('/')
      date = get_date(0)

      while ((found ==  false) && (Time.now < endTime)) do
          sleep(5)
          found =File.file?("/Users/#{fileDirArray[2]}/Downloads/#{filename}")
        end
        if (found == false)
          throw("The file was not found in #{timeToWait} seconds")
        end
      end

      def verify_order_numbers_show_in_grid(userlogin,status)
        begin
          epochTime = Time.now.to_i
          results = run_automation_db_query("select * from dbp_orders where login ='#{userlogin}'  and status ='#{status}' and date < #{epochTime} order by orderid desc limit 5")

          results.each do |row|
            check_if_element_exists(:xpath,"//a[contains(text(),'#{row["orderid"]}')]",10,"Verifying order #{row["orderid"]} shows on the page")
          end
        rescue StandardError => e
          @util.errorlogging("Error trying  verify the orders show in the grid Error:#{e}")
          throw ("Error trying  verify the orders show in the grid. Error:#{e}")
        end
      end
      def select_five_random_users_on_customer_search()
        begin
          for i in 1..5
            #randUser = rand(100)
            click_element_ignore_failure(:xpath,"//*[@id='users-table']/tbody/tr[#{i}]/td[1]/div/label/div","User number #{i}")
          end

        rescue StandardError => e
          @util.errorlogging("Unable to select random users on select page Error:#{e}")
          throw ("Unable to select random users on select page Error:#{e}")
        end
      end
      def select_first_five_products_on_product_search()
        begin
          for i in 1..5
            #randUser = rand(100)
            # //*[@id="products"]/tbody/tr[98]/td[1]/div/ins
            click_element_from_elements(:xpath,"//*[@id='products']/tbody/tr/td[1]/div",i,"Product number #{i}")
            # click_element_ignore_failure(:xpath,"//*[@id='products']/tbody/tr[#{i}]/td[1]/div","Random product number #{i}")
          end

        rescue StandardError => e
          @util.errorlogging("Unable to select products on select page Error:#{e}")
          throw ("Unable to select products on select page Error:#{e}")
        end
      end
      def verify_number_of_customers_using_credit_card_on_electronic_billing(webresult)
        begin
          results = run_automation_db_query("select count(*) from (SELECT c.login AS login, SUM(p.payment_value) AS balance, c.firstname, c.lastname FROM dbp_customers c LEFT JOIN dbp_payments p ON c.login=p.payment_login WHERE (p.payment_date<UNIX_TIMESTAMP('2021-06-30') OR (p.payment_type IN ('', 'I','C','T','A','Y') AND p.payment_value>'0' AND p.payment_orderid='0')) AND c.usertype='C' AND ( (c.payment_type='A') ) AND c.store_id='1' GROUP BY c.login HAVING balance<'-0' ORDER BY c.lastname, c.firstname) as r;")
          count= ""
          results.each do |row|
            count = row["count(*)"]
          end

          if (count !=webresult.to_i)
            @util.errorlogging("Error: The number of users on credit card from the database has #{count} but the web shows #{webresult} ")
            throw ("Error: The number of users on credit card from the database has #{count} but the web shows #{webresult}")
          else
            @util.logging("The number of users on credit card from the database has #{count} and the web shows #{webresult}.  Matching ")
          end
        rescue StandardError => e
          @util.errorlogging("Unable to verify Error:#{e}")
          throw ("Unable to verify Error:#{e}")
        end
      end

      def kml_map_verification
        begin
          element = @driver.find_element(:xpath,"//*[@id='navmap']/div/div/div[2]/div[3]/div/div[1]")
          location = element.location
          @driver.action.move_by(location.x,location.y).perform
          sleep(2)
          @driver.action.click.perform
          sleep(2)
          element2 = @driver.find_element(:xpath,"//*[@id='navmap']/div/div/div[2]/div[3]/div/div[4]/div/div/div/div/div/div/div")
          element2.text
          if element2.text.length >0
            @util.logging("Clicked a boundary named #{element2.text}")
          else
            throw ("Tried to click on a boundary, but no boundary selected came up. ")
          end

        rescue StandardError => e
          @util.errorlogging("Unable to verify KML file page Error:#{e}")
          throw ("Unable to verify KML file page Error:#{e}")
        end
      end

      def select_checkbox_in_row_with_value(text)
        begin
          @util.logging("Clicking on the check box for #{text}")
          element = @driver.find_element(:xpath,"//input[@value = '#{text}']/../../../td[1]/div/ins")
          element.click

        rescue StandardError => e
          @util.errorlogging("Unable click on the check box for #{text} Error:#{e}")
          throw ("Unable click on the check box for #{text} Error:#{e}")
        end
      end


    ;end
