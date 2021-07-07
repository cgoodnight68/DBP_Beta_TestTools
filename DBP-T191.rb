require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_191 < Test::Unit::TestCase
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

  def test_dbp_191
    begin
      @test.load_admin_navigation_elements
      username,password = @test.get_default_user_for_day
      @test.login_as_customer(username,password)
      @test.click_element("My Account","UserApp","My Account in Header")

      @test.click_element("Account Info","UserApp>MyAccount","Account Info")
      @test.click_element("Change Password","UserApp>MyAccount>AccountInfo","Change Password")
      @test.enter_text("Current Password","UserApp>MyAccount>AccountInfo","getswift","Current Password")
      @test.enter_text("New Password","UserApp>MyAccount>AccountInfo","getswift2","New Password")
      @test.enter_text("Confirm Password","UserApp>MyAccount>AccountInfo","getswift2","Confirm Password")
      @test.click_element("Update","UserApp>MyAccount>AccountInfo","Update")
      
      @test.click_element("Your changes have been saved, OK button","UserApp>MyAccount>AccountInfo","our changes have been saved, OK button")
      sleep(5)
      @test.click_element("Logout","UserApp","Logout")
      sleep(2)

      @test.click_element("Logout OK","UserApp","Ok on logout")

      @test.login_as_customer(username,"getswift2")
      @test.click_element("My Account","UserApp","My Account in Header")

      @test.click_element("Account Info","UserApp>MyAccount","Account Info")
      @test.click_element("Change Password","UserApp>MyAccount>AccountInfo","Change Password")
      @test.enter_text("Current Password","UserApp>MyAccount>AccountInfo","getswift2","Current Password")
      @test.enter_text("New Password","UserApp>MyAccount>AccountInfo","getswift","New Password")
      @test.enter_text("Confirm Password","UserApp>MyAccount>AccountInfo","getswift","Confirm Password")
      @test.click_element("Update","UserApp>MyAccount>AccountInfo","Update")

      @test.click_element("Your changes have been saved, OK button","UserApp>MyAccount>AccountInfo","our changes have been saved, OK button")
     
      




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
