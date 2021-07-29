require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T203 < Test::Unit::TestCase
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

  def test_sales_change_dropdown_options
    begin
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Dashboard")
      @test.click_element("Sales tab","Navigation>Dashboard","Sales tab")
      @test.select_dropdown_list_text("Sales graph timeframe selector","Navigation>Dashboard","This Week Vs Last Week","Sales graph timeframe selector -This Week vs Last Week")
      legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      legend2Text =  @test.check_if_element_exists_get_element_text("Sales Chart legend 2","Navigation>Dashboard",10,"Sales Chart legend 2")
      assert((legend1Text == "This Week"))
      assert((legend2Text == "Last Week"))
      @test.select_dropdown_list_text("Sales graph timeframe selector","Navigation>Dashboard","This Month Vs Last Month","Sales graph timeframe selector -This Month vs Last Month")
      legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      legend2Text =  @test.check_if_element_exists_get_element_text("Sales Chart legend 2","Navigation>Dashboard",10,"Sales Chart legend 2")
      assert((legend1Text == "This Month"))
      assert((legend2Text == "Last Month"))
      @test.select_dropdown_list_text("Sales graph timeframe selector","Navigation>Dashboard","This Year Vs Last Year","Sales graph timeframe selector -This Year vs Last Year")
      legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      legend2Text =  @test.check_if_element_exists_get_element_text("Sales Chart legend 2","Navigation>Dashboard",10,"Sales Chart legend 2")
      assert((legend1Text == "This Year"))
      assert((legend2Text == "Last Year"))
      @test.select_dropdown_list_text("Sales graph timeframe selector","Navigation>Dashboard","Last Week","Sales graph timeframe selector -Last Week")
      legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      assert((legend1Text == "Last Week"))
      @test.select_dropdown_list_text("Sales graph timeframe selector","Navigation>Dashboard","Last 7 Days","Sales graph timeframe selector -Last 7 Days")
      legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      assert((legend1Text == "Last 7 Days"))
      @test.select_dropdown_list_text("Sales graph timeframe selector","Navigation>Dashboard","Last Month","Sales graph timeframe selector -Last Month")
      legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      assert((legend1Text == "Last Month"))
      @test.select_dropdown_list_text("Sales graph timeframe selector","Navigation>Dashboard","Last 30 Days","Sales graph timeframe selector -Last 30 Days")
      legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      assert((legend1Text == "Last 30 Days"))
      @test.select_dropdown_list_text("Sales graph timeframe selector","Navigation>Dashboard","Year To Date","Sales graph timeframe selector - Year To Date")
      legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      assert((legend1Text == "Year To Date"))


