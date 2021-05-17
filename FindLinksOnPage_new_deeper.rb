require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class FindLinksOnPage < Test::Unit::TestCase
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

  def test_find_links_on_page
    @test.goto_url(@base_url)
    #@test.goto_url("https://dev.zipixy.com/")

  #@test.goto_url("https://staging.zipixy.com/")
    @driver.manage.window.maximize
    @test.enter_text(:xpath,"//input[@id='Email']","DefaultMerchantQA2020-09-29@mailinator.com", "Sign in Email")
   # @test.enter_text(:xpath,"//input[@id='Email']","cgoodnight+hungry@getswift.co", "Sign in Email")
    @test.enter_text(:xpath,"//input[@id='Password']","getswift", "Sign in Email")
    @test.click_element(:xpath,"//button[contains(text(),'Sign In')]","Sign in Button")
    pageElements = Array.new {Hash.new}
    pageElements = (find_all_links_on_page).map(&:clone)
   
    counter = 0
    # newPageElements = Array.new(elementsOnPage) {Array.new}

    pageElements.each do |pe|
      @util.logging("#{counter}")
      @util.logging("text =#{pe[:text]}")
      @util.logging("href = #{pe[:href]}")
      @util.logging("id = #{pe[:id]}")
      @util.logging("parent = #{pe[:parent]}")
      @util.logging("parentid = #{pe[:parentid]}")
      newUrl="blank"
      clicked =0
      checkUrl = @driver.current_url
      if (checkUrl.gsub("#","") != pe[:currentUrl] ) && (pe[:currentUrl] != nil)
        @test.goto_url(pe[:currentUrl])
        @util.logging("was on #{checkUrl}.  Navigating to #{pe[:currentUrl]}")
      end

      click_parent_text(pe)
      click_parent_id(pe)
      if (pe[:href] != "" ) && (pe[:href] != nil)
        newHref = pe[:href].gsub("https://dev.getswift.co","")
      end
      if (newHref != "/Account/Logout") && (newHref != "/Admin/Index/")
       if counter != 39
        parent,clicked = click_on_element(pe)
       else
       	 binding.pry
       	end
        if clicked ==1 
  			pe[:checked] = "true"	
        end
        newUrl = @driver.current_url
        if (newUrl.gsub("#","") != pe[:currentUrl])
          pe[:newUrl] = newUrl
           @test.take_snapshot(pe[:text])
           error = @driver.manage.logs.get(:browser)
           @util.logging("Page loaded with the following error\n #{error}")
           pe[:errors] = "#{error}"
        end
      end
      #binding.pry
      newUrl = @driver.current_url
      if (newUrl.gsub("#","") == pe[:currentUrl]) && (clicked == 1)
        if pe[:id] == "nav-burger"
          parent = @driver.find_element(:id,"side-menu")
        end

        childElements  =  parent.find_elements(:xpath,".//child::a")
        childElementsParent  =  parent.find_elements(:xpath,".//child::a/..")
        # if pe[:id] == "nav-burger"
        # 	binding.pry
        # end
        @util.logging("child elements found = #{childElements.count}")
        if childElements.count == 0
          @util.logging("No child elements, sleeping for 30")
          sleep(30)
          childElements  =  parent.find_elements(:xpath,".//child::a")
        end
        @util.logging("finding children of text #{pe[:text]} or id #{pe[:id]} ")
        childcounter =0
        childElements.each do |childEl|

          #m = pageElements.find {|masterElement| masterElement[:href] == childEl.attribute("href") }
          #m[:text]  = childEl.text
          #m[:parent] = pe[:text]
          #@util.logging("m = #{m}")
          if (childcounter > 0   &&  (childEl.attribute("href") != "https://dev.getswift.co/Account/Logout"))  || (pe[:id] == "nav-burger" )# don't count the parent
            update = pageElements.find {|x| ((x[:href] == childEl.attribute("href") ) && (x[:text] =="")) }
            childText = ""
            @util.logging("child href = #{childEl.attribute("href")}")
            if childEl.text == ""
              if childElementsParent.count >1
                childText = ""
              else
                childText = childElementsParent.text
              end
            else
              childText =  childEl.text
            end

            if update
              update[:text] = childText
              update[:parent] = pageElements[counter][:text]
              update[:parentid] = pageElements[counter][:id]
            end


          end



          childcounter = childcounter +1
        end
        # elsif rl = @driver.current_url
        newUrl = @driver.current_url
        if (newUrl.gsub("#","") != pe[:currentUrl])
          pe[:newUrl] = newUrl
        end
        # else
        # end

        if clicked ==1
          sleep(10)
          @util.logging("navigating back")
          @driver.navigate.back()
          sleep(10)

        end
      end
      counter = counter +1

    end
    

     pageElements.each do |pe_url|
     	if (pe_url[:newUrl] != "") &&  (pe_url[:checked] == 'true')
               @test.goto_url(pe_url[:newUrl])
                tempPageElements = find_all_links_on_page.map(&:clone)
                add_new_links(pageElements,tempPageElements)
     	end

     end


    file = File.open("./LinksOnDev.csv","w")
    file.write("ParentUrl, href,text,id, DestinationUrl ,ParentText, ParentId,Checked\n")
    pageElements.each do |pe|
      file.write("#{pe[:currentUrl]}, #{pe[:href]},#{pe[:text]},#{pe[:id]}, #{pe[:newUrl]} ,#{pe[:parent]}, #{pe[:parentid]}, #{pe[:checked]}, #{pe[:errors]}\n")
    end
    file.close
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

