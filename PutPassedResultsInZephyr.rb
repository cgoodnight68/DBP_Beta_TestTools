require "pry"
require "HTTParty"
require "net/http"
require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"

class DBP_T170 < Test::Unit::TestCase
  def setup
    @test=Utilities.new
    filedir = File.expand_path File.dirname(__FILE__)
    filebase =  File.basename(__FILE__)
    #  @test.setup_tasks(filedir , filebase)
    @@g_base_dir, @util, @@environment, @driver, @base_url,@@brws,@@filedir=@test.get_globals

  end

  def teardown
  #  @test.teardown_tasks(passed?)
  #  assert_equal nil, @verification_errors
  end

  def test_copy_dbp_pass_results_to_zephyr
    begin
      print("Enter the base url (i.e. integration.deliverybizpro.com)\n>")
      base_url =  gets.chomp

      print("Enter the Zephyr Scale Cycle ID (ie. DBP-R59)\n>")
      cycleId=  gets.chomp
      date =  Time.now.strftime("%Y-%m-%d")


      client = PG::Connection.open(:dbname => 'Automation', :host => '54.201.168.175', :user => 'postgres', :password =>'getswift' )
      newQuery = "select * from results  where branch = '#{base_url}' and status = 'Passed' and date_run >'#{date}';"
      results = client.exec(newQuery)
    
   
      results.each do |result|
    
        status =""
        if result["status"].strip =="Passed"
          status = "Pass"
        elsif  result["status"].strip =="Failed"
          status = "Fail"
        end
      
        currentExecutionReportLink = "http://ec2-54-201-168-175.us-west-2.compute.amazonaws.com/specifictest?#{result["id"]}"
        url = URI("https://api.adaptavist.io/tm4j/v2/testexecutions")

        https = Net::HTTP.new(url.host, url.port);
        https.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = "application/json"
        request["Authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI5MmE3ZGRjNS00ZDliLTNiNTEtYTI2Ni03YWYyYWU5YWRkZTciLCJjb250ZXh0Ijp7ImJhc2VVcmwiOiJodHRwczpcL1wvZ2V0c3dpZnQuYXRsYXNzaWFuLm5ldCIsInVzZXIiOnsiYWNjb3VudElkIjoiNWQ5MjBkMjFkODc5NGMwZDg4MjcwOGZjIn19LCJpc3MiOiJjb20ua2Fub2FoLnRlc3QtbWFuYWdlciIsImV4cCI6MTY0MDM2MjIzNiwiaWF0IjoxNjA4ODI2MjM2fQ.gvEq1vJo6XlT-Z_nkR0aoBOK61XQLAUN7Z9oJ8-e6X4"

        # request.body = "{\n  \"apiKey\": \"#{lineHash["apiKey"]}\",\n  \"booking\": {\n    \"deliveryInstructions\": \"Handle with care\",\n    \"itemsRequirePurchase\": false,\n    \"items\": [\n  \n    ],\n    \"pickupTime\": \"#{lineHash["arrival"]}\",\n    \"pickupDetail\": {\n      \"name\": \"#{lineHash["jobId"]}\",\n      \"phone\": \"+61408399111\",\n      \"address\": \"#{lineHash["pickupLat"]},#{lineHash["pickupLong"]} \",\n      \"additionalAddressDetails\":{  \n            \"latitude\":#{lineHash["pickupLat"]},\n            \"longitude\":#{lineHash["pickupLong"]}\n         }\n    },\n    \"dropoffDetail\": {\n      \"name\": \"#{lineHash["jobId"]} Dropoff\",\n      \"phone\": \"+61408399111\",\n      \"address\": \"#{lineHash["dropoffLat"]},#{lineHash["dropoffLong"]} \",\n       \"additionalAddressDetails\":{  \n            \"latitude\":#{lineHash["dropoffLat"]},\n            \"longitude\":#{lineHash["dropoffLong"]},\n         }\n    },\n     \"dropoffWindow\":{  \n         \"EarliestTime\":\"#{lineHash["arrival"]}\",\n         \"LatestTime\":\"#{lineHash["dropoffLatestArrival"]}\"\n      },\n\n  }\n}"
       #request.body ="  {\n    \"projectKey\": \"DBP\",\n \"testCaseKey\": \"#{result["test_name"]}\",\n \"testCycleKey\": \"#{cycleId}\",\n \"statusName\": \"#{status}\",\n \"executedById\": \"5d920d21d8794c0d882708fc\",\n \"assignedToId\": \"5d920d21d8794c0d882708fc\",\n \"comment\": \"<a href=\\\\#{currentExecutionReportLink}\\\">Test case report for  #{result["test_name"]} </a>\" ,\"environmentName\": \"#{result["environment"]}\"\n}"
       # request.body ="  {\n    \"projectKey\": \"DBP\",\n" +
       #    "\"testCaseKey\": \"#{result["test_name"]}\",\n" +
       #    "\"testCycleKey\": \"#{cycleId}\",\n" +
       #    "\"statusName\": \"#{status}\",\n" +
       #    "\"executedById\": \"5d920d21d8794c0d882708fc\",\n" +
       #    "\"assignedToId\": \"5d920d21d8794c0d882708fc\",\n" +
       #    "\"comment\": \"<a href=\\\"#{currentExecutionReportLink}"\\\">Test case report for  #{result["test_name"]} </a>\"," +
       #    "\"environmentName\": \"#{result["environment"]}\"\n}"
        testName = result["test_name"].gsub('.rb','')
        #  request.body = %q({ 
        #   "projectKey": "DBP",
        #   "testCaseKey": "#{testName}",
        #   "testCycleKey": "#{cycleId}",
        #   "statusName": "#{status}",
        #   "executedById": "5d920d21d8794c0d882708fc",
        #   "assignedToId": "5d920d21d8794c0d882708fc",
        #   "comment": "<a href=\"#{currentExecutionReportLink}\">Test case report for  #{result["test_name"]} </a>"
        # }) 

        #   value = %q({ 
        #   "projectKey": "DBP",
        #   "testCaseKey": "#{testName}",
        #   "testCycleKey": "#{cycleId}",
        #   "statusName": "#{status}",
        #   "executedById": "5d920d21d8794c0d882708fc",
        #   "assignedToId": "5d920d21d8794c0d882708fc",
        #   "comment": "<a href=\"#{currentExecutionReportLink}\">Test case report for  #{result["test_name"]} </a>"
        # }) 

#         request.body =%q({ 
# "projectKey": "DBP",
# "testCaseKey": "DBP-T242",
# "testCycleKey": "DBP-R74",
# "statusName": "Fail",
# "executedById": "5d920d21d8794c0d882708fc",
# "assignedToId": "5d920d21d8794c0d882708fc",
# "comment": "<a href=\"http://ec2-54-201-168-175.us-west-2.compute.amazonaws.com/specifictest?62180\">Test case report for  DBP-T242.rb </a>"
#   })


        request.body = build_request(testName,cycleId,status,result["id"]).gsub('\"','"')
    
        response = https.request(request)
        puts("#{testName} ---#{response.body}")

    
       
      end
    rescue => e
      puts("V______FAILURE!!! Previous line failed. Trace below. __________V")
      puts(e.inspect)
      errortrace = e.backtrace
      size = errortrace.size
      for i in 0..size
        errortraceString = "#{errortraceString}\n #{errortrace[i]}"
      end
      puts(errortraceString)
      throw e
    end
  end
def build_request(testName,cycleId,status,id)
  return (<<~EMAIL)
   {
    "projectKey": "DBP",
    "testCaseKey": "#{testName}",
    "testCycleKey": "#{cycleId}",
    "statusName": "#{status}",
    "executedById": "5d920d21d8794c0d882708fc",
    "assignedToId": "5d920d21d8794c0d882708fc",
    "comment": "<a href='http://ec2-54-201-168-175.us-west-2.compute.amazonaws.com/specifictest?#{id}'>Test case report for  #{testName} </a>"
  }          
  EMAIL
end

end
