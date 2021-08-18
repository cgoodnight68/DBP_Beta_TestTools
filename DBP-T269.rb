require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T269< Test::Unit::TestCase
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

  def test_product_dislikes
    @test.load_admin_navigation_elements
    @test.login_to_admin
    @test.admin_navigate_to("Product Dislikes")
    @test.enter_text("Add new item input","Products>Product Dislikes","DislikedProduct", "Entering DislikedProduct into add new item text box")
    @test.click_element("Add","Products>Product Dislikes","Add")


    @test.admin_navigate_to("Search for Customers")
    @test.search_for_customer("C")
    @test.select_dropdown_list_text("Disliked Products select","User Management>Customers>Search for Customers>Customer Card","DislikedProduct","DislikedProduct from disliked products")
    @test.click_element("Likes and Dislikes Save","User Management>Customers>Search for Customers>Customer Card","Save on likes and dislikes")
    @test.click_element("OK on settings saved","User Management>Customers>Search for Customers>Customer Card","OK on settings saved")

    sleep(2)
    #this is a massive hack, as after saving a disliked product, all the other links do not work.  We have to select one, let it fail, refresh the screen and then we can click
    @test.hack_for_resetting_the_navigation()

    @test.admin_navigate_to("Product Dislikes")
    @test.select_checkbox_in_row_with_value("DislikedProduct")
    @test.click_element("Delete Selected","Products>Product Dislikes","Delete Selected")
    @test.click_element("Ok on Are you sure","Products>Product Dislikes","Ok on Are you sure")



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
