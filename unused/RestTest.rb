require "json"
require "selenium-webdriver"
gem "test-unit"
require "test/unit"
require "./libraries/utilities.rb" 
require "./libraries/testlogging.rb" 

require "HTTParty"

class RestTest < Test::Unit::TestCase
def setup
    @test=Utilities.new
    filedir = File.expand_path File.dirname(__FILE__)
    filebase =  File.basename(__FILE__)
    @test.setup_tasks(filedir , filebase)
     @@g_base_dir, @util, @@environment, @driver, @base_url,@@brws,@@filedir=@test.get_globals
     
  end
  
  def teardown
     @test.check_for_toaster_error_messages
         @test.teardown_tasks(passed?)
         assert_equal nil, @verification_errors
  end
  
  def test_rest_test
@util.logging("rest test")   
#     @auth = {:username => "Chris", :password => "ChrisGoodnight01"}
  
#     options = {:digest_auth => @auth }
#  # detw5151 
#  # dexw5151
# jobsResponse = HTTParty.get('http://detw5151/di/services/batch/jobs',options)
# binding.pry
# response = HTTParty.get(jobsResponse["jobs"]["job"][1]["xlink:href"],options)
# binding.pry

#   rescue => e
#       @util.logging("V______FAILURE!!! Previous line failed. Trace below. __________V")
#      @util.logging(e.inspect)
#       errortrace = e.backtrace
#       size = errortrace.size
#       for i in 0..size
#         errortraceString = "#{errortraceString}\n #{errortrace[i]}"
#       end
#       @util.logging(errortraceString)
#       throw e
#       end
  
# end
require 'mail'  # ruby mail library. https://github.com/mikel/mail
 
# configure delivery and retrieval methods
Mail.defaults do
  delivery_method :smtp, { 
                           :address              => 'smtp.hannover-re.grp',
                           :port                 => 587,
                           :domain               => 'hannover-re.grp',
                           :user_name            => 'Chris.Goodnight@hlramerica.com',
                           :password             => 'G00dnight$',
                           :authentication       => :login,
                            :enable_starttls_auto => true,  
                            :openssl_verify_mode => 'none'
                           }
 
  retriever_method :imap, { :address    => 'smtp.hannover-re.grp',
                          :port       => 993,
                          :user_name  => 'Chris.Goodnight@hlramerica.com',
                          :password   => 'G00dnight$',
                          :authentication       => :login,
                          :enable_ssl => true,
                            :openssl_verify_mode => 'none'   }
end
 
# retrieve first 5 messages
emails = Mail.find(:what => :first, :count => 5)
 
# or retrieve and delete from server first 5 emails
#emails = Mail.find_and_delete(:what => :first, :count => 5)
 
puts "Number of emails retrieved: #{emails.length}"
 
# loop thru all emails and print content
emails.each do |email|
 
    # email fields defined at https://github.com/mikel/mail/tree/master/lib/mail/fields
    puts "from     : " + email.from.to_s       #=> 'fromname@example.com'
    puts "to       : " + email.to.to_s         #=> 'toname@example.com'
    puts "cc       : " + email.cc.to_s         #=> 'ccname@example.com'
    puts "bcc      : " + email.bcc.to_s        #=> 'bccname@example.com'    
    
    puts "subject  : " + email.subject         #=> "This is the subject"
    puts "date     : " + email.date.to_s       #=> '26 Nov 2013 10:00:00 -0800'
    puts "messageid: " + email.message_id      #=> '<ABCD1234.12345678@xxx.xxx>'
    puts "body     : " + email.body.decoded    #=> 'This is the body of the email...    
 
end

Mail.deliver do
 
    from    'Chris.Goodnight@hlramerica.com'
    to      'Chris.Goodnight@hlramerica.com'
    subject 'test subject'
    body    'test body'
 
end

Exchanger.configure do |config|
  #config.endpoint = "https://hannover-re.grp/EWS/Exchanger.asmx"
 #config.endpoint = "https://webmail.hannover-re.grp/owa"
 config.endpoint = "https://us6x5003.hannover-re.grp:444/EWS/Services.wsdl"
  config.username = "hannover-re\\g0h"
  config.password = "G00dnight$"
  config.debug = true # show Exchange request/response info
  config.insecure_ssl  = true
  config.timeout = 60