#all turned off becauze of problems with the span showing in the select
      # @test.click_element("Recurring Sales tab","Navigation>Dashboard","Recurring Sales tab")
      # @test.select_dropdown_list_text("Recurring Sales time selector","Navigation>Dashboard","All","Recurring Sales time selector -All")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # assert((legend1Text == "All"))
      # @test.select_dropdown_list_text("Recurring Sales time selector","Navigation>Dashboard","Weekly","Recurring Sales time selector Weekly")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # assert((legend1Text == "Weekly"))
      # @test.select_dropdown_list_text("Recurring Sales time selector","Navigation>Dashboard","Every Other Week","Recurring Sales time selector -Every Other Week")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # assert((legend1Text == "Other Week"))
      # @test.select_dropdown_list_text("Recurring Sales time selector","Navigation>Dashboard","Monthly","Recurring Sales time selector -Monthly")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # assert((legend1Text == "Monthly"))


      # @test.click_element("Deposit Charges tab","Navigation>Dashboard","Deposit Charges tab")
      # @test.select_dropdown_list_text("Deposit Charges timeframe selector","Navigation>Dashboard","This Week Vs Last Week"," Deposit Charges timeframe selector -This Week vs Last Week")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # legend2Text =  @test.check_if_element_exists_get_element_text("Sales Chart legend 2","Navigation>Dashboard",10,"Sales Chart legend 2")
      # assert((legend1Text == "This Week"))
      # assert((legend2Text == "Last Week"))
      # @test.select_dropdown_list_text("Deposit Charges timeframe selector","Navigation>Dashboard","This Month Vs Last Month","Deposit Charges timeframe selector -This Month vs Last Month")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # legend2Text =  @test.check_if_element_exists_get_element_text("Sales Chart legend 2","Navigation>Dashboard",10,"Sales Chart legend 2")
      # assert((legend1Text == "This Month"))
      # assert((legend2Text == "Last Month"))
      # @test.select_dropdown_list_text("Deposit Charges timeframe selector","Navigation>Dashboard","This Year Vs Last Year","Deposit Charges timeframe selector -This Year vs Last Year")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # legend2Text =  @test.check_if_element_exists_get_element_text("Sales Chart legend 2","Navigation>Dashboard",10,"Sales Chart legend 2")
      # assert((legend1Text == "This Year"))
      # assert((legend2Text == "Last Year"))
      # @test.select_dropdown_list_text("Deposit Charges timeframe selector","Navigation>Dashboard","Last Week","Deposit Charges timeframe selector -Last Week")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # assert((legend1Text == "Last Week"))
      # @test.select_dropdown_list_text("Deposit Charges timeframe selector","Navigation>Dashboard","Last 7 Days","Deposit Charges timeframe selector -Last 7 Days")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # assert((legend1Text == "Last 7 Days"))
      # @test.select_dropdown_list_text("Deposit Charges timeframe selector","Navigation>Dashboard","Last Month","Deposit Charges timeframe selector-Last Month")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # assert((legend1Text == "Last Month"))
      # @test.select_dropdown_list_text("Deposit Charges timeframe selector","Navigation>Dashboard","Last 30 Days","Deposit Charges timeframe selector -Last 30 Days")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # assert((legend1Text == "Last 30 Days"))
      # @test.select_dropdown_list_text("Deposit Charges timeframe selector","Navigation>Dashboard","Year To Date","Deposit Charges timeframe selectorr - Year To Date")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # assert((legend1Text == "Year To Date"))

      # @test.click_element("Delivery Charges tab","Navigation>Dashboard","Sales tab")
      # @test.select_dropdown_list_text("SDelivery Charges timeframe selector","Navigation>Dashboard","This Week Vs Last Week","Delivery Charges timeframe selector -This Week vs Last Week")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # legend2Text =  @test.check_if_element_exists_get_element_text("Sales Chart legend 2","Navigation>Dashboard",10,"Sales Chart legend 2")
      # assert((legend1Text == "This Week"))
      # assert((legend2Text == "Last Week"))
      # @test.select_dropdown_list_text("Delivery Charges timeframe selector","Navigation>Dashboard","This Month Vs Last Month","Delivery Charges timeframe selector -This Month vs Last Month")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # legend2Text =  @test.check_if_element_exists_get_element_text("Sales Chart legend 2","Navigation>Dashboard",10,"Sales Chart legend 2")
      # assert((legend1Text == "This Month"))
      # assert((legend2Text == "Last Month"))
      # @test.select_dropdown_list_text("Delivery Charges timeframe selector","Navigation>Dashboard","This Year Vs Last Year","Delivery Charges timeframe selector -This Year vs Last Year")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")
      # legend2Text =  @test.check_if_element_exists_get_element_text("Sales Chart legend 2","Navigation>Dashboard",10,"Sales Chart legend 2")
      # assert((legend1Text == "This Year"))
      # assert((legend2Text == "Last Year"))

      # @test.select_dropdown_list_text("Delivery Charges timeframe selector","Navigation>Dashboard","Last Week","Delivery Charges timeframe selector -Last Week")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")

      # assert((legend1Text == "Last Week"))
      # @test.select_dropdown_list_text("Delivery Charges timeframe selector","Navigation>Dashboard","Last 7 Days","Delivery Charges timeframe selector -Last 7 Days")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")

      # assert((legend1Text == "Last 7 Days"))

      # @test.select_dropdown_list_text("Delivery Charges timeframe selector","Navigation>Dashboard","Last Month","Delivery Charges timeframe selector -Last Month")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")

      # assert((legend1Text == "Last Month"))

      # @test.select_dropdown_list_text("Delivery Charges timeframe selector","Navigation>Dashboard","Last 30 Days","Delivery Charges timeframe selector -Last 30 Days")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")

      # assert((legend1Text == "Last 30 Days"))

      # @test.select_dropdown_list_text("Delivery Charges timeframe selector","Navigation>Dashboard","Year To Date","Delivery Charges timeframe selector - Year To Date")
      # legend1Text = @test.check_if_element_exists_get_element_text("Sales Chart legend 1","Navigation>Dashboard",10,"Sales Chart legend 1")

      # assert((legend1Text == "Year To Date"))



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
