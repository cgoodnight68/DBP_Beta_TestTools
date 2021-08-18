require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T292 < Test::Unit::TestCase
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

  def test_gift_certificate_special_tags  
    begin
      @test.load_admin_navigation_elements
      @test.login_to_admin
      date = @test.get_date(0)
      @test.admin_navigate_to("Autoresponders")
      @test.click_element("Add New","Customer Communication>Autoresponders","Add New")
      @test.enter_text("Subject","Customer Communication>Autoresponders>Add New","Autoresponder#{date}", "Subject set to 'Autoresponder#{date}'")
      @test.select_dropdown_list_text("Autoresponse type selector","Customer Communication>Autoresponders>Add New","Gift Certificate Email (to recipient)","Autoresponse type selector set to Gift Certificate Email (to recipient)")

      @test.send_text_to_autoresponder_body( "This is a short description of  the Autoresponder for #{date}" )

      @test.click_element("Save","Customer Communication>Autoresponders>Add New","Save")

      @test.click_element("Body frame","Customer Communication>Autoresponders>Add New","Body of the message")

     specialTags = @test.get_all_special_tags()
    
      @test.click_element("Delete","Customer Communication>Autoresponders>Add New","Delete the autoresponder")
      @test.click_element("Are you sure you want to delete this message OK","Customer Communication>Autoresponders>Add New","Are you sure you want to delete this message OK") 

      assert(specialTags.include?("-- Gift Certificate --"),"-- Gift Certificate -- not found")
      @util.logging("-- Gift Certificate -- found in the special tags")
 


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