def click_parent_text(pe)
  if (pe[:parent] != "" &&
      pe[:parent] != nil )
    gParent = @driver.find_element(:xpath,"//a[contains(text(),'#{pe[:parent]}')]/..")
    if(pe[:parent] == "Reports" || pe[:href] == "https://dev.getswift.co/Admin/Merchants" )
      @driver.action.move_to(gParent).perform
      @util.logging("moving to parent #{pe[:parent]}")
    else
      gParent.click
      @util.logging("clicking parent #{pe[:parent]}")
    end
  end
end
def click_parent_id(pe)
  if (pe[:parentid] != "" && pe[:parentid] != nil)
    if(pe[:parentid] == "nav-burger")
      @util.logging("clicking the side menu for the nav burger")
      check = @driver.find_element(:id,"side-menu")
      if check.attribute("class") == "menu-open"
        @util.logging("side menu open doing nothing")
        #do nothing the side menu is open
          else

            gParent = @driver.find_element(:id,"#{pe[:parentid]}")
            @util.logging("clicking the parentid #{pe[:parentid]}")
            gParent.click
            sleep(20)
          end
          else
            gParent = @driver.find_element(:id,"'#{pe[:parentid]}")
            gParent.click
            @util.logging("clicking parentid #{pe[:parentid]}")
            sleep(20)
          end
        end
      end
      def click_on_element(pe)
        if pe["href"] != nil
          newHref = pe[:href].gsub("https://dev.getswift.co","")
          #newHref = pe[1].gsub("https://dev.getswift.co","").gsub("#",""
        end
        if (pe[:text] != "") && (pe[:text] != "Unknown")
          element = @driver.find_element(:xpath,"//a[contains(text(),'#{pe[:text]}')]/..")
          if(pe[:text] == "Reports" || pe[:href] == "https://dev.getswift.co/Admin/Merchants")
            @driver.action.move_to(element).perform
            @util.logging("moving to element text #{pe[:text]}")
            return element,1
          elsif pe[:parentid] == "nav-burger"

           # parent = @driver.find_element(:xpath,"//a[contains(@href,'#{pe[:href].gsub("https://dev.getswift.co","")}')]")
            @test.goto_url(pe[:href])
            return element,1
          else
            element.click
            @util.logging("clicking on element text #{pe[:text]}")
            return element,1

          end
        elsif pe[:id] != ""
          element = @driver.find_element(:id,"#{pe[:id]}")
          element.click
          @util.logging("clicking element id #{pe[:id]}")
          return element,1
          # elsif pe[:href] != ""
          #   element = @driver.find_element(:xpath,"//a[contains(@href,'#{pe[:href].gsub("https://dev.getswift.co","")}')]")
          #   element.click
          #   @util.logging("clicking element href #{pe[:href]}")
          #   return element,1
        else
          @util.logging("No method for clicking on element")
          return nil,0
        end
      end

      def child
        if pe[:id] == "nav-burger"
          parent = @driver.find_element(:id,"side-menu")
        end

        childElements  =  parent.find_elements(:xpath,".//child::a")
        childElementsParent  =  parent.find_elements(:xpath,".//child::a/..")
        # if pe[:id] == "nav-burger"
        # 	binding.pry
        # end
        @util.logging("child elements found = #{childElements.count}")
        if childElements.count == 0
          @util.logging("No child elements, sleeping for 30")
          sleep(30)
          childElements  =  parent.find_elements(:xpath,".//child::a")
        end
        @util.logging("finding children of text #{pe[:text]} or id #{pe[:id]} ")
        childcounter =0
        childElements.each do |childEl|

          #m = pageElements.find {|masterElement| masterElement[:href] == childEl.attribute("href") }
          #m[:text]  = childEl.text
          #m[:parent] = pe[:text]
          #@util.logging("m = #{m}")
          if (childcounter > 0   &&  (childEl.attribute("href") != "https://dev.getswift.co/Account/Logout"))  || (pe[:id] == "nav-burger" )# don't count the parent
            update = pageElements.find {|x| ((x[:href] == childEl.attribute("href") ) && (x[:text] =="")) }
            childText = ""
            @util.logging("child href = #{childEl.attribute("href")}")
            if childEl.text == ""
              if childElementsParent.count >1
                childText = ""
              else
                childText = childElementsParent.text
              end
            else
              childText =  childEl.text
            end

            if update
              update[:text] = childText
              update[:parent] = pageElements[counter][:text]
              update[:parentid] = pageElements[counter][:id]
            end


          end



          childcounter = childcounter +1
        end
        # elsif rl = @driver.current_url
        #   if (newUrl.gsub("#","") != pe[:currentUrl])
        #     pe[:newUrl] = newUrl
        #   end
        # else
        # end

        if clicked ==1
          sleep(10)
          @util.logging("navigating back")
          @driver.navigate.back()
          sleep(10)

        end
        #newPageElements[counter].push(pe["currentUrl"],pe["href"],pe["text"],newUrl)
      end
  def find_all_links_on_page
  	elements = @driver.find_elements(:xpath,"//a")
    elementsOnPage = elements.count
    pageElements = Array.new(elementsOnPage) {Hash.new}
    currentUrl = @driver.current_url
    counter = 0
    elements.each do |el|

      text = el.text
      href = el.attribute("href")
      id  = el.attribute("id")

      #  el.click
      #result = @test.highlight(:id,id,5)
      # newUrl = @driver.current_url
      # @driver.navigate.back()
      # pageElements[0] = {:currentUrl => "", :href => "" ,:text => "" ,:newUrl => "",:parent => ""}
      if ( href != "https://dev.getswift.co/Account/Logout") && (href != "https://dev.getswift.co/SuperAdmin/Index")  && (id != "localize-active-lang") && (href != "https://localizejs.com/?utm_source=widget") && (href != "")  && (href != nil)
        pageElements[counter] = {:currentUrl => currentUrl,:href => href,:text => text,:id => id,:newUrl => "",:parent => "", :parentid => "",:checked =>"false",:errors =>""}
        counter = counter +1
      end
    end
    return pageElements
  end
  def add_new_links(pageElements,tempPageElements)
     tempPageElements.each do |tpe|
      exist = pageElements.find {|x| (x[:href] == tpe[:href] ) }
      if exist == nil
             pageElements.push(tpe) 
      end
     end
  end

