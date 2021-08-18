require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T287 < Test::Unit::TestCase
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
DBP-R4
  def test_dbp_t287
    begin
      date = @test.get_date(0)
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Electronic Billing")

      paymentMethod =  @test.check_if_element_exists("Payment method selector","Billing>Billing>Electronic Billing",10,"Payment Method Selector","warn")
      if (paymentMethod != "warn")
        @test.select_dropdown_list_text("Payment method selector","Billing>Billing>Electronic Billing","Credit Card","Selecting CreditCard for the Payment Method")
      end

      @test.click_element("Search","Billing>Billing>Electronic Billing","Search")
      sleep(5)
      usersFound = @test.check_if_element_exists_get_element_text("Users found number","Billing>Billing>Electronic Billing",60,"Users found number")

      @test.verify_number_of_customers_using_credit_card_on_electronic_billing(usersFound)


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


end
