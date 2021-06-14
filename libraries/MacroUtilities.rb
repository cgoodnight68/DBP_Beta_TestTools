class Utilities;
  @navigationHash = Hash.new


  def load_admin_navigation_elements
    begin
      client = PG::Connection.open(:dbname => 'WebElements_pg_development', :host => '54.201.168.175', :user => 'postgres', :password =>'getswift' )
      environment = @base_url[8..(@base_url.index('.')-1)]

       newQuery = "select * from dbpelements"
     # newQuery = "select * from dbpelements where environment = '#{environment}'"
      #binding.pry
      results = client.exec(newQuery)

      @navigationHash = Array.new
      results.each do |lines|
        @navigationHash.push(lines)
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
    rescue
      @util.errorlogging("Unable to navigate to #{menu_item}")
     throw("Unable to navigate to #{menu_item}")
    end
  end

  def login_to_admin
    goto_url("#{@base_url}/admin/login")
    enter_text(:xpath,"//input[@name='username']","master", "Sign Username")
    # if @base_url.include?"integration"
    #   enter_text(:xpath,"//input[@name='password']","6a4GhvF3k@XwYMLCXFbad@v3", "Password")
    # else
    #   enter_text(:xpath,"//input[@name='password']","6a4GhvF3k@XwYMLCXFbad@v3", "Password")
    element = @driver.find_element(:xpath,"//input[@name='password']")
    element.send_keys("FycAq8Sg5V2ov956mXD4")
    # element.send_keys("6a4GhvF3k@XwYMLCXFbad@v3")
    click_element(:xpath,"//div[@class='icheckbox_flat-green']", "Agree to terms")
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

  def create_default_customer_for_the_day
    begin
    time = Time.new
    date = "#{time.month}_#{time.day}_#{time.year}"
    count = ""
    results = run_automation_db_query("select count(*) from dbp_customers")
    results.each do |row|
      count = row["count"]
    end
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
    enter_text("FirstName","User Management>Customers>Create Customer Profile", "#{date}_Default", "First Name")
    enter_text("LastName","User Management>Customers>Create Customer Profile", "Cust","Last Name")
    #binding.pry
    birthdayCheck = check_if_element_exists("Birthday","User Management>Customers>Create Customer Profile",10,"Birthday","warn")
    if birthdayCheck != "warn"
      enter_text("Birthday","User Management>Customers>Create Customer Profile","#{date}")
    end

    enter_text("Email","User Management>Customers>Create Customer Profile", "#{date}_Default_Cust@mailinator.com","Email")
    enter_text("Email2","User Management>Customers>Create Customer Profile", "#{date}_Default_Cust@mailinator.com","Confirm Email")
    phoneProviderCheck = check_if_element_exists("Phone Provider selector","User Management>Customers>Create Customer Profile",5)

    if phoneProviderCheck != false

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
    elsif (check_if_element_exists("Payment Method selector","User Management>Customers>Create Customer Profile",10,"Payment method selector","warn") != "warn")
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
  click_element("NDIS participant","User Management>Customers>Create Customer Profile","Are you an NDIS participant")
     @driver.action.send_keys("\ue015\ue015\ue007").perform #big hack. just sending down down and enter
end



    ######

    click_element("Save","User Management>Customers>Create Customer Profile","Save button")

    #binding.pry

    wait_for_element("Profile sucessfully created","User Management>Customers>Create Customer Profile","Verifying profile sucessfully created",180)
    check_if_element_exists_get_element_text("Profile sucessfully created","User Management>Customers>Create Customer Profile",60,"Verifying profile sucessfully created")
    rescue
      @util.errorlogging("Unable to create user for the day: ")
       throw ("Unable to create user for the day")
    end
  end

  def credit_card_modal_entry()
    begin
    time = Time.new
    date = "#{time.month}_#{time.day}_#{time.year}"
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

    rescue
      @util.errorlogging("Unable to do enter credit card detail:")
      throw("Unable to do enter credit card detail:") 
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

    time = Time.new
    date = "#{time.month}_#{time.day}_#{time.year}"

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

rescue
      @util.errorlogging("Unable to create user from the app side: ")
     throw ("Unable to create user from the app side:")
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
     click_element_if_exists(:xpath,"//*[@id='alert-message-modal']/div/div/div[3]/button",10,"Catch any modal windows open from login")
    elements = @driver.find_elements(:xpath ,"//div[@class='product-wrapper']/..")
    if (elements.count>0)
      productWrapperToClick = rand(elements.count.to_i) - 1

      productId = elements[productWrapperToClick].attribute("data-productid")


      productDescription = elements[productWrapperToClick].find_elements(:xpath,"//div[@class ='product-labeling ']")
      @util.logging("-->Clicking on product number #{productId}  Description: <br><font color =\"blue\"> #{productDescription[productWrapperToClick].text} </font>")
      sleep(5)
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
    rescue
     @util.errorlogging("Unknown error 1 in select random item")
      throw ("Unknown error 1 in select random item")
    else

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
      sleep(10)

      click_element_if_exists("Remove All Future Deliveries button","UserApp>Cart",10,"Remove All Future Recurring Deliveries in item modal","warn")
      # binding.pry
      click_element_if_exists("OK button","UserApp>ImportantInformationModal",20,"OK button","warn")
      #end
      #binding.pry
      elementsAfter = @driver.find_elements(:xpath ,"//div[@class='table-cell product_name']")
      #binding.pry
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

  def search_for_customer()

      searchCriteria =""
       results = run_automation_db_query("select email from dbp_customers where usertype = 'C'  order by rand() limit 1")
      results.each do |row|
        searchCriteria = row["email"]
      end

    enter_text("Search for Input Field","User Management>Customers>Search for Customers",searchCriteria,"Search for Customer: #{searchCriteria}")
    click_element("Search Button","User Management>Customers>Search for Customers","Search Button")
    click_element(:xpath,"//p[contains(text(),'#{searchCriteria}')]/a", "Clicking on #{searchCriteria}")

    url = get_url()
    @util.logging("URL is #{url}")
    if (url.include?("admin/customer/") && url.include?("usertype=C"))
      check_if_element_exists(:xpath,"//input[@value='#{searchCriteria}']",10,"Customer email on customer card")
    else
      @util.errorlogging("Not on customer #{searchCriteria} customer page")
      throw("Not on customer #{searchCriteria} customer page")
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
    
     click_element(:xpath,"//p[contains(text(),'#{adminlogin}')]/a", "Clicking on #{adminlogin}")

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
    supplierlogin =""
       results = run_automation_db_query("select supplier_name from dbp_suppliers order by rand() limit 1")
      results.each do |row|
        supplierlogin = row["supplier_name"]
      end
     enter_text("Search Text Field","User Management>Suppliers>Search for Suppliers",supplierlogin,"Search text field")

     click_element("Search Button","User Management>Suppliers>Search for Suppliers","Search Button")
      elements  = @driver.find_elements(:xpath,"//td[@data-id ='full_name']/p/a")
        found = false
        elements.each do |element|
          puts element.text
          if (element.text.include?(supplierlogin)) && (found == false)

            element.click 
            @util.logging("Clicking on #{supplierlogin}")
            found = true
          end
        end

    url = get_url()
    @util.logging("URL is #{url}")

   if (url.include?("admin/user_modify.php?user") && url.include?("usertype=U"))
      check_if_element_exists(:xpath,"//input[@value='#{supplierlogin}']",10,"Supplier Card")
    else
     @util.errorlogging("Not on supplier #{supplierlogin} page")
      throw("Not on supplier #{supplierlogin} page")
    end

  end

;end
