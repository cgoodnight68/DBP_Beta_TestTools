require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb" 
require "./libraries/testlogging.rb" 

class BasicLoginDataConnect < Test::Unit::TestCase
def setup
    @test=Utilities.new
    filedir = File.expand_path File.dirname(__FILE__)
    filebase =  File.basename(__FILE__)
    @test.set_browser("ie")
    @test.setup_tasks(filedir , filebase)
     @@g_base_dir, @util, @@environment, @driver, @base_url,@@brws,@@filedir=@test.get_globals
     
  end
  
  def teardown
     @test.check_for_toaster_error_messages
         @test.teardown_tasks(passed?)
         assert_equal nil, @verification_errors
  end
  
  def test_basic_login_data_connect
    @test.login_to_data_connect()
    binding.pry
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
