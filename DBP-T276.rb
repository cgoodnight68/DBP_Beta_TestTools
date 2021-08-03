require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T276 < Test::Unit::TestCase
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

  def test_add_pickup_locations
    begin
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Pickup Locations")
      date = @test.get_date(0)
      @test.enter_text("New Location Name","Route Management> Pickup Locations","PickupLocation#{date}","New Location Name PickupLocation#{date}")
      @test.enter_text("New Address","Route Management> Pickup Locations","7546 S. Elati","New Address 7546 S. Elati")
      @test.enter_text("New City","Route Management> Pickup Locations","Littleton","New City Littleton")
      @test.select_dropdown_list_text("New State selector","Route Management> Pickup Locations","Colorado","New State Colorado")
      @test.enter_text("New Zip","Route Management> Pickup Locations","80210","New Zip 80120")
      @test.click_element("Add new pickup location","Route Management> Pickup Locations","Add new pickup location")
      @test.set_route_for_pickup_location("PickupLocation#{date}")
      @test.hack_for_resetting_the_navigation()

      @test.admin_navigate_to("Search for Customers")
      userRow = @test.search_for_customer("C")
      @test.select_dropdown_list_text("Pickup Location selector","User Management>Customers>Search for Customers>Customer Card","PickupLocation#{date}", "Selecting Pickup Location of PickupLocation#{date}")
      # @test.click_element("Save customer card","User Management>Customers>Search for Customers>Customer Card","Save customer card")
      @test.hack_for_resetting_the_navigation()
      @test.admin_navigate_to("Pickup Locations")
      @test.select_checkbox_in_row_with_value4("PickupLocation#{date}")
      @test.click_element("Delete Selected","Route Management> Pickup Locations","Delete Selected")

      @test.accept_alert()
      @test.accept_alert()




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
