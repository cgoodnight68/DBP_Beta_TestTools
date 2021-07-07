require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T178 < Test::Unit::TestCase
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

  def test_dbp_t178
    begin
      @test.load_admin_navigation_elements
      @test.goto_url("#{@base_url}/register.php?step=first&viewing_step=first")
      @test.enter_text("Address","UserApp>Register", "3211 Providence Dr, Anchorage, AK 99508\n","Address")
     # @test.click_element("Continue","UserApp>Register","Continue button")
      @test.check_if_element_exists_get_element_text("We don't deliver","UserApp>Store",10,"We don't deliver modal window")
      
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
