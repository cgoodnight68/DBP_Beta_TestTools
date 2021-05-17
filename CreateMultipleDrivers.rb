require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class CreateMultipleDrivers < Test::Unit::TestCase
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

  def test_create_multiple_drivers
    @test.goto_url(@base_url)

    @test.enter_text(:xpath,"//input[@id='Email']","snoi+mealpal1@getswift.co ", "Sign in Email")
    @test.enter_text(:xpath,"//input[@id='Password']","getswift", "Sign in Email")
    @test.click_element(:xpath,"//button[contains(text(),'Sign In')]","Sign in Button")

    for i in 1..20
          @test.goto_url("#{@base_url}/Courier/Register?fleetId=fb971982-92f0-4ae4-98c4-740fd0e9e436")
     #@test.goto_url("#{@base_url}/Fleets/Index/")
     # @test.click_element(:xpath,"//span[contains(text(),'New')]","New")
     # @test.click_element(:xpath,"//button[contains(text(),'Add new driver')]","Add Drivers Button")
      @test.enter_text(:xpath,"//input[@id='FullName']","mp#{i}", "Full Name")
      @test.enter_text(:xpath,"//input[@id='Email']","mp#{i}@mailinator.com", "Email")
      @test.enter_text(:xpath,"//input[@id='Username']","mp#{i}", "Username")
      @test.enter_text(:xpath,"//input[@id='Phone']","6122326519", "Phone")
      @test.enter_text(:xpath,"//input[@id='Password']","getswift", "Password")
      @test.enter_text(:xpath,"//input[@id='ConfirmPassword']","getswift", "Password")
      @test.click_element(:xpath,"//button[contains(text(),'Submit')]","Submit Button")
      @test.wait_till_exist(:xpath,"//span[contains(text(),'Thank you for signing up')]",5)

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
