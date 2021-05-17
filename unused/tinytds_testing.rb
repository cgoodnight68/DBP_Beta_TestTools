require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class TinyTDS < Test::Unit::TestCase
  def setup
    @test=Utilities.new
    filedir = File.expand_path File.dirname(__FILE__)
    filebase =  File.basename(__FILE__)
    @test.setup_tasks(filedir , filebase,true)
    @@g_base_dir, @util, @@environment, @driver, @base_url,@@brws,@@filedir=@test.get_globals

  end

  def teardown
     @test.check_for_toaster_error_messages
         @test.teardown_tasks(passed?)
         assert_equal nil, @verification_errors
  end

  def test_tinytds_test
    @@sqlDB_host="ami-qa-symphony.database.windows.net"
    @@sqlDB_master="qa-symphony-master"
    @@sqlDB_tenant="qa-symphony-tenant"
    @@sqlUser ="qaadmin"
    @@sqlPassword ="Secret2121$"
    client = TinyTds::Client.new username: 'qaadmin', password: 'Secret2121$', dataserver: 'ami-qa-symphony.database.windows.net', database: 'qa-symphony-master' , azure 'true'
    connected = client.active?
    puts "#{connected}"
    result = client.execute("select top 1 CustomerName from M_Customer;")
    result.each do |row|
     puts row['CustomerName']
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
  def close_alert_and_get_its_text
    alert =@driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
