require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T273 < Test::Unit::TestCase
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

  def test_create_edit_routes
    begin
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Create/Edit Routes")
      @test.enter_text("Routes (create new)","Route Management>Create/Edit Routes","DeleteThisRoute","Routes (create new)")
      @test.click_element("Submit","Route Management>Create/Edit Routes","Submit")
      routeId = @test.get_container_id("Route Container label","Route Management>Create/Edit Routes","DeleteThisRoute container header","DeleteThisRoute")

      @test.click_element("Delivery Day","Route Management>Create/Edit Routes","Delivery Day to activate the dropdown",routeId)
      @test.select_dropdown_list_text("Delivery Day select","Route Management>Create/Edit Routes","Saturday","Delivery Day select","text",routeId)
      @test.click_element("Delivery Day Save","Route Management>Create/Edit Routes","Delivery Day Save",routeId)
      @test.click_element("Cut-off","Route Management>Create/Edit Routes","Cut-off click to activate the dropdown",routeId)
      @test.select_dropdown_list_text("Cut-off Day selector","Route Management>Create/Edit Routes","1 days","Cut-off Day selector","text",routeId)
      @test.click_element("Cut-off Save","Route Management>Create/Edit Routes","Cut-off Save",routeId)
      @test.click_element("Route Container Save","Route Management>Create/Edit Routes","Route Container Save",routeId)
      @test.click_element("You have successfully updated the route","Route Management>Create/Edit Routes","You have successfully updated the route OK")
     #this is a massive hack, as after saving a new route, all the other links do not work.  We have to select one, let it fail, refresh the screen and then we can click
       @test.hack_for_resetting_the_navigation()
      
      @test.admin_navigate_to("Search for Customers")
      @test.search_for_customer("C")
      @test.click_element("Add New Route","User Management>Customers>Search for Customers>Customer Card","Add New Route")
      @test.select_dropdown_list_text("New route selector","User Management>Customers>Search for Customers>Customer Card","DeleteThisRoute","New route selector")

      @test.click_element("Save on Add new route","User Management>Customers>Search for Customers>Customer Card","Save on Add new route")
      #this is a massive hack, as after saving a new route, all the other links do not work.  We have to select one, let it fail, refresh the screen and then we can click
       @test.hack_for_resetting_the_navigation()
      @test.admin_navigate_to("Create/Edit Routes")

      @test.delete_route_named("DeleteThisRoute")

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