end

 folder = Exchanger::Mailbox.search("Walker")
 folder = Exchanger::Folder.find("ZenithEmails")



require 'viewpoint'
include Viewpoint::EWS

#endpoint = 'https://us6x5003.hannover-re.grp:444/EWS/Services.wsdl'
endpoint = 'https://us6x5003.hannover-re.grp:444/EWS/exchange.asmx'
#user = 'Chris.Goodnight@hrlamerica.com'
user = 'g0h'
pass = 'G00dnight$'
opts = http_opts: {ssl_verify_mode: 0} 

cli = Viewpoint::EWSClient.new endpoint, user, pass,http_opts: {ssl_verify_mode: 0} 
cli = Viewpoint::EWSClient.new endpoint,,,http_opts: {ssl_verify_mode: 0} 
cli = Viewpoint::EWS::Connection.initialize endpoint,http_opts: {ssl_verify_mode: 0} 

zenithEmails = cli.get_folder_by_name 'ZenithEmails'
items =zenithEmails.todays_items
puts items[0].subject
puts items[0].body
puts items[0].date_time_sent
puts items[0].size
puts items[0].internet_message_headers


cli.send_message do |m|
  m.subject = "Test"
  m.body    = "Test"
  m.to_recipients << 'Chris.Goodnight@hlramerica.com'
end


#     http://detw5151/di/services/batch/jobs
# POST
# {"runtimeConfig": {"description":"","entryPoint":"CDM-28.0/pCDS2_to_CDS.process","logLevel":"INFO","macroSetNames":["CDS2Macroset","CDSMacroset","DBMacroSet","SMTP","WorkflowMacroset","ZenithMacroSet"],"profiling":false,"packageName":"CDM","inMessages":[],"packageVersion":"28.0","transformOptions":{"nullOption":"ERROR","overflowOption":"ERROR","truncationOption":"ERROR"},"variableInitialValues":[{"name":"varLogId","value":"cdsLogId"},{"name":"varReportingPeriodId","value":"369"}],"datasetConfigs":{"namedDatasets":[],"namedSessions":[]},"macroDefinitions":[],"profile_mask":-1,"profile_output_file":"profile.out","execution_options":{"jvmargs":"","classpath_list":[],"use_jvmargs":false}} }
# http://detw5151.hr-appltest.de/di/services/batch/jobs/job_f4ef9732-a95f-4f5b-bd54-72183f0ae3b1/log
#    response = RestClient::Request.execute(:method => :get, :url => "http://dexw5151/di/services/batch/jobs", :headers => {"Authorization" => "basic Q2hyaXM6Q2hyaXNHb29kbmlnaDAx=="})
#  #  www-authenticate →Digest realm="PVSW-DI10-Realm", qop="auth", nonce="MTUzOTI5MTU0MjcwMjo3Mzk2YmQ4YTczZTNlNTc5ZGJhMmJmZDUxZjhjMmM4ZQ=
# @headers={"Authorization" => "basic Q2hyaXM6Q2hyaXNHb29kbmlnaDAx==","set-cookie"=>["DIHasLoggedOut=0;Path=/di", "JSESSIONID=152zdnn2zl0m11eg27xp7xgffl;Path=/di"],
# "www-authenticate"=>["Digest realm=\"PVSW-DI10-Realm\", qop=\"auth\", nonce=\"MTUzOTM2MzQ4NjYzMDphZGM1NjJmNjVmNjM4MTEyOG
# MyNTAyNjdmNTcwOWJkZA==\""], "content-type"=>["text/html;charset=ISO-8859-1"], "cache-control"=>["must-revalidate,no-cach
# e,no-store"], "content-length"=>["1491"], "connection"=>["close"], "server"=>["Jetty(7.5.4.v20111024)"]}> 

#  response = RestClient::Request.execute(:method => :get, :url => "http://dexw5151/di/services/batch/jobs", :headers =>{"Authorization" => "basic Q2hyaXM6Q2hyaXNHb29kbmlnaDAx==","set-cookie"=>["DIHasLoggedOut=0;Path=/di", "JSESSIONID=152zdnn2zl0m11eg27xp7xgffl;Path=/di"],
# "www-authenticate"=>["Digest realm=\"PVSW-DI10-Realm\", qop=\"auth\", nonce=\"MTUzOTM2MzQ4NjYzMDphZGM1NjJmNjVmNjM4MTEyOG
# MyNTAyNjdmNTcwOWJkZA==\""], "content-type"=>["text/html;charset=ISO-8859-1"], "cache-control"=>["must-revalidate,no-cach
# e,no-store"], "content-length"=>["1491"], "connection"=>["close"], "server"=>["Jetty(7.5.4.v20111024)"]})


