require "pry"
require "HTTParty"
require "net/http"
require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb"
require "./libraries/testlogging.rb"
require "./logging/encrypt_decrypt.rb"

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
        request["Authorization"] = "\x8D\x12\xCA\xF6Pd\xB7_N\x8D\xA5zF&\xC7\x87\xC4\xC3\f \xA0F`@\r\x1Er-\xC5r\xC9:\xBB\x06R\xB4\x85I'N\x18\xBF\x04lx\x8DI~P\xB6@*\xFD\x8D8\xC5\x7Fm\xDC\xB8\bKdT\x87\xD9\xF7\xB1Q\x99X\xE3Rw\x86\xB6\xD8\xD3\r\xBE\xE0H5\xFC\xD2\xE1\xACx:;\x7F\xA8\fT\xAD\x9B\x14\xC2\x8Fp\x8D\x17F\xED\xCE \xA3\x1A\a\x88\xB9\xBA'\x14\xBCdl\xCF\xA6\x96\xD2\x1F\xB3\xECdcf\e\xD2\xF1\x02h\xAE\x1AZG\xB6\xE5\xAA\xDD\x91`\xADC\xFC\xB7\xC1\xF6\xFAQm\x9A\xCA28\xC2g\xE63\xF2\xFD\xA2\xE2\xF5,Upc\x14z\x8D\x06O\xC9\xCFx\x80\x82\xCF\xB5\x05\xCF\x9E\x15\rD\x04\x15\v\xD2.\xC0NSS\x88C\x7F\x96\xCF\xFE<\xFB\x06\x85\xCD\xC2;\xA3\x7F3l~\xDAr\xBF\xECL\x14\xFEEh\xA4\xFE\xB4\xF8\f \xC2\xE7(\xC8I\xB9n\xE8\xEC\xEC2^\xEE\xA44\xCC\x84\a\x1D\x10\xFA\xC5\xFF+%\xF0\xC4\x06_Ni\x00\x86\x04\xCC\xFA2\xDA{>\xA54\x05\xA4\x0Ftm\xC2TP.\x8E\xCEw\xAC\xF5}\xD2\xBCE\b\xC9\x06\x03\xC5#0\x05>nQ\xE7\xDBD\xAE\x84\x18\x06\x81;\x86\x88Dm4\x86C\xA0s\x98\xF9\xB2\xBD\x1C\xAD\xE8\x86\xB8\x8D\rR\b\xF5U\xFF\xC3\xEA\xC2\xB8\xF1\x88\xCBbkV4\xEC\xD2u\xF6\x91i\x910\xFD\xED\xCF\x14$\xE7#\xBF\x0F\xFB\x00\x90\xBC\xC2U\v5,\xE9(\xF5\xCF\x01Y\x8C\xC3]\xD7Z\x92\xA1\xEA".decrypt(ENV("DBPKEY"))

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
