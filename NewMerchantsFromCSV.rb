require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class CreateMultipleMerchants< Test::Unit::TestCase
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

  def test_create_multiple_merchants

   file=File.open("./CreateMerchant_Modified.csv")
   file_data = file.readlines.map(&:chomp)
    @test.goto_url(@base_url)

    @test.enter_text(:xpath,"//input[@id='Email']","cgoodnight+over100@getswift.co", "Sign in Email")
    @test.enter_text(:xpath,"//input[@id='Password']","getswift", "Sign in Email")
    @test.click_element(:xpath,"//button[contains(text(),'Sign In')]","Sign in Button")
 
      @test.goto_url("#{@base_url}/OrganisationMerchant/Index/")

      @test.click_element(:xpath,"//button[contains(text(),'Create a new merchant')]","Create a new merchant")
     file_data.each do |l|
      line =l.split(',')
      if line[0] != "MerchantName"
      @test.enter_text(:xpath,"//input[@id='Name']",line[0], "Merchant Name")
      @test.enter_text(:xpath,"//input[@id='Email']",line[1], "Merchant Email")
      input_element = @driver.find_element(:xpath,"//input[@id='geolocationSerchInput']")
      input_element.send_keys(line[2])
      sleep(1)
      input_element.send_keys(:arrow_down)
      sleep(1)
      input_element.send_keys(:return)
      sleep(1)
      @test.click_element(:xpath,"//button[contains(text(),'Add')]","Add Button")
      created = @test.check_if_exist(:xpath,"//div[contains(text(),'#{line[0]} created')]","Check that the merchant was created")
      if created != true
         @util.logging("#{line[0]} not created")
           @test.goto_url("#{@base_url}/OrganisationMerchant/Create")
      end
       
      end
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
