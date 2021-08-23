require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T266 < Test::Unit::TestCase
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

  def test_click_on_product_categories_and_sections
    begin
       date = @test.get_date(0)
      @test.load_admin_navigation_elements
      @test.login_to_admin
      @test.admin_navigate_to("Product Categories")

      firstRowCategoryName =  @test.check_if_element_exists_get_element_text("Category name column","Products>Product Categories",10,"Category name row 1",false,"2") 
      firstRowProductsCount =  @test.check_if_element_exists_get_element_text("Products column","Products>Product Categories",10,"Products column row 1",false,"2") 
      firstRowSubCategories =  @test.check_if_element_exists_get_element_text("Subcategories column","Products>Product Categories",10,"Subcategories column row 1",false,"2") 
  
      @test.click_element("Products column","Products>Product Categories","Products column row 1","2") 
    
      numOfProducts = @test.check_if_element_exists_get_element_text("Products count","Products>Product Categories",10,"Products Count for #{firstRowCategoryName}")
      rowsOnPage = @test.get_number_of_rows_in_table("Product table rows","Products>Product Categories")

      assert(firstRowProductsCount.to_i == numOfProducts.to_i,"The number of products in the column do not match the actual number of products inside the category")
      @util.logging("There are #{numOfProducts} products the #{firstRowCategoryName} page matching the count specified in the top level categories")

      @driver.navigate.back  
      sleep(10)
      @test.click_element("Subcategories column","Products>Product Categories","Subcategories column row 1","2") 
      sleep(5)
      numSubcategories = @test.get_number_of_rows_in_table("Categories table rows","Products>Product Categories")

      assert(firstRowSubCategories.to_i == numSubcategories.to_i, "the number of subcategories #{firstRowSubCategories} do not match the actual number of subcategories #{numSubcategories} inside the category")
      @util.logging("There are #{numSubcategories} subcategories on the #{firstRowCategoryName} page matching the count specified in the top level categories")


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
