require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T263 < Test::Unit::TestCase
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

  def test_dbp_t263
    begin
       date = @test.get_date(0)
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Add New Product")
      newProduct = @test.add_new_product_for_day()

      @test.admin_navigate_to("Search for Customers")
      @test.login_as_random_customer_from_backend_with_upcoming_orders()
      @test.click_element("Search button","UserApp","Search button on user app")
      @test.enter_text("Search Text field","UserApp","#{newProduct}\n","Search Text")

      productDescription = @test.check_if_element_exists_get_element_text(:xpath,"//div[@class ='product-labeling ']",5,"Check for product description")
      assert(productDescription.include?(newProduct))
      @test.select_specific_item_from_shop_page(newProduct,1,"Next Week")
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