#   response = RestClient::Request.execute(:method => :get, :url => "http://dexw5151/di/services/batch/jobs", :headers => {"Authorization" => "basic Q2hyaXM6Q2hyaXNHb29kbmlnaDAx==","realm" => "#{realm}", "nonce" => "#{nonce}"})

# response = HTTParty.get('http://dexw5151/di/services/batch/jobs')
# headertext = response.headers.inspect
# secondResponse = HTTPHeader::DigestAuthenticator("Chris","ChrisGoodnight01","get",'http://dexw5151/di/services/batch/jobs',headertext)


# startnonce = headertext.index('nonce=') + 8
# endnonce =  headertext.index('content-type') - 8
# nonce = headertext[startnonce..endnonce]
# startRealm = headertext.index('realm=') + 8 
# endRealm = headertext.index('qop') - 5
# realm = headertext[startRealm..endRealm]


#   response = RestClient::Request.execute(:method => :get, :url => "http://dexw5151/di/services/batch/jobs", :headers => {"Authorization" => "basic Q2hyaXM6Q2hyaXNHb29kbmlnaDAx==","realm" => "#{realm}", "nonce" => "#{nonce}"})


# response.headers.inspect = {"set-cookie"=>["DIHasLoggedOut=0;Path=/di", "JSESSIONID=sk2poguzvq8kb6vh02fjibuu;Path=/di"], "www-authenticate"=>["Digest realm=\\\"PVSW-DI10-Realm\\\", qop=\\\"auth\\\", nonce=\\\"MTUzOTM2NTYzMTQ0NzpjYTA0NDc2ZThiNjMwZmIxNGUyZWUzZDUzNjMxYTFkNg==\\\""], "content-type"=>["text/html;charset=ISO-8859-1"], "cache-control"=>["must-revalidate,no-cache,no-store"], "content-length"=>["1491"], "connection"=>["close"], "server"=>["Jetty(7.5.4.v20111024)"]}
#   response = RestClient::Request.execute(:method => :get, :url => "http://dexw5151/di/services/batch/jobs", :headers => {"Authorization" => "basic Q2hyaXM6Q2hyaXNHb29kbmlnaDAx==","www-authenticate"=>["Digest realm=\\\"PVSW-DI10-Realm\\\", qop=\\\"auth\\\", nonce=\\\"MTUzOTM2NTYzMTQ0NzpjYTA0NDc2ZThiNjMwZmIxNGUyZWUzZDUzNjMxYTFkNg==\\\""]  })
# http://dexw5151/di/services/batch/jobs

#  response = RestClient::Request.execute(:method => :get, :url => "http://dexw5151/di/services/batch/jobs", :headers => {"Authorization" => "basic Q2hyaXM6Q2hyaXNHb29kbmlnaDAx==","Digest realm"=>"PVSW-DI10-Realm", "nonce" =>"MTUzOTYxNDU5MzE4NjoyYWQ4ZWUwNGRiOTM1YjliYTkxYTg0ZTdlZjNjM2ZmYg=="})




# www-authenticate"=>["Digest realm=\"PVSW-DI10-Realm\", qop=\"auth\", nonce=\"MTUzOTYxNDU5MzE4NjoyYWQ4ZWUwNGRiOTM1YjliYTkxYTg0ZTdlZjNjM2ZmYg==\""], "content-type"=>["text/html;charset=ISO-8859-1"], "cache-control"=>["must-revalidate,no-cache

# def first_request(href)
#     klass = self.class
#     klass.base_uri "dexw5151:80"
#     klass.default_options.delete(:basic_auth)
#     klass.digest_auth 'Chris', 'ChrisGoodnight01'
#     klass.get(href, {:query => {}})
#   end


#   class DC
#   include HTTParty
#   base_uri 'dexw5151'

#   def initialize(u, p)
#     @auth = {:username => u, :password => p}
#     puts @auth[:username]

#   end

#   def get()
#     options = {:digest_auth => @auth }
#     self.class.get(/dexw5151/di/services/batch/jobs, options)
#   end
#end
