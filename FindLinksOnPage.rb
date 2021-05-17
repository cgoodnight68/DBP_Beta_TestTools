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
    @driver.manage.window.maximize
    @test.enter_text(:xpath,"//input[@id='Email']","cgoodnight+hungry@getswift.co", "Sign in Email")
    @test.enter_text(:xpath,"//input[@id='Password']","getswift", "Sign in Email")
    @test.click_element(:xpath,"//button[contains(text(),'Sign In')]","Sign in Button")

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
      if ( href != "https://dev.getswift.co/Account/Logout") && (href != "https://dev.getswift.co/SuperAdmin/Index")  && (id != "localize-active-lang") && (href != "https://localizejs.com/?utm_source=widget") && (href != "")

        pageElements[counter] = {:currentUrl => currentUrl,:href => href,:text => text,:id => id,:newUrl => "",:parent => "", :parentid => ""}
        counter = counter +1
      end
    end
    counter = 0
    # newPageElements = Array.new(elementsOnPage) {Array.new}

    pageElements.each do |pe|
      puts counter
      puts "text =#{pe[:text]}"
      puts "href = #{pe[:href]}"
      puts "id = #{pe[:id]}"
      puts "parent = #{pe[:parent]}"
      puts "parentid = #{pe[:parentid]}"
      newUrl="blank"
      clicked =0
      checkUrl = @driver.current_url
      if (checkUrl.gsub("#","") != pe[:currentUrl] ) && (pe[:currentUrl] != nil)
        @test.goto_url(pe[:currentUrl])
        puts ("was on #{checkUrl}.  Navigating to #{pe[:currentUrl]}")
      end
      # if pe[:text] == "Alerts" || pe[:text] == "Billing" ||  pe[:text] == "Integrations"
      #   sleep(10)

      # end
      if pe["href"] != nil
        newHref = pe[:href].gsub("https://dev.getswift.co","")
        #newHref = pe[1].gsub("https://dev.getswift.co","").gsub("#",""
      end

      if (pe[:parent] != "" || pe[:parent] != nil )
      	if counter == 51
      		binding.pry
      	end
        gParent = @driver.find_element(:xpath,"//a[contains(text(),'#{pe[:parent]}')]/..")
        if(pe[:parent] == "Reports" || pe[:href] == "https://dev.getswift.co/Admin/Merchants" )
          @driver.action.move_to(gParent).perform
         puts ("moving to grandparent #{pe[:parent]}")
        else
          gParent.click
        end
        puts ("clicking grandparent #{pe[:parent]}")
      elsif (pe[:parentid] != "")
        if(pe[:parentid] == "nav-burger")
          puts ("clicking the side menu for the nav burger")
          check = @driver.find_element(:id,"side-menu")
if pe[:text] == "Manage"
                		binding.pry
                	end
          if check.attribute("class") == "menu-open"
            puts("side menu open doing nothing")
            #do nothing the side menu is open
              else
                gParent = @driver.find_element(:id,"#{pe[:parentid]}")
                puts("clicking the id #{pe[:parentid]}")
                gParent.click
                sleep(20)
              end
              else
                gParent = @driver.find_element(:id,"'#{pe[:parentid]}")
                gParent.click
                puts ("clicking grandparentid #{pe[:parentid]}")
                sleep(20)
              end
            end
            if (newHref != "/Account/Logout") && (newHref != "/Admin/Index/")
              parent =""
              if (pe[:text] != "") && (pe[:text] != "Unknown")
                if pe[:href] =="https://dev.getswift.co/SuperAdmin/Index/"
                  binding.pry
                end
                parent = @driver.find_element(:xpath,"//a[contains(text(),'#{pe[:text]}')]/..")
                if (pe[:parentid] == "nav-burger")
                  parent = @driver.find_element(:xpath,"//a[contains(text(),'#{pe[:text]}')]")
                end
                if(pe[:text] == "Reports" || pe[:href] == "https://dev.getswift.co/Admin/Merchants") 
                  @driver.action.move_to(parent).perform
                  puts ("moving to parent text #{pe[:text]}")
                #  binding.pry
                else
                	if pe[:text] == "Manage"
                		binding.pry
                		parent = @driver.find_element(:xpath,"//a[contains(@href,'#{pe[:href].gsub("https://dev.getswift.co","")}')]")
                	    @test.goto_url(pe[:href])   
                	     
                     end
                 
                end
                clicked = 1
                
              elsif (pe[:id] != "")
                parent = @driver.find_element(:id,"#{pe[:id]}")
                parent.click
                puts ("clicking parent id #{pe[:id]}")
                clicked =1
              else
                #  parent = @driver.find_element(:xpath,"//a[contains(@href,'#{newHref}')]")
                #  parent.click
              end

              # @test.click_element

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
                puts ("child elements found = #{childElements.count}")
                if childElements.count == 0
                  puts ("No child elements, sleeping for 30")
                  sleep(30)
                  childElements  =  parent.find_elements(:xpath,".//child::a")
                end
                puts ("finding children of text #{pe[:text]} or id #{pe[:id]} ")
                childcounter =0
                childElements.each do |childEl|

                  #m = pageElements.find {|masterElement| masterElement[:href] == childEl.attribute("href") }
                  #m[:text]  = childEl.text
                  #m[:parent] = pe[:text]
                  #puts ("m = #{m}")
                  if (childcounter > 0   &&  (childEl.attribute("href") != "https://dev.getswift.co/Account/Logout"))  || (pe[:id] == "nav-burger" )# don't count the parent
                    update = pageElements.find {|x| ((x[:href] == childEl.attribute("href") ) && (x[:text] =="")) }
                    childText = ""
                    puts ("child href = #{childEl.attribute("href")}")
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

                    # pageElements[counter+childcounter][:text] = childEl.text
                    # pageElements[counter+childcounter][:parent] =  pageElements[counter][:text]
                    # pageElements[counter+childcounter][:parentid] =  pageElements[counter][:id]
                  end

                  if childcounter == 1
                    # binding.pry
                  end

                  childcounter = childcounter +1
                end
              elsif rl = @driver.current_url
                if (newUrl.gsub("#","") != pe[:currentUrl])
                  pe[:newUrl] = newUrl
                end
              else
              end
              if pe[:id] == "nav-burger"
                #binding.pry
              end
              if clicked ==1
                sleep(10)
                puts ("navigating back")
                @driver.navigate.back()
                sleep(10)

              end
              #newPageElements[counter].push(pe["currentUrl"],pe["href"],pe["text"],newUrl)
            end
            counter = counter +1
          end
          file = File.open("./LinksOnDev.csv","w")
          file.write("ParentUrl, href,text,id, DestinationUrl ,ParentText, ParentId\n")
          pageElements.each do |pe|
            file.write("#{pe[:currentUrl]}, #{pe[:href]},#{pe[:text]},#{pe[:id]}, #{pe[:newUrl]} ,#{pe[:parent]}, #{pe[:parentid]}\n")
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
