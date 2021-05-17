require 'rubygems'
require 'date'
require 'webrick'
require 'tiny_tds'
#require 'pg'
require 'pry'
require 'HTTParty'

class WebForm < WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)
    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)
    url = request.request_uri.to_s
    interval =0
    if url.include?"?"
      date=url[(url.index('?')+1)..url.length]
      #convertedDate=Date.parse(date)
      convertedDate=Date::strptime(date,"%m/%d/%Y")
      #now=DateTime.now.strftime('%Y-%m-%d')
      now = Date.today
      #puts "date to search for is #{date} now is #{now}"
      interval = (now - convertedDate).to_i
      #puts "interval = #{interval}"
      #elsif url.include?"?"
      #  interval = url[(url.index('?')+1)..url.length]
    else
      interval = 0
    end

    time = Time.new
    time = time -(interval * 86400 )

    dateName = "#{time.month}/#{time.day}/#{time.year}"

    html   = "<html><META HTTP-EQUIV=\"refresh\" CONTENT=\"60\"><body><form method='POST' action='/save'>"
    html +="<h1>QA Automation Results for #{dateName}</h1>"
    environments =["uat","qdev","qa1","qa2","qa3","qa4","qa5","qa6","qa7","staging","uhcmr","qaexternal","qaexternal2","sandbox3","sandbox4","sandbox5","sandbox6","demo1","ux01","uat01"]

    client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")
    environments.each do |env|
      html +="<form>"
      html +="<h2><a href=\"/trends?#{env}\">#{env} </a> </h2>"
      html +=  "<table border=\"2\" style=\"width:100%\">"
      html +="<tr><td>"
      #status
      results = client.query("select status, last_branch, date_of_branch from environments where environment_name ='#{env}'")
      results.each(:as => :array) do |row|
        # puts "#{row[1]} #{row[2]} got the rows"
        if row[0] == "Idle"
          html += "<label><b>Automation Status: </b></label> <font color=\"green\"> <b>#{row[0]}</b></font><br><label>Last build run against:</label><br>"
        elsif  row[0] == "Running"
          html += "<label><b>Automation Status: </b></label> <font color=\"red\"> <b>#{row[0]}</b></font><br><label>Last build run against:</label><br>"
        end
      end
      #Passed
      newPassed = "select distinct (select count('status')  from results where date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"Passed\" and enviro =\"#{env}\" ) as passed from results"
      # puts "select distinct (select count('status')  from results where date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"Passed\" and enviro =\"#{env}\" ) as passed from results"
      results = client.query(newPassed)
      passedVal= 0
      results.each(:as => :array) do |row|
        html += "<label><a href=\"/details?enviro=#{env}&status=Passed&dateoffset=#{interval}\"><b>Passed: </b></a></label> <font color=\"green\"> <b>#{row[0]}</b></font><br>"
        passedVal= row[0]
      end
      #Failed
      failedVal =0
      newFailed = "select distinct (select count('status')  from results where date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"failed\" and enviro =\"#{env}\" ) as passed from results"
      results = client.query(newFailed)
      results.each(:as => :array) do |row|
        failedVal = row[0]
        html += "<label><a href=\"/details?enviro=#{env}&status=Failed&dateoffset=#{interval}\"><b>Failed: </b></a></label> <font color=\"red\"><b>#{row[0]}</b></font><br>"
      end
      #Branch
      percentage = passedVal/(passedVal + failedVal)
      html +="<label>#{percentage}</label>"
      html +="</td></tr><tr><td>"
      results = client.query("select distinct branch from results where date(date_run) = date_sub(date(now()),interval #{interval} day) and enviro =\"#{env}\"" )
      html += "<label><b>Branch(s): </b>"
      results.each(:as => :array) do |row|
        test=row[0].to_s
        if test.length >2
          html += "<li></label>#{row[0]}</li>"
        end
      end
      # OS
      html +="</td></tr><tr><td>"
      results = client.query("select distinct os from results where date(date_run) = date_sub(date(now()),interval #{interval} day) and enviro =\"#{env}\"" )
      html += "<br><label><b>Tested OS(s): </b>"
      osHolder =""
      results.each(:as => :array) do |row|
        if row[0].include?("darwin")

          oS="Macintosh"
          osHolder = "%darwin%"
        elsif row[0] =="i386-mingw32"
          oS = "Windows"
        end
        osHolder="#{row[0]}"
        html += "<li></label>#{oS}  "
        #Passed
        newPassed = "select distinct (select count('status')  from results where os like \"#{osHolder}\" and date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"Passed\" and enviro =\"#{env}\" ) as passed from results"
        results = client.query(newPassed)
        results.each(:as => :array) do |row|
          html += "<label><a href=\"/details?enviro=#{env}&status=Passed&os=#{osHolder}&dateoffset=#{interval}\"><b>  Passed: </b></a></label> <font color=\"green\"> <b>#{row[0]}  </b></font>"
        end
        #Failed
        newFailed = "select distinct (select count('status')  from results where os like \"#{osHolder}\" and date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"Failed\" and enviro =\"#{env}\" ) as passed from results"
        results = client.query(newFailed)
        results.each(:as => :array) do |row|
          html += "<label><a href=\"/details?enviro=#{env}&status=Failed&os=#{osHolder}&dateoffset=#{interval}\"><b> Failed: </b></a></label> <font color=\"red\"><b>#{row[0]}  </b></font></li>"
        end
      end
      #browser
      html +="</td></tr><tr><td>"
      results = client.query("select distinct browser from results where date(date_run) = date_sub(date(now()),interval #{interval} day) and enviro =\"#{env}\" order by browser")
      html += "<br><label><b>Browser(s): </b>"
      results.each(:as => :array) do |row|
        browserHolder = "#{row[0]}"
        html += "<li></label>#{row[0]}"
        #Passed
        newPassed = "select distinct (select count('status')  from results where browser = \"#{browserHolder}\" and date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"Passed\" and enviro =\"#{env}\" ) as passed from results"
        results = client.query(newPassed)
        results.each(:as => :array) do |row|
          html += "<label><a href=\"/details?enviro=#{env}&status=Passed&browser=#{browserHolder}&dateoffset=#{interval}\"><b>  Passed: </b></a></label> <font color=\"green\"> <b>#{row[0]}  </b></font>"
        end
        #Failed
        newFailed = "select distinct (select count('status')  from results where browser = \"#{browserHolder}\" and date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"failed\" and enviro =\"#{env}\" ) as passed from results"
        results = client.query(newFailed)
        results.each(:as => :array) do |row|
          html += "<label><a href=\"/details?enviro=#{env}&status=Failed&browser=#{browserHolder}&dateoffset=#{interval}\"><b>  Failed: </b></a></label> <font color=\"red\"><b>#{row[0]}  </b></font></li>"
        end
      end
      html +="</form>"
      html +="</td></tr></table>"



    end





    #html += "<input type='submit'></form></body></html>"
    client.close #close those dirty connections
    # Return OK (200), content-type: text/html, followed by the HTML itself
    return 200, "text/html", html
  end
end
class Initial < WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)
    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)

    html   = "<html><!DOCTYPE HTML><META HTTP-EQUIV=\"refresh\" CONTENT=\"60\"><!DOCTYPE HTML><body style=\"font-family:Helvetica;background-color:#E9EAE8;\">"
    #<form method=\"POST\" action=\"/save\" accept-charset='utf-8'>"
    html +="<h1>Devices</h1>"
    html+="<a href=\"/results\"><button>Results</button></a>  "
    html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
    html+="<a href=\"/devices\"><button>Devices</button></a>  "
    #html+="<a href=\"/results\"><button>Results</button></a>"
    #html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
    # html+="<a href=\"/campaign_count\"><button>Members In Campaign by Enviro</button></a>"
    #html += "</form>"
    # html +="<button type=\"button\" onClick=\"/Users/qa-user/Desktop/scripts/AllEnviroBuckedStatus.rb\">REFRESH</button>"

    environments =["production","staging","uat","qa1","qa2","qa3","qa4","qa5","qa6","qa7","qdev","uhcmr","qaexternal","qaexternal2","sandbox3","sandbox4","sandbox5","sandbox6","demo1","ux01","uat01"]

    client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")
    current_build=""
    current_build_expected_release=""
    future_build=""
    future_build_expected_release=""


    results = client.query("select build, expected_release_date from builds where status = 'current'")
    results.each(:as => :array) do |row|
      current_build = row[0]
      current_build_expected_release = row[1]
    end
    results = client.query("select build, expected_release_date from builds where status = 'future'")
    results.each(:as => :array) do |row|
      future_build = row[0]
      future_build_expected_release = row[1]
    end
    html +="<p><font color=\"blue\">Current Dev build = #{current_build}     Expected release date #{current_build_expected_release}    <font color=\"purple\">    Future Dev build = #{future_build}     Expected release date #{future_build_expected_release}</p>"

    columns = 0
    #html +="<form>"

    html +=  "<table border=\".5\" style=\"width:100%;\">"
    environments.each do |env|

      if columns ==0 || columns ==4 || columns ==8 || columns ==12 || columns==16 || columns==20
        html +="<tr>"
      end
      html+="<td style=\"padding:5px;background-color:#FFF;max-width:200px;overflow:none;\">"
      #status
      results = client.query("select status,last_branch, date_of_branch,database_refresh,titan_last_branch,titan_date_of_branch,hermes_last_branch, hermes_date_of_branch,notes,installSha, titan_InstallSha, Hermes_InstallSha, EnviroStatus,hermes_core_db_refresh, owner, pluto_date_of_branch, pluto_install_sha, pluto_server from environments where environment_name ='#{env}'")
      # puts "#{environments} results= #{results}"
      # puts "query \n select status,last_branch, date_of_branch,database_refresh,titan_last_branch,titan_date_of_branch,hermes_last_branch, hermes_date_of_branch,notes,installSha, titan_InstallSha, Hermes_InstallSha, EnviroStatus,hermes_core_db_refresh, owner, pluto_date_of_branch, pluto_install_sha, pluto_server from environments where environment_name ='#{env}'"
      results.each(:as => :array) do |row|
        if env=='staging' || env=='production'
          html +="<h2><a href=\"/results\">#{env} </a> <font size ='4'>&nbsp;&nbsp;&nbsp;&nbsp</font></h2></form>"
          #        <form action =\"/campaign_user\" METHOD=\"GET\" >
          #   <div style='padding:2rem; margin:0 1rem;'> <pre><h4>Find eligible unactivated member in a campaign</h4>
          #   <input type=\"radio\" name =\"env\" value=\"uat\">UAT<br>
          #   <input type=\"radio\" name =\"env\"value=\"qa1\">QA1<br>
          #   <input type=\"radio\" name =\"env\"value=\"qa2\">QA2<br>
          #   <input type=\"radio\" name =\"env\"value=\"qa3\">QA3<br>
          #   <input type=\"radio\" name =\"env\"value=\"qa4\">QA4<br>
          #   <input type=\"radio\" name =\"env\"value=\"qa5\">QA5<br>
          #   <input type=\"radio\" name =\"env\"value=\"qdev\">QDEV<br>
          #   <input type=\"radio\" name =\"env\"value=\"staging\">Staging <br>
          #    Enter the campaign id(from below)
          # <br>
          #     <input type=\"text\" name=\"camp\">

          #     <br>

          #     <input type=\"submit\"/></td></div></pre></form>"
          html +="<button type = \"submit\"><a href=\"/multiserverenviro\">Full Detail</a></button>"
        else
          html +="<h2><form action =\"/claim_enviro\" METHOD=\"GET\" ><a href=\"/results\">#{env} </a> <font  size ='4'>&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"text\" name=\"taken\" value=\"#{row[14]}\"> </input><input type=\"hidden\" name=\"env\" value=\"#{env}\" visibility=\"hidden\"> </input><input type=\"submit\"/></font></h2></form>"
        end
        if row[0] == "Idle"
          html += "<h4><label><b>Automation Status: </b></label> <font color=\"green\"> <b>#{row[0]}</b></font><br><label><b>Prime Branch:</b></label><label {text-allign: right;}> <font color=\"orange\">  #{row[1]}</font></label><br><label><b>Date of Branch: </b> #{row[2]}</label><br><label><b>Sha:</b>  <font size='2'>#{row[9]}</font></label><br><label><b>PrimeDB refreshed:</b>  #{row[3]}</label><br><label><b>Titan Branch:</b> <font color=\"brown\">  #{row[4]} </font></label><br><label><b>Titan Date of Branch:</b>  #{row[5]}</label><br><label><b>Titan Sha:</b>  <font size='2'>#{row[10]}</font></label><br><label><b>Hermes Branch:</b> <font color=\"pink\"> #{row[6]}</font></label><br><label><b>Hermes Date of Branch:</b>  #{row[7]}</label><br><label><b>Hermes/CoreDB refreshed:</b>  #{row[13]}</label><br><label><b>Pluto installed:</b>  #{row[15]}</label> <br><label><b>Pluto Sha:</b> <font color=\"purple\"> #{row[16]}</font></label><br><label><b>Pluto Server:</b>  #{row[17]}</label><label><br><b>Notes:</b>  #{row[8]}</label><br></h4>"
        elsif  row[0] == "Running"
          html += "<h4><label><b>Automation Status: </b></label> <font color=\"red\"> <b>#{row[0]}</b></font><br><label><b>PrimeBranch: </b></label><label{text-allign: right;}> <font color=\"orange\">  #{row[1]}</font><br><label><b>Date of Branch: </b> #{row[2]}</label><br><label><b>Sha:</b>  #{row[9]}</label><br><label><b>PrimeDB refreshed: </b>  #{row[3]}</label><br><label><b>Titan Branch:</b> <font color=\"brown\">  #{row[4]} </font></label><br><label><b>Titan Sha:</b>  <font size='2'>#{row[10]}</font></label><br><label><b>Titan Date of Branch:</b>  #{row[5]}</label><br><label><b>Hermes Branch:</b> <font color=\"pink\"> #{row[6]}</font></label><br><label><b>Hermes Date of Branch:</b>  #{row[7]}</label><br><label><br><label><b>Hermes/CoreDB refreshed:</b>  #{row[13]}</label><br><label><b>Pluto installed:</b>  #{row[15]}</label> <br><label><b>Pluto Sha:</b> <font color=\"purple\"> #{row[16]}</font></label><br><label><b>Pluto Server:</b>  #{row[17]}</label><label><br><b>Notes:</b>  #{row[8]}</label><br></h4>"
        end
      end
      columns= columns+1

      # OS
      html +="</td>"
      if columns == 4 || columns ==8 ||columns ==12 || columns==16|| columns==20

        html +="</tr>"
      end



    end

    html +="</form>"
    html +="</td></tr></table>"
    html +="<form method='POST' action='/save' accept-charset='utf-8'>"
    html+="<a href=\"/results\"><button>Results</button></a>  "
    html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
    html+="<a href=\"/devices\"><button>Devices</button></a>  "
    html+="<a href=\"/campaign_count\"><button>Members In Campaign by Enviro</button></a>"
    html +="</form>"

    #html += "<input type='submit'></form></body></html>"
    client.close #close those dirty connections
    # Return OK (200), content-type: text/html, followed by the HTML itself
    return 200, "text/html", html
  end
end
class ClaimEnviro< WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)

    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)


    url = request.request_uri.to_s
    interval =0
    if url.include?"?"
      params=url[(url.index('?')+1)..url.length]
      # puts"#{params}"
      taken= params[(params.index('taken=')+6)..(params.index('&env=')-1)]
      env = params[(params.index('env=')+4)..params.length]
    end

    taken = taken.gsub('%28','(')
    taken = taken.gsub('%29',')')
    taken = taken.gsub('+',' ')


    client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")
    results = client.query("update environments set owner ='#{taken}' where environment_name='#{env}'")
    html= "<html><META HTTP-EQUIV=\"refresh\" content=\"5;url=http://qa-dashboard:8000/\" ><body><form method='POST' action='/save'>"
    html+="<h1>Successfully claimed #{env} for #{taken}</h1>"
    html+="<a href=\"/results\"><button>Results</button></a>  "
    html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
    html+="<a href=\"/devices\"><button>Devices</button></a>  "
    html+="<a href=\"/campaign_count\"><button>Members In Campaign by Enviro</button></a>"


    return 200, "text/html", html
  end

end
class ProdCounts< WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)

    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)
    previousDay=""
    nextDay=""
    url = request.request_uri.to_s
    if url.include?"?"
      date=url[(url.index('?')+1)..url.length]
      #convertedDate=Date.parse(date)
      convertedDate=Date::strptime(date,"%m/%d/%Y")
      #now=DateTime.now.strftime('%Y-%m-%d')
      now = Date.today
      # puts "date to search for is #{date} now is #{now}"
      interval = (now - convertedDate).to_i
      previousDay = (convertedDate -(1)).strftime("%m/%d/%Y")
      nextDay = (convertedDate +(1)).strftime("%m/%d/%Y")
      puts "interval = #{interval}  previousDay = #{previousDay} nextDay = #{nextDay}"

    else
      interval = 0
      time = Time.new
      time = time -(1 * 86400 )
      previousDay = "#{time.month}/#{time.day}/#{time.year}"
      puts "interval = #{interval}  previousDay = #{previousDay} nextDay = #{nextDay}"

    end
    @@azureuser=""
    @@azureHostShort=""
    @@azurePassword=""
    @@azureHost=""
    @@azuredb=""
    database = ""
    dateStamp = ""
    opusSyncCountFacility =""
    webJobCountFacility = ""
    lzCountsFacility = ""
    warmCountFacility =""
    opusSyncDif = ""
    webJobCountDiff = ""
    lzCountDiff = ""
    warmCountDiff = ""
    opusSyncCountValidLz = ""
    opusSyncInvalidFacility = ""
    customer = ""

    url = request.request_uri.to_s
    client=TinyTds::Client.new(:username=>"#{@@azureuser}@#{@@azureHostShort}", :password=> "#{@@azurePassword}", :dataserver=> "#{@@azureHost}", :port=>1433, :azure=> true, :database=>"#{database}", timeout: 60, login_timeout: 120 )
    client.execute('SET TEXTSIZE 2147483647;')

    time = Time.new
    time = time -(interval.to_i * 86400 )

    dateName = "#{time.month}/#{time.day}/#{time.year}"
    # html= "<html><META HTTP-EQUIV=\"refresh\" content=\"5;url=http://dexw5171.hr-applprep.de:8000/\" ><body><form method='POST' action='/save'>"
    html= "<html><body>"
    html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
    html+="<a href=\"/devices\"><button>Devices</button></a>  "
    html+="<a href=\"/results\"><button>QA Results page</button></a>  "
    html+="<h1>ProdCounts for #{dateName}  <a href=\"/prod_counts?#{previousDay}\"><button>Previous Day</button></a>"
    if nextDay != ""
      html +="<a href=\"/prod_counts?#{nextDay}\"><button>Next Day</button></a></h1>"
    else
      html += "</h1>"
    end
    html+="<b>Updated hourly at 15 min after the hour</b>"

    html +=  "<table border=\"1\" style=\"width:1000px\" >"

    html += "<td>Customer</td><td>Date        </td><td>OpusSyncInvalidFacility</td><td>OpusSyncFacilityCount</td><td>WebJobCountFacility</td><td>OpusSyncFacilityCount of 1-3,8-10</td><td>WarmLZCountsFacility</td><td>WarmCountsFacility</td><td>ColdCountsFacility</td><td>OpusSyncDiffCount</td><td>WebJobDiffCount</td><td>LZDiffCount</td><td>WarmDiffCount</td>"

    html +="</tr>"
    results = client.execute("select * from dailyCounts where datestamp = convert(date,dateadd(day, -#{interval}, getdate())) order by  customer")
    results.each do |row|
      dateStamp = row["DateStamp"]
      opusSyncCountFacility = row["OpusSyncCountFacility"]
      webJobCountFacility = row["WebJobCountFacility"]
      lzCountsFacility =row["LZCountsFacility"]
      opusSyncDif = row["OpusSyncDiff"]
      webJobCountDiff = row["WebJobCountDiff"]
      lzCountDiff = row["LzCountDiff"]
      warmCountFacility = row["WarmCountsFacility"]
      warmCountDiff = row["WarmCountsDiff"]
      opusSyncCountValidLz = row["OpusSyncCountValidLz"]
      opusSyncInvalidFacility = row["OpusSyncInvalidFacility"]
      customer = row["Customer"]
      coldCountFacility = row["ColdCountsFacility"]
      html += "<td>#{customer}</td><td>#{dateStamp}</td><td>#{opusSyncInvalidFacility}</td><td>#{opusSyncCountFacility}</td><td>#{webJobCountFacility}</td><td>#{opusSyncCountValidLz}</td><td>#{lzCountsFacility}</td><td>#{warmCountFacility}</td><td>#{coldCountFacility}</td><td>#{opusSyncDif}</td><td>#{webJobCountDiff}</td><td>#{lzCountDiff}</td><td>#{warmCountDiff}</td>"
      html += "</tr><tr>"
    end


    html +="</tr>"
    html +="</table><br> There should be zero opussync Invalid Facility messages<br>OpusSyncFacility should = WebjobCountFacility<br> OpusSyncFacilityCount 1-3,8-10 should = Warm LZ Counts Facility = Cold Count Facility<br> OpusSyncDiffCount should = WebJobDiffCount  = LZDiffCount<br>Note: The WebJob is currently not logging information <p style=\"font-size:20px\">"
    # Return OK (200), content-type: text/plain, and a plain-text "Saved! Thank you." notice
    client.close #close those dirty connections
    return 200, "text/html", html
  end

end

class CampaignUserBehavior< WEBrick::HTTPServlet::AbstractServlet
  @@postgresDB=""
  @@environment=""

  # Process the request, return response
  def do_GET(request, response)

    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)


    url = request.request_uri.to_s
    interval =0
    if url.include?"?"
      params=url[(url.index('?')+1)..url.length]
      # puts"#{params}"
      env= params[(params.index('env=')+4)..(params.index('&camp=')-1)]
      campaign_id = params[(params.index('camp=')+5)..(params.index('&behav=')-1)]
      campaign_behavior_id =params[(params.index('behav=')+6)..params.length]
    end
    @util=Utilities.new(env)

    #   puts"#{env} \n #{campaign_id} \n #{campaign_behavior_id}"
    @@environment = env
    @util.set_dbs_for_environment
    # puts("Assigning the SQL results to variables ")
    vhermes_id = ""
    vsponsor_id  = ""
    vfirst_name = ""
    vlast_name = ""
    vstatus = ""
    vbirthday  = ""
    vBday_month = ""
    vBday_day = ""
    vBday_year = ""
    vDOB = ""
    vemail = ""

    fields,data2,columns=@util.postgres_query("hermes","select m.id, m.sponsor_id, m.first_name, m.last_name, m.status, m.birthday,  TO_CHAR(birthday, 'MM') AS Bday_month, TO_CHAR(birthday, 'DD') AS Bday_day, TO_CHAR(birthday, 'YYYY') AS Bday_year, m.email, bt.name
from member_campaign_behaviors mcb, members m, member_campaigns mc, campaign_behaviors cb, behaviors b , behavior_translations bt 
where m.status = 'eligible' and m.deleted_at is null and mc.id = mcb.member_campaign_id and
mc.member_id = m.id  and mc.campaign_id ='#{campaign_id}' and mc.member_id= m.id and mcb.member_campaign_id = mc.id and mcb.campaign_behavior_id = cb.id and cb.behavior_id = b.id and mcb.campaign_behavior_id ='#{campaign_behavior_id }' and bt.behavior_id = b.id and bt.locale ='en' and mcb.state ='available' limit 1;",true)     

    data2.each do |row2|
      vhermes_id="#{row2['id']}"
      # puts"hermesid=#{vhermes_id}"
      # puts"first name =#{row2[1]}   #{row2}"
    end
    #
    html= "<html><body><form method='POST' action='/save'>"
    html+="<h1>Selected Eligible User in #{@@environment}</h1>"
    html+="<p>for Campaign_id #{campaign_id}  campaign_behavior= #{campaign_behavior_id} "


    fields,data,columns=@util.postgres_query("hermes","SELECT id, sponsor_id, first_name, last_name, status, birthday, TO_CHAR(birthday, 'MM') AS Bday_month, TO_CHAR(birthday, 'DD') AS Bday_day, TO_CHAR(birthday, 'YYYY') AS Bday_year, email FROM members WHERE status = 'eligible' AND id = '#{vhermes_id}'",true)


    data.each do |row|
      vsponsor_id = "#{row['sponsor_id']}"
      vfirst_name = "#{row['first_name']}"
      vlast_name = "#{row['last_name']}"
      vstatus = "#{row['status']}"
      vbirthday = "#{row['birthday']}"
      vBday_month = "#{row['Bday_month']}"
      vBday_day = "#{row['Bday_day']}"
      vBday_year = "#{row['Bday_year']}"
      vemail = "#{row['email']}"
    end
    if "#{vemail}" == ""
      #   puts("email is blank using #{vfirst_name}.#{vlast_name}@example.com")
    end
    vDOB = "#{vBday_month}/"+"#{vBday_day}/"+"#{vBday_year}"

    html+="<p>-- vhermes_id = #{vhermes_id}</p>"
    html+="<p>-- vsponsor_id = #{vsponsor_id}</p>"
    if campaign_id=="16" || campaign_id=="17" || campaign_id=="23" || campaign_id=="24" || campaign_id=="27" || campaign_id=="28" || campaign_id=="29" || campaign_id=="30"
      suffixLocation= vsponsor_id.index('_') -1
      vCustomerViewSponsorId=vsponsor_id[0..suffixLocation]
    else
      vCustomerViewSponsorId=vsponsor_id
    end
    html+="<p>-- vsponsor_id on Card= #{vCustomerViewSponsorId}</p>"
    html+="<p>-- vfirst_name = #{vfirst_name}</p>"
    html+="<p>-- vlast_name = #{vlast_name}</p>"
    html+="<p>-- vstatus = #{vstatus}</p>"
    html+="<p>-- vbirthday = #{vbirthday}</p>"
    html+="<p>-- vBday_month = #{vBday_month}</p>"
    html+="<p>-- vBday_day = #{vBday_day}</p>"
    html+="<p>-- vBday_year = #{vBday_year}</p>"
    html+="<p>-- vDOB = #{vDOB}</p>"
    html+="<p>-vemail = #{vemail}</p>"
    html+="<p>------------------------------------------------------------</p>"

    html +="</form>"
    html +="</td></tr></table>"
    html+="<a href=\"/results\"><button>Results</button></a>  "


    return 200, "text/html", html
  end

end
class CampaignUser < WEBrick::HTTPServlet::AbstractServlet
  @@postgresDB=""
  @@environment=""

  # Process the request, return response
  def do_GET(request, response)

    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)


    url = request.request_uri.to_s
    interval =0
    if url.include?"?"
      params=url[(url.index('?')+1)..url.length]
      #   puts"#{params}"
      env= params[(params.index('env=')+4)..(params.index('&camp=')-1)]
      campaign_id = params[(params.index('camp=')+5)..params.length]

    end
    @util=Utilities.new(env)

    # puts"#{env} \n #{campaign_id}"
    @@environment = env
    @util.set_dbs_for_environment
    # puts("Assigning the SQL results to variables ")
    vhermes_id = ""
    vsponsor_id  = ""
    vfirst_name = ""
    vlast_name = ""
    vstatus = ""
    vbirthday  = ""
    vBday_month = ""
    vBday_day = ""
    vBday_year = ""
    vDOB = ""
    vemail = ""

    fields,data2,columns=@util.postgres_query("hermes","select m.id, m.sponsor_id, m.first_name, m.last_name, m.status, m.birthday,  TO_CHAR(birthday, 'MM') AS Bday_month, TO_CHAR(birthday, 'DD') AS Bday_day, TO_CHAR(birthday, 'YYYY') AS Bday_year, m.email, bt.name
from member_campaign_behaviors mcb, members m, member_campaigns mc, campaign_behaviors cb, behaviors b , behavior_translations bt 
where m.status = 'eligible' and m.deleted_at is null and mc.id = mcb.member_campaign_id and
mc.member_id = m.id  and mc.campaign_id ='#{campaign_id}' and mc.member_id= m.id and mcb.member_campaign_id = mc.id  and mcb.state ='available' limit 1;",true)     

    data2.each do |row2|
      vhermes_id="#{row2['id']}"
      #   puts"hermesid=#{vhermes_id}"
      #   puts"first name =#{row2[1]}   #{row2}"
    end
    #
    html= "<html><body><form method='POST' action='/save'>"
    html+="<h1>Selected Eligible User in #{@@environment}</h1>"
    html+="<p>for Campaign_id #{campaign_id} </p> "


    fields,data,columns=@util.postgres_query("hermes","SELECT id, sponsor_id, first_name, last_name, status, birthday, TO_CHAR(birthday, 'MM') AS Bday_month, TO_CHAR(birthday, 'DD') AS Bday_day, TO_CHAR(birthday, 'YYYY') AS Bday_year, email FROM members WHERE status = 'eligible' AND id = '#{vhermes_id}'",true)


    data.each do |row|
      vsponsor_id = "#{row['sponsor_id']}"
      vfirst_name = "#{row['first_name']}"
      vlast_name = "#{row['last_name']}"
      vstatus = "#{row['status']}"
      vbirthday = "#{row['birthday']}"
      vBday_month = "#{row['Bday_month']}"
      vBday_day = "#{row['Bday_day']}"
      vBday_year = "#{row['Bday_year']}"
      vemail = "#{row['email']}"
    end
    if "#{vemail}" == ""
      #    puts("email is blank using #{vfirst_name}.#{vlast_name}@example.com")
    end
    vDOB = "#{vBday_month}/"+"#{vBday_day}/"+"#{vBday_year}"

    html+="<p>-- vhermes_id = #{vhermes_id}</p>"
    html+="<p>-- vsponsor_id = #{vsponsor_id}</p>"
    if campaign_id=="16" || campaign_id=="17" || campaign_id=="23" || campaign_id=="24" || campaign_id=="27" || campaign_id=="28" || campaign_id=="29" || campaign_id=="30"
      suffixLocation= vsponsor_id.index('_') -1
      vCustomerViewSponsorId=vsponsor_id[0..suffixLocation]
    else
      vCustomerViewSponsorId=vsponsor_id
    end
    html+="<p>-- vsponsor_id on Card= #{vCustomerViewSponsorId}</p>"
    html+="<p>-- vfirst_name = #{vfirst_name}</p>"
    html+="<p>-- vlast_name = #{vlast_name}</p>"
    html+="<p>-- vstatus = #{vstatus}</p>"
    html+="<p>-- vbirthday = #{vbirthday}</p>"
    html+="<p>-- vBday_month = #{vBday_month}</p>"
    html+="<p>-- vBday_day = #{vBday_day}</p>"
    html+="<p>-- vBday_year = #{vBday_year}</p>"
    html+="<p>-- vDOB = #{vDOB}</p>"
    html+="<p>-vemail = #{vemail}</p>"
    html+="<p>------------------------------------------------------------</p>"

    html +="</form>"
    html +="</td></tr></table>"
    html+="<a href=\"/results\"><button>Results</button></a>  "

    return 200, "text/html", html
  end

end
class Utilities
  @@environment=""
  def initialize(env)
    @@environment=env
  end
  def set_dbs_for_environment

  end
  def get_postgresDB
    @@postgresDB
  end
  def postgres_query(*args)
    # @@environment=args[0]
    database= args[0]
    returnHash=false
    query = args[1]
    if args.size >=3
      returnHash=true
    end

    host="#{@@postgresDB}"
    # puts"#{@@postgresDB}  inside the function"
    if @@environment=="qa6" || @@environment=="qaexternal2" || @@environment=="uhcmr" || @@environment=="qa7" || @@environment=="uat" || @@environment=="qa1" || @@environment=="qa2"|| @@environment=="qa3" || @@environment=="qa4" || @@environment=="qa5" || @@environment=="www" || @@environment=="qdev"
      fullDatabaseName = "#{database}"
      #  puts("Querying DB #{fullDatabaseName}")
    elsif @@environment=="staging" || @@environment =="uat01"


      fullDatabaseName = "#{database}_20160322"
      # puts("Querying DB #{fullDatabaseName}")
    else
      fullDatabaseName = "#{@@environment}_#{database}"
    end
    #@util.logging("#{host}  and #{fullDatabaseName}")

    conn = PG.connect(:dbname => "#{fullDatabaseName}",:host => host, :user  => "hermesapp" , :password  => "passw0rd")

    res = conn.exec( "#{query}" )
    # puts"query is \n #{query}"
    # res=conn.get_result()
    # puts"res fields #{res.fields} \nres values= #{res.values} "
    # puts"inside id #{res[0]['id']} "


    #  puts"#{res[0][0]} is the id"


    if returnHash==true
      return res.fields,res,res.nfields
    else
      return res.fields,res.values, res.nfields
    end
  rescue PG::Error => e

    puts e.message

  ensure

    if returnHash==false
      res.clear
    end
    conn.close if conn
  end
end
class CampaignCount < WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)
    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)

    html   = "<html><META HTTP-EQUIV=\"refresh\" CONTENT=\"60\"><body>"
    html +="<h1>QA Environments </h1>"

    html+="<a href=\"/results\"><button>Results</button></a>  "
    html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
    html+="<a href=\"/initial\"><button>Environment Overview</button></a>  "
    html +="<table><table border=\"1\" style=\"width:400px\"><tr><td><form action =\"/campaign_user\" METHOD=\"GET\" >
     <div style='padding:2rem; margin:0 1rem;'> <pre><h4>Find eligible unactivated member in a campaign</h4>
     <input type=\"radio\" name =\"env\" value=\"uat\">UAT<br>
     <input type=\"radio\" name =\"env\"value=\"qa1\">QA1<br>
     <input type=\"radio\" name =\"env\"value=\"qa2\">QA2<br>
     <input type=\"radio\" name =\"env\"value=\"qa3\">QA3<br>
     <input type=\"radio\" name =\"env\"value=\"qa4\">QA4<br>
     <input type=\"radio\" name =\"env\"value=\"qa5\">QA5<br>
     <input type=\"radio\" name =\"env\"value=\"qdev\">QDEV<br>
     <input type=\"radio\" name =\"env\"value=\"staging\">Staging <br>
      Enter the campaign id(from below)
   <br>
       <input type=\"text\" name=\"camp\">

       <br>

       <input type=\"submit\"/></td></div></pre></form>"
    html +="<td><form action =\"/campaign_behaviors\" METHOD=\"GET\" >
       <div style='padding:2rem; margin:0 1rem; '> <pre><h4>Find behaviors in campaign by environment</h4>
       <p>(next page will allow you to find a user with that behavior)</p>
     <input type=\"radio\" name =\"env\" value=\"uat\">UAT<br>
     <input type=\"radio\" name =\"env\"value=\"qa1\">QA1<br>
     <input type=\"radio\" name =\"env\"value=\"qa2\">QA2<br>
     <input type=\"radio\" name =\"env\"value=\"qa3\">QA3<br>
     <input type=\"radio\" name =\"env\"value=\"qa4\">QA4<br>
     <input type=\"radio\" name =\"env\"value=\"qa5\">QA5<br>
     <input type=\"radio\" name =\"env\"value=\"qdev\">QDEV<br>
     <input type=\"radio\" name =\"env\"value=\"staging\">Staging <br>
      Enter the campaign id(from below)
   <br>
       <input type=\"text\" name=\"camp\">

       <br>

       <input type=\"submit\"/></td></tr></div></pre></form>"

    html +="</td></tr></table>"
    html+="<form method='POST' action='/save'>"

    # html +="<button type=\"button\" onClick=\"/Users/qa-user/Desktop/scripts/AllEnviroBuckedStatus.rb\">REFRESH</button>"

    environments =["staging","uat","qa1","qa2","qa3","qa4","qa5","qa6","qa7","qdev"]

    client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")
    current_build=""
    current_build_expected_release=""
    future_build=""
    future_build_expected_release=""


    results = client.query("select build, expected_release_date from builds where status = 'current'")
    results.each(:as => :array) do |row|
      current_build = row[0]
      current_build_expected_release = row[1]
    end
    results = client.query("select build, expected_release_date from builds where status = 'future'")
    results.each(:as => :array) do |row|
      future_build = row[0]
      future_build_expected_release = row[1]
    end
    # html +="<p><font color=\"blue\">Current Dev build = #{current_build}     Expected release date #{current_build_expected_release}    <font color=\"purple\">    Future Dev build = #{future_build}     Expected release date #{future_build_expected_release}</p>"

    columns = 0
    # html +="<form>"

    html +=  "<table border=\"1\" style=\"width:1600px\">"
    environments.each do |env|

      if columns ==0 || columns ==3 || columns ==6 || columns ==9 || columns==12 || columns==15
        html +="<tr>"
      end
      html+="<td>"
      #status
      results = client.query("select status,last_branch, date_of_branch,database_refresh,titan_last_branch,titan_date_of_branch,hermes_last_branch, hermes_date_of_branch,notes,installSha, titan_InstallSha, Hermes_InstallSha, EnviroStatus,hermes_core_db_refresh, owner, pluto_date_of_branch, pluto_install_sha, pluto_server, campaign_data from environments where environment_name ='#{env}'")
      # puts "#{environments} results= #{results}"
      results.each(:as => :array) do |row|

        html +="<h2><a href=\"/results\">#{env} </a> <font  size ='4'>&nbsp;&nbsp;&nbsp;&nbsp;#{row[14]} </font></h2> "


        if row[0] == "Idle"
          html += "<h4><label><b>Automation Status: </b></label> <font color=\"green\"> <b>#{row[0]}</b></font><br><label><b>PrimeBranch: </b></label><label{text-allign: right;}> <font color=\"orange\">  #{row[1]}</font><br><label><b>Titan Branch:</b> <font color=\"brown\">  #{row[4]} </font></label><br><label><b>Hermes Branch:</b> <font color=\"pink\"> #{row[6]}</font></label><br><label><b>Pluto Sha:</b> <font color=\"purple\"> #{row[16]}</font></label><br><label><br><b>Campaign Info  -second number is the number of members in that campaign</b><br><div style='padding:2rem; margin:0 1rem; border:1px solid black;'> <pre>#{row[18]}</pre></div></label><br></h4>"
        elsif  row[0] == "Running"
          html += "<h4><label><b>Automation Status: </b></label> <font color=\"red\"> <b>#{row[0]}</b></font><br><label><b>PrimeBranch: </b></label><label{text-allign: right;}> <font color=\"orange\">  #{row[1]}</font><br><label><b>Titan Branch:</b> <font color=\"brown\">  #{row[4]} </font></label><br><label><b>Hermes Branch:</b> <font color=\"pink\"> #{row[6]}</font></label><br><label><b>Pluto Sha:</b> <font color=\"purple\"> #{row[16]}</font></label><br><label><br><b>Campaign Info  -second number is the number of members in that campaign</b><br><div style='padding:2rem; margin:0 1rem; border:1px solid black;'> <pre>#{row[18]}</pre></div></label><br></h4>"
        end
      end
      columns= columns+1

      # OS
      html +="</td>"
      if columns == 3 || columns ==6 ||columns ==9 || columns==12 || columns==15

        html +="</tr>"
      end

    end

    html +="</form>"




    #        html+="<a href=\"/results\"><button>Results</button></a>  "
    # html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
    #  html+="<a href=\"/initial\"><button>Environment Overview</button></a>  "


    #html += "<input type='submit'></form></body></html>"
    client.close #close those dirty connections
    # Return OK (200), content-type: text/html, followed by the HTML itself
    return 200, "text/html", html
  end
end
class CampaignBehaviors< WEBrick::HTTPServlet::AbstractServlet
  @@postgresDB=""
  @@environment=""

  # Process the request, return response
  def do_GET(request, response)

    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)
    env="uat"
    campaign_id="11"

    url = request.request_uri.to_s
    interval =0
    if url.include?"?"
      params=url[(url.index('?')+1)..url.length]
      #  puts"#{params}"
      env= params[(params.index('env=')+4)..(params.index('&camp=')-1)]
      campaign_id = params[(params.index('&camp=')+6)..params.length]

    end
    @util=Utilities.new(env)

    # puts"#{env} \n #{campaign_id}"
    @@environment = env
    @util.set_dbs_for_environment


    fields,data,columns=@util.postgres_query("hermes","select distinct cb.id,bt.name, cb.window_starts_on, cb.visible_web_start_on
from campaigns c,  campaign_behaviors cb, behaviors b , behavior_translations bt
where   cb.campaign_id ='#{campaign_id}' and  cb.behavior_id = b.id and bt.behavior_id = b.id and bt.locale ='en' order by cb.id;;",true)     

    #
    html= "<html><META HTTP-EQUIV=\"refresh\" CONTENT=\"60\"><body>"
    html+="<h1>Behaviors in #{@@environment} for campaign_id #{campaign_id}</h1>"
    html+="<a href=\"/results\"><button>Results</button></a>  "
    html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
    html+="<a href=\"/campaign_count\"><button>Members In Campaign by Enviro</button></a>"
    html +="<table><table border=\"1\" style=\"width:1000px\">"
    html +="<tr><td>Behavior ID</td><td>Name</td><td>Starts On</td><td>Visible Web Starts on</td></tr>"




    data.each do |row|
      html +="<tr><td>#{row['id']}</td><td>#{row['name']}</td><td>#{row['window_starts_on']}</td><td>#{row['visible_web_start_on']}</td></tr>"
    end


    html +="</td></tr></table>"
    html +="<table><table border=\"1\" style=\"width:400px\"><tr><td><form action =\"/campaign_user_behavior\" METHOD=\"GET\" >
        <div style='padding:2rem; margin:0 1rem; '> <h4>Find eligible unactivated member in a campaign</h4>
     <input type=\"radio\" name =\"env\" value=\"uat\">UAT<br>
     <input type=\"radio\" name =\"env\"value=\"qa1\">QA1<br>
     <input type=\"radio\" name =\"env\"value=\"qa2\">QA2<br>
     <input type=\"radio\" name =\"env\"value=\"qa3\">QA3<br>
     <input type=\"radio\" name =\"env\"value=\"qa4\">QA4<br>
     <input type=\"radio\" name =\"env\"value=\"qa5\">QA5<br>
     <input type=\"radio\" name =\"env\"value=\"qdev\">QDEV<br>
     <input type=\"radio\" name =\"env\"value=\"staging\">Staging <br>

      Enter the campaign id
   <br>
       <input type=\"text\" name=\"camp\">
<br>

      Enter the behavior id
   <br>
       <input type=\"text\" name=\"behav\">
       <br>

     

       <input type=\"submit\"/></td></tr></div></form>"



    return 200, "text/html", html
  end

end

class InitialDetails < WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)
    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)

    html   = "<html><META HTTP-EQUIV=\"refresh\" CONTENT=\"60\"><body>"
    html +="<h1>Staging/Production Servers</h1>"
    html+="<p>Branch, installDate and install SHA are all chef reported.  Symlink is the current symlink reported on the server</p><br>"
    html+="<a href=\"/results\"><button>Results</button></a>  "
    html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
    html+="<a href=\"/campaign_count\"><button>Members In Campaign by Enviro</button></a>"
    # html +="<button type=\"button\" onClick=\"/Users/qa-user/Desktop/scripts/AllEnviroBuckedStatus.rb\">REFRESH</button>"

    environments =["production","staging"]

    client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")


    environments.each do |env|
      results = client.query("select server_role, serverApp, server_ip,branch, installDate,symlink, installSha from multi_server_environments where environment_name='#{env}' order by environment_name asc, serverApp asc,server_role asc")

      headers = results.fields # <= that's an array of field names, in order

      html += "<p style=\"font-size:8px\">"
      html +="<h2>#{env}</h2>"
      html +=  "<table border=\"1\" style=\"width:1000px\" >"
      html +="<tr><b>"
      for i in 0..6

        html += "<td>#{headers[i]}</td>"

      end
      html +="</tr></b>"


      results.each(:as => :array) do |row|
        html +="<tr>"
        for i in 0..6
          html += "<td style=\"font-size:12px\">#{row[i]}</td>"
        end
        html +="</tr>"
      end
      html +="</table> <p style=\"font-size:20px\">"
    end
    # Return OK (200), content-type: text/plain, and a plain-text "Saved! Thank you." notice
    client.close #close those dirty connections
    return 200, "text/html", html
  end
end
class Details < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    status, content_type, body = get_details(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def get_details(request)
    # Check if the user provided a name
    osQry=0
    brwsQry =0
    branchQry = 0
    url = request.request_uri.to_s
    params = url[(url.index('?')+1)..url.length]
    enviro = params[params.index('=')+1..params.index('&')-1]
    params = params[params.index('&')+1..params.length]
    status = params[params.index('=')+1..params.index('&')-1]
    if params.include?"&os"

      params = params[params.index('&')+1..params.length]
      os = params[params.index('=')+1..params.index('&')-1]
      osQry=1
    end
    if params.include?"browser"
      #puts "params before = #{params}\n"
      params = params[params.index('&')+1..params.length]
      # puts "params = #{params}\n"
      # puts " location of = #{params.index('=')+1}\n"
      # puts "params length = #{params.length}\n"
      # puts "location of & #{params.index('&')-1}\n"
      browser = params[params.index('=')+1..params.index('&')-1]
      browser = browser.gsub("%20"," ")
      brwsQry =1
    end
    if params.include?"branch"
      #puts "params before = #{params}\n"
      params = params[params.index('&')+1..params.length]
      # puts "params = #{params}\n"
      # puts " location of = #{params.index('=')+1}\n"
      # puts "params length = #{params.length}\n"
      # puts "location of & #{params.index('&')-1}\n"
      branch = params[params.index('=')+1..params.index('&')-1]
      branch = branch.gsub("%20"," ")
      branch = branch.rstrip
      branchQry =1
    end
    params = params[params.index('&')+1..params.length]
    offset = params[params.index('=')+1..params.length]

    client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation'

    html   = "<html><body>"
    html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  <br> "
    if osQry==1
      #query="select test_name,os,browser,enviro,status,date_run,branch,manual_check,id as results_ID,image from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and enviro ='#{enviro}' and status ='#{status}' and os ='#{os}' order by test_name"
      query = "select r.test_name,tc.description,r.os,r.browser,r.enviro,r.status,r.date_run,r.branch,r.id as results_ID,r.image, tc.priority , r.artifacts from results r left join test_cases tc  on r.test_name =tc.test_name where convert(varchar(10),r.date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and r.enviro ='#{enviro}' and r.status ='#{status}' and r.os ='#{os}' order by priority,test_name"

      if status =="BOTH"
        query = query.gsub!"r.status ='BOTH'","r.status in ('Passed','Failed')"
      end

      results = client.execute("#{query}")

    elsif brwsQry==1
      #puts browser

      #query ="select test_name,os,browser,enviro,status,date_run,branch,manual_check,id as results_ID,image from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and enviro ='#{enviro}' and status ='#{status}' and browser ='#{browser}' order by test_name"
      query ="select r.test_name,tc.description,r.os,r.browser,r.enviro,r.status,r.date_run,r.branch,r.id as results_ID,r.image, tc.priority, r.artifacts from results r left join test_cases tc  on r.test_name =tc.test_name where convert(varchar(10),r.date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and r.enviro ='#{enviro}' and r.status ='#{status}' and r.browser ='#{browser}'  order by priority,test_name"
      if status =="BOTH"
        query = query.gsub!"r.status ='BOTH'","r.status in ('Passed','Failed')"
      end

      # puts "#{query}"
      results = client.execute("#{query}")
    elsif branchQry==1
      #puts browser

      #query ="select test_name,os,browser,enviro,status,date_run,branch,manual_check,id as results_ID,image from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and enviro ='#{enviro}' and status ='#{status}' and branch ='#{branch}' order by test_name"
      query ="select r.test_name,tc.description,r.os,r.browser,r.enviro,r.status,r.date_run,r.branch,r.id as results_ID,r.image, tc.priority, r.artifacts from results r left join test_cases tc  on r.test_name =tc.test_name where convert(varchar(10),r.date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and r.enviro ='#{enviro}' and r.status ='#{status}' and r.branch ='#{branch}'  order by priority, test_name"
      if status =="BOTH"
        query = query.gsub!"r.status ='BOTH'","r.status in ('Passed','Failed')"
      end
      # puts "#{query}"
      #results = client.execute("select r.test_name,tc.description,r.os,r.browser,r.enviro,r.status,r.date_run,r.branch,r.id as results_ID,r.image from results r, test_cases tc where convert(varchar(10),r.date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and r.enviro ='#{enviro}' and r.status ='#{status}' and r.browser ='#{browser}'  and r.test_name =tc.test_name order by test_name" )
      results = client.execute("#{query}")
    else
      # query="select test_name,os,browser,enviro,status,date_run,branch,manual_check,id as results_ID,image from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and enviro ='#{enviro}' and status ='#{status}' order by test_name"
      query = "select r.test_name,tc.description,r.os,r.browser,r.enviro,r.status,r.date_run,r.branch,r.id as results_ID,r.image, tc.priority, r.artifacts from results r left join test_cases tc  on r.test_name =tc.test_name where convert(varchar(10),r.date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and r.enviro ='#{enviro}' and r.status ='#{status}'  order by priority, test_name"
      if status =="BOTH"
        query = query.gsub!"r.status ='BOTH'","r.status in ('Passed','Failed')"
      end



      results = client.execute("#{query}")
    end
    #puts "#{query}"
    headers = results.fields # <= that's an array of field names, in order
    #this is a hack to make the results show up.  Not sure why
    results.each(:as => :array) do |row|
      row[0]
    end
    time = Time.new
    time = time -(offset.to_i * 86400 )


    dateName = "#{time.month}/#{time.day}/#{time.year}"

    html += "<label><b>Number of records = #{results.count} for #{enviro} that #{status} on #{dateName}</b></br>"
    html += "<label><b>Click on the test_name for a description of the test and an example of a passed test.  Click on the ID for the specific run test</b></br>"

    html += "<p style=\"font-size:8px\">"
    html +=  "<table border=\"1\" style=\"width:1000px\" >"
    html +="<tr><b>"
    for i in 0..10
      if(i==6) #sort order page
        if osQry==1
          html +="<td><a href=\"/details2?enviro=#{enviro}&status=#{status}&os=#{os}&dateoffset=#{offset}\">#{headers[i]}</a></td>"
        elsif brwsQry==1
          html +="<td><a href=\"/details2?enviro=#{enviro}&status=#{status}&browser=#{browser}&dateoffset=#{offset}\">#{headers[i]}</a></td>"
        else
          html +="<td><a href=\"/details2?enviro=#{enviro}&status=#{status}&dateoffset=#{offset}\">#{headers[i]}</a></td>"
        end
      else
        html += "<td>#{headers[i]}</td>"
      end
    end
    html +="</tr></b>"

    debugcount = 0
    results.each(:as => :array) do |row|
      html +="<tr>"
      for i in 0..10
        if i ==0
          html += "<td style=\"font-size:10px\"><a href=\"/testdesc?#{row[i]}\"><b>  #{row[i]} </b></a></td>"
        elsif i<8 && i>0 || i ==10
          if i== 5 && (row[i].strip == "Failed")
            html += "<td style=\"font-size:14px\"><font color=\"red\"> #{row[i]}</font></td>"
          else
            html += "<td style=\"font-size:12px\">#{row[i]}</td>"
          end
        elsif i ==8
          html += "<td style=\"font-size:10px\"><a href=\"/specifictest?#{row[i]}\"><b>  #{row[i]} </b> <br></a></td>"
        elsif i ==9
      #    html += "<td style=\"font-size:10px\"><a href=\"http://dexw5171.hr-applprep.de:8001/#{row[i]}.png\" target=\"_blank\"><b>  #{row[i]} </b></a><br>"
          html += "<td style=\"font-size:10px\"><br>"
      
          if row[11]
            artifacts = row[11].split(",")
            artifacts.each do |artifact|
              artifact.slice! "["
              artifact.slice! "]"
              artifact.slice! "\"Y:\\\\\\\\AutomationLogs\\\\"
              artifact = artifact.gsub('\\\\\\\\\\\\','/')
              artifact = artifact.gsub("\"","")
              artifact.strip!
              if artifact.include?('\\')
              shortArtifact = artifact[(artifact.rindex('\\') + 1)..(artifact.length-2)]
            else
             shortArtifact = artifact
             end 
              html += "<a href=\"#{artifact}\" target=\"_blank\"><b>  #{shortArtifact} </b><br></a>"
            end
          end

          html += "</td>"
        end
      end
      html +="</tr>"

    end
    html +="</table> <p style=\"font-size:20px\">"
    # Return OK (200), content-type: text/plain, and a plain-text "Saved! Thank you." notice
    client.close #close those dirty connections
    return 200, "text/html", html
  end


end
class Details2 < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    status, content_type, body = get_details(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def get_details(request)
    # Check if the user provided a name
    osQry=0
    brwsQry =0
    branchQry = 0
    url = request.request_uri.to_s
    params = url[(url.index('?')+1)..url.length]
    enviro = params[params.index('=')+1..params.index('&')-1]
    params = params[params.index('&')+1..params.length]
    status = params[params.index('=')+1..params.index('&')-1]
    if params.include?"&os"

      params = params[params.index('&')+1..params.length]
      os = params[params.index('=')+1..params.index('&')-1]
      osQry=1
    end
    if params.include?"browser"
      #puts "params before = #{params}\n"
      params = params[params.index('&')+1..params.length]
      # puts "params = #{params}\n"
      # puts " location of = #{params.index('=')+1}\n"
      # puts "params length = #{params.length}\n"
      # puts "location of & #{params.index('&')-1}\n"
      browser = params[params.index('=')+1..params.index('&')-1]
      browser = browser.gsub("%20"," ")
      brwsQry =1
    end
    if params.include?"branch"
      #puts "params before = #{params}\n"
      params = params[params.index('&')+1..params.length]
      # puts "params = #{params}\n"
      # puts " location of = #{params.index('=')+1}\n"
      # puts "params length = #{params.length}\n"
      # puts "location of & #{params.index('&')-1}\n"
      branch = params[params.index('=')+1..params.index('&')-1]
      branch = branch.gsub("%20"," ")
      branch = branch.rstrip
      branchQry =1
    end
    params = params[params.index('&')+1..params.length]
    offset = params[params.index('=')+1..params.length]

    client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation'

    html   = "<html><body>"
    html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  <br> "
    if osQry==1
      #query="select test_name,os,browser,enviro,status,date_run,branch,manual_check,id as results_ID,image from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and enviro ='#{enviro}' and status ='#{status}' and os ='#{os}' order by test_name"
      query = "select r.test_name,tc.description,r.os,r.browser,r.enviro,r.status,r.date_run,r.branch,r.id as results_ID,r.image, tc.priority, r.artifacts from results r left join test_cases tc  on r.test_name =tc.test_name where convert(varchar(10),r.date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and r.enviro ='#{enviro}' and r.status ='#{status}' and r.os ='#{os}' order by date_run"
      if status =="BOTH"
        query = query.gsub!"r.status ='BOTH'","r.status in ('Passed','Failed')"
      end

      results = client.execute("#{query}")

    elsif brwsQry==1
      #puts browser

      #query ="select test_name,os,browser,enviro,status,date_run,branch,manual_check,id as results_ID,image from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and enviro ='#{enviro}' and status ='#{status}' and browser ='#{browser}' order by test_name"
      query ="select r.test_name,tc.description,r.os,r.browser,r.enviro,r.status,r.date_run,r.branch,r.id as results_ID,r.image, tc.priority, r.artifacts from results r left join test_cases tc  on r.test_name =tc.test_name where convert(varchar(10),r.date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and r.enviro ='#{enviro}' and r.status ='#{status}' and r.browser ='#{browser}'  order by date_run"
      if status =="BOTH"
        query = query.gsub!"r.status ='BOTH'","r.status in ('Passed','Failed')"
      end

      # puts "#{query}"
      results = client.execute("#{query}")
    elsif branchQry==1
      #puts browser

      #query ="select test_name,os,browser,enviro,status,date_run,branch,manual_check,id as results_ID,image from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and enviro ='#{enviro}' and status ='#{status}' and branch ='#{branch}' order by test_name"
      query ="select r.test_name,tc.description,r.os,r.browser,r.enviro,r.status,r.date_run,r.branch,r.id as results_ID,r.image, tc.priority, r.artifacts from results r left join test_cases tc  on r.test_name =tc.test_name where convert(varchar(10),r.date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and r.enviro ='#{enviro}' and r.status ='#{status}' and r.branch ='#{branch}'   order by date_run"
      if status =="BOTH"
        query = query.gsub!"r.status ='BOTH'","r.status in ('Passed','Failed')"
      end
      # puts "#{query}"
      #results = client.execute("select r.test_name,tc.description,r.os,r.browser,r.enviro,r.status,r.date_run,r.branch,r.id as results_ID,r.image from results r, test_cases tc where convert(varchar(10),r.date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and r.enviro ='#{enviro}' and r.status ='#{status}' and r.browser ='#{browser}'  and r.test_name =tc.test_name order by test_name" )
      results = client.execute("#{query}")
    else
      # query="select test_name,os,browser,enviro,status,date_run,branch,manual_check,id as results_ID,image from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and enviro ='#{enviro}' and status ='#{status}' order by test_name"
      query = "select r.test_name,tc.description,r.os,r.browser,r.enviro,r.status,r.date_run,r.branch,r.id as results_ID,r.image, tc.priority, r.artifacts from results r left join test_cases tc  on r.test_name =tc.test_name where convert(varchar(10),r.date_run,10) = convert(varchar(10),DATEADD(day,-#{offset},getdate()),10) and r.enviro ='#{enviro}' and r.status ='#{status}'  order by date_run"
      if status =="BOTH"
        query = query.gsub!"r.status ='BOTH'","r.status in ('Passed','Failed')"
      end



      results = client.execute("#{query}")
    end
    #puts "#{query}"

    headers = results.fields # <= that's an array of field names, in order
    #this is a hack to make the results show up.  Not sure why
    results.each(:as => :array) do |row|
      row[0]
    end
    time = Time.new
    time = time -(offset.to_i * 86400 )


    dateName = "#{time.month}/#{time.day}/#{time.year}"

    html += "<label><b>Number of records = #{results.count} for #{enviro} that #{status} on #{dateName}</b></br>"
    html += "<label><b>Click on the test_name for a description of the test and an example of a passed test.  Click on the ID for the specific run test</b></br>"

    html += "<p style=\"font-size:8px\">"
    html +=  "<table border=\"1\" style=\"width:1000px\" >"
    html +="<tr><b>"
    for i in 0..10
      if(i==6)
        if osQry==1
          html +="<td><a href=\"/details2?enviro=#{enviro}&status=#{status}&os=#{os}&dateoffset=#{offset}\">#{headers[i]}</a></td>"
        elsif brwsQry==1
          html +="<td><a href=\"/details2?enviro=#{enviro}&status=#{status}&browser=#{browser}&dateoffset=#{offset}\">#{headers[i]}</a></td>"
        else
          html +="<td><a href=\"/details2?enviro=#{enviro}&status=#{status}&dateoffset=#{offset}\">#{headers[i]}</a></td>"
        end
      else
        html += "<td>#{headers[i]}</td>"
      end
    end
    html +="</tr></b>"

    debugcount = 0
    results.each(:as => :array) do |row|
      html +="<tr>"
      for i in 0..10
        if i ==0
          html += "<td style=\"font-size:10px\"><a href=\"/testdesc?#{row[i]}\"><b>  #{row[i]} </b></a></td>"
        elsif i<8 && i>0 || i ==10
          if i== 5 && (row[i].strip == "Failed")
            html += "<td style=\"font-size:14px\"><font color=\"red\"> #{row[i]}</font></td>"
          else
            html += "<td style=\"font-size:12px\">#{row[i]}</td>"
          end
        elsif i ==8
          html += "<td style=\"font-size:10px\"><a href=\"/specifictest?#{row[i]}\"><b>  #{row[i]} </b></a></td>"
        elsif i ==9
          html += "<td style=\"font-size:10px\"><br>"
      
          if row[11]
            artifacts = row[11].split(",")
            artifacts.each do |artifact|
              artifact.slice! "["
              artifact.slice! "]"
              artifact.slice! "\"Y:\\\\\\\\AutomationLogs\\\\"
              artifact = artifact.gsub('\\\\\\\\\\\\','/')
              artifact = artifact.gsub("\"","")
              artifact.strip!
              if artifact.include?('\\')
              shortArtifact = artifact[(artifact.rindex('\\')+1)..artifact.length-2]
            else
              shortArtifact = artifact
            end
              html += "<a href=\"#{artifact}\" target=\"_blank\"><b>  #{shortArtifact} </b><br></a>"
            end
          end

          html += "</td>"
        end
      end
      html +="</tr>"

    end
    html +="</table> <p style=\"font-size:20px\">"
    # Return OK (200), content-type: text/plain, and a plain-text "Saved! Thank you." notice
    client.close #close those dirty connections
    return 200, "text/html", html
  end


end
class Trends < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    status, content_type, body = get_trends(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def get_trends(request)
    require 'googlecharts'
    url = request.request_uri.to_s

    env = url[(url.index('?')+1)..url.length]

    time = Time.new
    passed = Array.new(30)
    failed = Array.new(30)
    day = Array.new(30)

    #  env ="uat"
    client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation'

    for interval in 0..29 do
        newPassed = "select distinct (select count('status')  from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10)  and status =\"Passed\" and enviro =\"#{env}\" ) as passed from results"
        results = client.execute(newPassed)
        results.each(:as => :array) do |row|
          passed[interval]=row[0]
        end
        #Failed
        newFailed = "select distinct (select count('status')  from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10)  and status =\"failed\" and enviro =\"#{env}\" ) as passed from results"
        results = client.execute(newFailed)
        results.each(:as => :array) do |row|
          failed[interval]=row[0]
        end
        daytime=time -(interval.to_i * 86400 )
        # day[interval]= "#{daytime.month}/#{daytime.day}/#{daytime.year}"
        day[interval] ="#{daytime.day}"
      end
      max_value = 0
      for interval in 0..29 do
          if max_value < passed[interval].to_i
            max_value= passed[interval].to_i
          end
          #puts "max_value =#{max_value}"
        end

        html   = "<html><META HTTP-EQUIV=\"refresh\" CONTENT=\"60\"><body><form method='POST' action='/save'>"
        html +="<img src =\""
        html+= Gchart.line(:title => "30 Day trend",
                           :data => [[passed[29], passed[28], passed[27], passed[26], passed[25], passed[24], passed[23],passed[22], passed[21], passed[20], passed[19], passed[18], passed[17], passed[16],passed[15], passed[14], passed[13], passed[12], passed[11], passed[10], passed[9],passed[8], passed[7], passed[6], passed[5], passed[4], passed[3], passed[2],passed[1], passed[0]],[failed[29], failed[28],failed[27], failed[26], failed[25], failed[24], failed[23], failed[22], failed[21],failed[20], failed[19], failed[18], failed[17], failed[16], failed[15], failed[14],failed[13], failed[12], failed[11], failed[10], failed[9], failed[8], failed[7],failed[6], failed[5], failed[4], failed[3], failed[2], failed[1], failed[0]]],
                           :bar_colors => '00FF00,FF0000',
                           :stacked => true,
                           #:size => '760x400',
                           :thickness => '2',
                           :width => '750',
                           :height => '400',
                           :legend => ["Passed", "Failed"],
                           :axis_with_labels => [['x'],['y']],
                           :max_value => max_value,
                           :min_value => 0,
                           :axis_labels => [["#{day[29]}|#{day[28]}|#{day[27]}|#{day[26]}|#{day[25]}|#{day[24]}|#{day[23]}|#{day[22]}|#{day[21]}|#{day[20]}|#{day[19]}|#{day[18]}|#{day[17]}|#{day[16]}|#{day[15]}|#{day[14]}|#{day[13]}|#{day[12]}|#{day[11]}|#{day[10]}|#{day[9]}|#{day[8]}|#{day[7]}|#{day[6]}|#{day[5]}|#{day[4]}|#{day[3]}|#{day[2]}|#{day[1]}|#{day[0]}"]])
        #
        html +="\"></img>"
        client.close #close those dirty connections
        return 200, "text/html",html

      end


    end
    class SpecificTest < WEBrick::HTTPServlet::AbstractServlet

      def do_GET(request, response)
        status, content_type, body = get_specifics(request)

        response.status = status
        response['Content-Type'] = content_type
        response.body = body
      end

      def get_specifics(request)
        # Check if the user provided a name
        osQry=0
        brwsQry =0
        url = request.request_uri.to_s
        recordnum= url[(url.index('?')+1)..url.length]
        client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation'
        client.execute('SET TEXTSIZE 2147483647')

        html   = "<html><body><form method='POST' action='/save'>"
        html += "<p style=\"font-size:8px\">"
        html +=  "<table border=\"1\" style=\"width:1600px\" >"


        results = client.execute("select results, image, artifacts from results where id =\"#{recordnum}\"" )

        results.each(:as => :array) do |row|
          html +="<tr>"
          formattedText= row[0].gsub(/\n/, "<br/>")
          html += "<td style=\"font-size:10px\">"
          if row[2] != nil
            artifacts = row[2].split(",")
            artifacts.each do |artifact|
              artifact.slice! "["
              artifact.slice! "]"
              artifact.slice! "\"Y:\\\\\\\\AutomationLogs\\\\"
              artifact = artifact.gsub('\\\\\\\\\\\\','/')
              artifact = artifact.gsub("\"","")
              artifact.strip!
              if artifact.include?('\\')
              shortArtifact = artifact[(artifact.rindex('\\') + 1)..(artifact.length-1)]
            else
             shortArtifact = artifact
             end 
              html += "<a href=\"#{artifact}\" target=\"_blank\"><b>  #{shortArtifact} </b><br></a>"
            end
          end
          html += "</td>"
          html += "<td style=\"font-size:12px\">#{formattedText}</td>"


          html +="</tr>"
        end
        html +="</table> <p style=\"font-size:20px\">"
        # Return OK (200), content-type: text/plain, and a plain-text "Saved! Thank you." notice
        client.close #close those dirty connections
        return 200, "text/html", html
      end
    end
    class TestDescription < WEBrick::HTTPServlet::AbstractServlet

      def do_GET(request, response)
        status, content_type, body = get_description(request)

        response.status = status
        response['Content-Type'] = content_type
        response.body = body
      end

      def get_description(request)
        # Check if the user provided a name
        osQry=0
        brwsQry =0
        url = request.request_uri.to_s
        testname= url[(url.index('?')+1)..url.length]



        client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation'
        client.execute('SET TEXTSIZE 2147483647')
        html   = "<html><body><form method='POST' action='/save'>"
        html += "<p style=\"font-size:8px\">"
        html +=  "<table border=\"1\" style=\"width:1000px\" >"
        html +=  "<tr><td>Description</td><td>Test Step(s)</td><td>Detailed Description</Td><td>Expected Results</td></tr>"
        results = client.execute("select description,[testStep(s)],DetailedDescription,ExpectedResults from test_cases where test_name =\"#{testname}\"" )

        results.each do |row|
          html +="<tr>"
          formattedText= row["description"].gsub(/\n/, "<br/>")
          # puts"length = #{row[0].length}"
          #formattedText=row[0]
          html += "<td style=\"font-size:12px\">#{formattedText}</td>"
          testStepsText= row["testStep(s)"].gsub(/\n/, "<br/>")
          # puts"length = #{row[0].length}"
          #formattedText=row[0]
          html += "<td style=\"font-size:12px\">#{testStepsText}</td>"
          detailedDescription = row["DetailedDescription"].gsub(/\n/, "<br/>")
          # puts"length = #{row[0].length}"
          #formattedText=row[0]
          html += "<td style=\"font-size:12px\">#{detailedDescription}</td>"
          expectedResults = row["ExpectedResults"].gsub(/\n/, "<br/>")
          # puts"length = #{row[0].length}"
          #formattedText=row[0]
          html += "<td style=\"font-size:12px\">#{expectedResults}</td>"
          html +="</tr>"

        end
        html +="</table> <p style=\"font-size:20px\">"
        # Return OK (200), content-type: text/plain, and a plain-text "Saved! Thank you." notice
        client.close #close those dirty connections
        return 200, "text/html", html
      end
    end
    class TestListing < WEBrick::HTTPServlet::AbstractServlet

      def do_GET(request, response)
        status, content_type, body = get_description(request)

        response.status = status
        response['Content-Type'] = content_type
        response.body = body
      end

      def get_description(request)
        # Check if the user provided a name


        #client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")
        client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation'

        html   = "<html><body>"
 # html +="<script> function runningTest(){ document.getElementById('runLabel').innerHTML = 'Test is running! Wait for page to refresh!'; }</script>"

#  html +=" <p id=\"demo\" onclick=\"myFunction()\">Click me.</p>"

# html += "<script>
# function myFunction() {
#   document.getElementById(\"demo\").innerHTML = \"YOU CLICKED ME!\";
# }
# </script>"

        html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
        html +="<a href=\"http://dexw5171.hr-applprep.de:8001/doc/top-level-namespace.html\" target=\"_blank\"><button>Methods</button></a>"

        html+="<a href=\"/results\"><button>QA Results page</button></a>  "
        html +="<br>Run tests in<table><tr>"
         html+="<td><a href=\"http://dexw5171.hr-applprep.de:8000/testrunner\"><button>QA_UK</button></a>  "
         html+="<a href=\"http://detw5126.hr-appltest.de:8000/testrunner\"><button>DEV_UK</button></a>  "
         html+="<a href=\"http://USTW5032.hr-appltest.de:8000/testrunner\"><button>DEV_US</button></a> </table> "
        html += "<p style=\"font-size:8px\">"
        html += "<font color=\"red\"><label style=\"font-size:14px\" id =\"runLabel\"></label>"
        html +=  "<table border=\"1\" style=\"width:1000px\" >"
        # html += "<td style=\"font-size:12px\"><b>Test Name </b></td><td>qa1</td><td>qa2</td><td>qa3</td><td>qa4</td><td>qa5</td><td>qa6</td><td>uat</td><td>staging</td><td>windows</td><td>mac</td><td>smoke</td>"
        html += "<td style=\"font-size:12px\"><b>Test Name </b></td><td>Description</td><td>Jira Link</td>"

        html +="</tr>"

        results = client.execute("select * from test_cases order by test_name asc" )

        results.each do |row|
          html +="<tr>"
          #formattedText= row[0].gsub(/\n/, "<br/>")
          html += "<td style=\"font-size:12px\"><a href=\"/testdesc?#{row['test_name']}\"><b>  #{row['test_name']} </b></a></td><td>#{row['description']}</td><td>"
          if row['jiraLink']
            html += "<a href=\"#{row['jiraLink']}\"><b> link</td>"
          else
            html += "</td>"

          end
      #    html +="<td><td style=\"font-size:12px\"><a onclick =\"runningTest()\" href=\"/refresher3?test=#{row['test_name']}\"><b> <button onclick =\"runningTest()\">RUN</button> </b></a></td>"
          # html += "<td style=\"font-size:12px\"><a href=\"/testdesc?#{row[0]}\"><b>  #{row[0]} </b></a></td><td>#{row[2]}</td><td>#{row[3]}</td><td>#{row[4]}</td><td>#{row[5]}</td><td>#{row[6]}</td><td>#{row[7]}</td><td>#{row[8]}</td><td>#{row[9]}</td><td>#{row[10]}</td><td>#{row[11]}</td>"

          html +="</tr>"
        end
        html +="</table> <p style=\"font-size:20px\">"
        # Return OK (200), content-type: text/plain, and a plain-text "Saved! Thank you." notice
        client.close #close those dirty connections
        return 200, "text/html", html
      end
    end
     class TestRunner < WEBrick::HTTPServlet::AbstractServlet

      def do_GET(request, response)
        status, content_type, body = get_description(request)

        response.status = status
        response['Content-Type'] = content_type
        response.body = body
      end

      def get_description(request)
        # Check if the user provided a name


        #client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")
        client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation'

        html   = "<html><head>"
         html += "<style> 
  p.a {
    display : inline;
  }
  </style>
        <body>"
  html +="<script> function runningTest(){ document.getElementById('runLabel').innerHTML = 'Test is running.  Page will refresh with results when the test is completed.'; var elements = document.getElementsByClassName('a'); for (i = 0;i < elements.length; i++){elements[i].style.display = \"none\";} }</script>"
 
#  html +=" <p id=\"demo\" onclick=\"myFunction()\">Click me.</p>"

# html += "<script>
# function myFunction() {
#   document.getElementById(\"demo\").innerHTML = \"YOU CLICKED ME!\";
# }
# </script>"

        html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
        html +="<a href=\"http://dexw5171.hr-applprep.de:8001/doc/top-level-namespace.html\" target=\"_blank\"><button>Methods</button></a>"

        html+="<a href=\"/results\"><button>QA Results page</button></a>  "

       # html += "<p style=\"font-size:8px\">"
        html += "<font color=\"red\"><label style=\"font-size:20px\" id =\"runLabel\"></label>"
        html +=  "<table border=\"1\" style=\"width:1000px\" >"
        # html += "<td style=\"font-size:12px\"><b>Test Name </b></td><td>qa1</td><td>qa2</td><td>qa3</td><td>qa4</td><td>qa5</td><td>qa6</td><td>uat</td><td>staging</td><td>windows</td><td>mac</td><td>smoke</td>"
        html += "<td style=\"font-size:12px\"><b>Test Name </b></td><td>Description</td><td>Jira Link</td><td>Click to Run</td>"

        html +="</tr>"

        results = client.execute("select * from test_cases where webrunner = 1 order by test_name asc" )

        results.each do |row|
          html +="<tr>"
          #formattedText= row[0].gsub(/\n/, "<br/>")
          html += "<td style=\"font-size:12px\"><a href=\"/testdesc?#{row['test_name']}\"><b>  #{row['test_name']} </b></a></td><td>#{row['description']}</td><td>"
          if row['jiraLink']
            html += "<a href=\"#{row['jiraLink']}\"><b> link</td>"
          else
            html += "</td>"

          end
          html +="<td><p class=\"a\"><a  onclick =\"runningTest()\" href=\"/refresher3?test=#{row['test_name']}\"><b> <button class='runButton'  onclick =\"runningTest()\">RUN</button> </b></a></p></td>"
          # html += "<td style=\"font-size:12px\"><a href=\"/testdesc?#{row[0]}\"><b>  #{row[0]} </b></a></td><td>#{row[2]}</td><td>#{row[3]}</td><td>#{row[4]}</td><td>#{row[5]}</td><td>#{row[6]}</td><td>#{row[7]}</td><td>#{row[8]}</td><td>#{row[9]}</td><td>#{row[10]}</td><td>#{row[11]}</td>"

          html +="</tr>"
        end
        html +="</table> <p style=\"font-size:20px\">"
        # Return OK (200), content-type: text/plain, and a plain-text "Saved! Thank you." notice
        client.close #close those dirty connections
        return 200, "text/html", html
      end
    end
    class Tabbed < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(request, response)
        status, content_type, body = get_tab(request)

        response.status = status
        response['Content-Type'] = content_type
        response.body = body
      end

      # Construct the return HTML page
      def get_tab(request)
        previousDay = ""
        nextDay = ""
        url = request.request_uri.to_s
        if url.include?"?"
          date=url[(url.index('?')+1)..url.length]
          #convertedDate=Date.parse(date)
          convertedDate=Date::strptime(date,"%m/%d/%Y")
          #now=DateTime.now.strftime('%Y-%m-%d')
          now = Date.today
          # puts "date to search for is #{date} now is #{now}"
          interval = (now - convertedDate).to_i
          previousDay = (convertedDate -(1)).strftime("%m/%d/%Y")
          nextDay = (convertedDate +(1)).strftime("%m/%d/%Y")
          puts "interval = #{interval}  previousDay = #{previousDay} nextDay = #{nextDay}"

        else
          interval = 0
          time = Time.new
          time = time -(1 * 86400 )
          previousDay = "#{time.month}/#{time.day}/#{time.year}"
          puts "interval = #{interval}  previousDay = #{previousDay} nextDay = #{nextDay}"

        end
        time = Time.new
        time = time -(interval.to_i * 86400 )

        dateName = "#{time.month}/#{time.day}/#{time.year}"
        # html+= "<script type=\"text/javascript\" src=\"~/Desktop/Scripts/WebServer/domtab.js\"></script>"
        html ="<head>"
        html  += "<html><META HTTP-EQUIV=\"refresh\" CONTENT=\"60\" /><body  onLoad=\"tab('tab1')\">"
        #"<form method='GET' action='/save'>"
        html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
        ##hereChris    html +="<button onClick = \"run_dc_main\">Run dc Main on Prep </button>"

        #html +="<meta content=\"text/html; charset=utf-8\" HTTP-EQUIV=\"refresh\" CONTENT=\"60\" />"

        html +="<style type=\"text/css\">
#tabs ul {
padding: 0px;
margin: 0px;
margin-left: 0px;
list-style-type: none;
}

#tabs ul li {
display: inline-block;
clear: none;
float: left;
height: 34px;
}

#tabs ul li a {
position: relative;
margin-top: 16px;
display: block;
margin-left: 6px;
line-height: 38px;
padding-left: 5px;
background-color: #b2b2b2;


z-index: 9999;
border: 1px solid #ccc;
border-bottom: 0px;
-moz-border-radius-topleft: 4px;
border-top-left-radius: 4px;
-moz-border-radius-topright: 4px;
border-top-right-radius: 4px;
width: 120px;
color: #000000;
text-decoration: none;

}

#tabs ul li a:hover {
text-decoration: underline;
}

#tabs #Content_Area {
position: relative;
margin-top: 16px;
display: block;
margin-left: 6px;
line-height: 18px;
padding-left: 10px;
background: #f6f6f6;
z-index: 9999;
border: 1px solid #ccc;
border-bottom: 1px;
-moz-border-radius-topleft: 4px;
border-top-left-radius: 4px;
-moz-border-radius-topright: 4px;
border-top-right-radius: 4px;
-moz-border-radius-bottomleft: 4px;
border-bottom-left-radius: 4px;
-moz-border-radius-bottomright: 4px;
border-bottom-right-radius: 4px;

padding: 0 15px;
clear:both;
overflow:hidden;
line-height:19px;
position: relative;
top: 20px;
z-index: 5;
height: 700px;
overflow: hidden;
}

table {
  padding: 10px;  
  width:100%;
  min-width: 500px;
  border-collapse: collapse;
}
 td {

}
.style1{
    background-color: #b2b2b2!important;
}
.style2{
    background-color: #f6f6f6!important;
}
p { padding-left: 15px; }
</style>
<script language=\"JavaScript\">
function readCookie(name){
return(document.cookie.match('(^|; )'+name+'=([^;]*)')||0)[2]
}
</script>"
        #font-weight: bold;
        #html +="<link rel=\"stylesheet\" type=\"text/css\" href=\"/edit2.css\">"
        environments = Array.new
        description= Array.new
        status = Array.new
        mainVer = Array.new
        conductorVer = Array.new
        cdsVer = Array.new
        lrmVer = Array.new
        zenithVer = Array.new

        html += "</head>"

        html +="<h1>QA Automation Results for #{dateName} <a href=\"/?#{previousDay}\"><button>Previous Day</button></a>"
        if nextDay != ""
          html +="<a href=\"/?#{nextDay}\"><button>Next Day</button></a></h1>"
        else
          html += "</h1>"
        end
        client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation' , timeout: 60
        client.execute('SET TEXTSIZE 2147483647')
        resultsEnviro =client.execute('select environment_name, description, status, main_version, conductor_version,cds_version,lrm_version,zenith_version from environments order by tab_order')
        resultsEnviro.each do |env_vals|
          environments.push(env_vals["environment_name"].strip)
          status.push(env_vals["status"])
          description.push(env_vals["description"])
          mainVer.push(env_vals["main_version"].strip)
          conductorVer.push(env_vals["conductor_version"].strip)
          cdsVer.push(env_vals["conductor_version"].strip)
          lrmVer.push(env_vals["lrm_version"].strip)
          zenithVer.push(env_vals["zenith_version"].strip)
        end
        #environments =["prod-symphony","qa-symphony","dev-symphony","10.1.13.61","10.1.15.251","10.1.15.245","utilities"]
        html +="<form onLoad=\"tab('tab\"readCoookie('tab')\"' onLoad=\"tab('tab1')\" >"
        html +="<div id =\"Tabs\">"
        client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation' , timeout: 60
        client.execute('SET TEXTSIZE 2147483647')
        html +="<ul>"
        count =1

        environments.each do |env|

          #  html +=""
          html +="<li id=\"li_tab#{count}\"  onclick=\"tab('tab#{count}')\" onclick \"document.cookie='tab=#{count}'\"><a id='a_tab#{count}'>#{env}"

          #status
          results = client.execute("select status, software_version, date_of_branch from environments where environment_name ='#{env}'")
          results.each(:as => :array) do |row|
            if row[0] == "Idle"
              html += "<font color=\"green\"> <b>#{row[0]}</b></font><br><font size=\"1\">#{row[1]}</font></label></a></li>"
            elsif  row[0] == "Running"
              html += "</h2><font color=\"red\"> <b>#{row[0]}</b></font><br><label><font size=\"1\">#{row[1]}</font></label></a></li>"
            end

          end
          # end
          count = count +1
        end
        html +="</ul>"
        html+="<div id=\"Content_Area\" onLoad=\"tab('tab1')\">"
        count =1
        environments.each do |env|
          if count ==1 then
            html +="<div id='tab#{count}' style=\"display: show;\">"
          else
            html +="<div id='tab#{count}'  style=\"display: none;\">"
          end
          # html+="<h2><a name=\"#{env}\" id=\"#{env}\">#{env}</a></h2>"
          html +=  "<table>"
          html +="<tr><td>"

          html +="<h2><a href=\"/trends?#{env}\">#{env} </a>  </h2><p>#{description[count-1]}<br> Automation run status: #{status[count-1]}<br>Current Versions: DC: Main:#{mainVer[count-1]} Conductor:#{conductorVer[count-1]} CDS:#{cdsVer[count-1]} LRM:#{lrmVer[count-1]} Zenith:#{zenithVer[count-1]}</p>"

          #Passed
          passedVal=0
          newPassed = "select distinct (select count('status')  from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10)  and status =\"Passed\" and enviro =\"#{env}\" and browser !='headless' )  as passed from results"
          results = client.execute(newPassed)
          results.each(:as => :array) do |row|
            passedVal=row[0].to_i
            # puts "passedVal =#{passedVal}"
            html += "<label><a href=\"/details?enviro=#{env}&status=BOTH&dateoffset=#{interval}\"><b>ALL</b></a></label> <br><label><a href=\"/details?enviro=#{env}&status=Passed&dateoffset=#{interval}\"><b>Passed: </b></a></label> <font color=\"green\"> <b>#{row[0]}</b></font><br>"
          end
          #Failed
          failedVal=0
          newFailed = "select distinct (select count('status')  from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10)  and status =\"failed\" and enviro =\"#{env}\" and browser !='headless') as passed from results"
          results = client.execute(newFailed)
          results.each(:as => :array) do |row|
            failedVal=row[0].to_i
            #puts "failedVal=#{failedVal}"
            html += "<label><a href=\"/details?enviro=#{env}&status=Failed&dateoffset=#{interval}\"><b>Failed: </b></a></label> <font color=\"red\"><b>#{row[0]}</b></font><br>"
          end
          #Branch

          if passedVal>0
            # puts "passedVal =#{passedVal}"
            #puts "failedVal=#{failedVal}"
            percentage = (passedVal.to_f/(passedVal.to_f + failedVal.to_i) * 100)
            # puts percentage
            html +="<label>#{percentage.round(2)}\%</label>"
          end
          html +="</td></tr><tr><td>"
          results = client.execute("select distinct branch from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10) and enviro =\"#{env}\" and browser !='headless'" )
          html += "<label><b>Branch(s): </b>"
          branchHolderArray = Array.new
          a=0
          results.each(:as => :array) do |row|
            test=row[0].to_s
            if test.length >2
              # html += "<li></label>#{row[0]}</li>"
              branchHolderArray[a] = row[0]
              a = a + 1
            end
          end

          branchHolderArray.each do |branchHolder|
            html += "<li></label>#{branchHolder}"

            newPassed = "select distinct (select count('status')  from results where  convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10)  and status =\"Passed\" and enviro =\"#{env}\" and browser !='headless' and branch = '#{branchHolder}') as passed from results"
            #puts "newPassed = \n #{newPassed}"
            # puts "Os Holder =#{osHolder} so there"
            results = client.execute(newPassed)

            results.each(:as => :array) do |row|
              passedVal=row[0]
              html += "<label><a href=\"/details?enviro=#{env}&status=BOTH&branch=#{branchHolder}&dateoffset=#{interval}\"><b>  ALL</b></a></label><label> </label><label><a href=\"/details?enviro=#{env}&status=Passed&branch=#{branchHolder}&dateoffset=#{interval}\"><b>  Passed: </b></a></label> <font color=\"green\"> <b>#{row[0]}  </b></font>"
            end
            #Failed
            newFailed = "select distinct (select count('status')  from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10)  and status =\"Failed\" and enviro =\"#{env}\" and browser !='headless' and branch = '#{branchHolder}') as passed from results"
            results = client.execute(newFailed)
            results.each(:as => :array) do |row|
              failedVal=row[0]
              html += "<label><a href=\"/details?enviro=#{env}&status=Failed&branch=#{branchHolder}&dateoffset=#{interval}\"><b> Failed: </b></a></label> <font color=\"red\"><b>#{row[0]}  </b></font>"
            end
            if passedVal>0
              # puts "passedVal =#{passedVal}"
              #puts "failedVal=#{failedVal}"
              percentage = (passedVal.to_f/(passedVal.to_f + failedVal.to_i) * 100)
              # puts percentage
              html +="<label style=\"text-align: right;\">  ====>#{percentage.round(2)}\%</label></li>"
            end

          end


          # OS
          html +="</td></tr><tr><td>"
          results = client.execute("select distinct os from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10) and enviro =\"#{env}\" and browser !='headless'" )
          html += "<br><label><b>Tested OS(s): </b>"
          osHolderArray = Array.new
          oSName = Array.new
          a=0
          results.each(:as => :array) do |row|
            if row[0].include?("darwin")

              oSName[a]="Macintosh"
              osHolderArray[a] = "%darwin%"
            elsif row[0].include?('ming')
              oSName[a] = "Windows"
            end
            osHolderArray[a]="#{row[0]}"
            a= a +1
          end

          b = 0
          osHolderArray.each do |osHolder|
            html += "<li></label>#{oSName[b]}  "
            #Passed

            newPassed = "select distinct (select count('status')  from results where os like \"%#{osHolder}%\" and convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10)  and status =\"Passed\" and enviro =\"#{env}\" and browser !='headless') as passed from results"
            #puts "newPassed = \n #{newPassed}"
            # puts "Os Holder =#{osHolder} so there"
            results = client.execute(newPassed)
            cleanOsHolder = osHolder.strip!
            results.each(:as => :array) do |row|
              passedVal=row[0]
              html += "<label><a href=\"/details?enviro=#{env}&status=BOTH&os=#{cleanOsHolder}&dateoffset=#{interval}\"><b>ALL</b></a></label><label>  </label><label><a href=\"/details?enviro=#{env}&status=Passed&os=#{cleanOsHolder}&dateoffset=#{interval}\"><b>  Passed: </b></a></label> <font color=\"green\"> <b>#{row[0]}  </b></font>"
            end
            #Failed
            newFailed = "select distinct (select count('status')  from results where os like \"%#{osHolder}%\" and convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10)  and status =\"Failed\" and enviro =\"#{env}\" and browser !='headless') as passed from results"
            results = client.execute(newFailed)
            results.each(:as => :array) do |row|
              failedVal=row[0]
              html += "<label><a href=\"/details?enviro=#{env}&status=Failed&os=#{cleanOsHolder}&dateoffset=#{interval}\"><b> Failed: </b></a></label> <font color=\"red\"><b>#{row[0]}  </b></font>"
            end
            if passedVal>0
              # puts "passedVal =#{passedVal}"
              #puts "failedVal=#{failedVal}"
              percentage = (passedVal.to_f/(passedVal.to_f + failedVal.to_i) * 100)
              # puts percentage
              html +="<label style=\"text-align: right;\">  ====>#{percentage.round(2)}\%</label></li>"
            end
            b = b +1
          end
          #browser

          html +="</td></tr><tr><td>"
          html += "<br><label><b>Browser(s): </label></tr></td></b><table style=\"border-collapse: collapse;\">"
          results = client.execute("select distinct  browser from results where convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10) and enviro =\"#{env}\"  order by browser")


          browserHolder = Array.new

          i=0
          results.each(:as => :array) do |row|
            browserHolder[i] = "#{row[0]}"
            i= i +1
          end
          browserHolder.each do |browser|
            html += "<tr style=\"border:1px solid grey;\"><td style='width:1200px'><li></label><font size='3'>#{browser}<font size='3'></td>"
            #Passed
            newPassed = "select distinct (select count('status')  from results where browser = \"#{browser}\" and convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10)  and status =\"Passed\" and enviro =\"#{env}\" ) as passed from results"
            results = client.execute(newPassed)
            results.each(:as => :array) do |row|
              html += "<td style='width:200px'><label><a href=\"/details?enviro=#{env}&status=BOTH&browser=#{browser}&dateoffset=#{interval}\"><b>ALL</b></a></label><label> </label><label><a href=\"/details?enviro=#{env}&status=Passed&browser=#{browser}&dateoffset=#{interval}\"><b>  Passed: </b></a></label> <font color=\"green\"> <b>#{row[0]}  </b></font>"
            end
            #Failed
            newFailed = "select distinct (select count('status')  from results where browser = \"#{browser}\" and convert(varchar(10),date_run,10) = convert(varchar(10),DATEADD(day,-#{interval},getdate()),10)  and status =\"failed\" and enviro =\"#{env}\" ) as passed from results"
            results = client.execute(newFailed)
            results.each(:as => :array) do |row|
              html += "<label><a href=\"/details?enviro=#{env}&status=Failed&browser=#{browser}&dateoffset=#{interval}\"><b>  Failed: </b></a></label> <font color=\"red\"><b>#{row[0]}  </b></font></li></td></tr></div>"
            end
          end
          #  html+="</tab>"
          # html +="</form>"

          html +="</table></td></tr></table>"
          html += "<a href=\"http://dexw5171.hr-applprep.de:8000/refresher?env=#{env}\">Start DC Main</a><br>"
          html += "<a href=\"http://dexw5171.hr-applprep.de:8000/refresher2?env=#{env}\">Start DC Conductor</a><br>"
          count = count+1
          html +="</div>"
        end
        html +="</div>"
        html +="<script type=\"text/javascript\"> function tab(tab){"
        count =1
        environments.each do |env|
          html +="document.getElementById('tab#{count}').style.display = 'none';"
          html +="document.getElementById('li_tab#{count}').setAttribute(\"class\", \"\");"

          html +="document.getElementById('a_tab#{count}').setAttribute(\"class\", \"style1\");"
          count = count +1
        end
        html +="document.getElementById(tab).style.display = 'block';

document.getElementById('a_'+tab).setAttribute(\"class\", \"style2\");
document.getElementById('li_'+tab).setAttribute(\"class\", \"active\");

}
</script>"

        #     html +="<script type=\”text/javascript\”> function tab(tab) {
        # document.getElementById('tab1').style.display = 'none';
        # document.getElementById('tab2').style.display = 'none';
        # document.getElementById('tab3').style.display = 'none';
        # document.getElementById('tab4').style.display = 'none';
        # document.getElementById('tab5').style.display = 'none';
        # document.getElementById('tab6').style.display = 'none';
        # document.getElementById('tab7').style.display = 'none';
        # document.getElementById('tab8').style.display = 'none';
        # document.getElementById('li_tab1').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab2').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab3').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab4').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab5').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab6').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab7').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab8').setAttribute(\“class\”, \“\”);
        # document.getElementById(tab).style.display = 'block';
        # document.getElementById('li_'+tab).setAttribute(\“class\”, \“active\”);
        # }
        # </script>"
        #html += "<input type='submit'></form></body></html>"
        client.close #close those dirty connections
        # Return OK (200), content-type: text/html, followed by the HTML itself
        return 200, "text/html", html
      end
    end
    class Refresh< WEBrick::HTTPServlet::AbstractServlet

      # Process the request, return response
      def do_GET(request, response)

        status, content_type, body = print_questions(request)

        response.status = status
        response['Content-Type'] = content_type
        response.body = body
      end

      # Construct the return HTML page
      def print_questions(request)


        url = request.request_uri.to_s
        #   interval =0
        if url.include?"?"
          params=url[(url.index('?')+1)..url.length]
          # puts"#{params}"
          ip = params[(params.index('ip=')+3)..(params.length)]
          #     env = params[(params.index('env=')+4)..params.length]
        end
        #  taken = taken.gsub('%28','(')
        # taken = taken.gsub('%29',')')
        # taken = taken.gsub('+',' ')
        system("cd ..&ruby IO100_Get_Device_stats.rb #{ip}")

        #    client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")
        #    results = client.query("update environments set owner ='#{taken}' where environment_name='#{env}'")
        html= "<html><body>"
        html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
        html+="<a href=\"/results\"><button>QA Results page</button></a>  "
        html += "<h1>REFRESHED!! </h1>"

        return 200, "text/html", html
      end

    end
    class Devices < WEBrick::HTTPServlet::AbstractServlet
      def do_GET(request, response)
        status, content_type, body = get_tab(request)

        response.status = status
        response['Content-Type'] = content_type
        response.body = body
      end

      # Construct the return HTML page
      def get_tab(request)
        previousDay = ""
        nextDay = ""
        url = request.request_uri.to_s
        if url.include?"?"
          date=url[(url.index('?')+1)..url.length]
          #convertedDate=Date.parse(date)
          convertedDate=Date::strptime(date,"%m/%d/%Y")
          #now=DateTime.now.strftime('%Y-%m-%d')
          now = Date.today
          # puts "date to search for is #{date} now is #{now}"
          interval = (now - convertedDate).to_i
          previousDay = (convertedDate -(1)).strftime("%m/%d/%Y")
          nextDay = (convertedDate +(1)).strftime("%m/%d/%Y")
          puts "interval = #{interval}  previousDay = #{previousDay} nextDay = #{nextDay}"

        else
          interval = 0
          time = Time.new
          time = time -(1 * 86400 )
          previousDay = "#{time.month}/#{time.day}/#{time.year}"
          puts "interval = #{interval}  previousDay = #{previousDay} nextDay = #{nextDay}"

        end
        time = Time.new
        time = time -(interval.to_i * 86400 )

        dateName = "#{time.month}/#{time.day}/#{time.year}"
        # html+= "<script type=\"text/javascript\" src=\"~/Desktop/Scripts/WebServer/domtab.js\"></script>"
        html ="<head>"
        html  += "<html><META HTTP-EQUIV=\"refresh\" CONTENT=\"60\" /><body  onLoad=\"tab('tab1')\">"
        #"<form method='GET' action='/save'>"
        html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
        html+="<a href=\"/results\"><button>QA Results page</button></a>  "
        # onclick =\"f1()\"
        html += "<br>Refresh IP:<input type=\"text\" id=\"updateIp\" onkeyup = 'f1()'>"
        # html += "<input type=\"button\" value=\"submit\" onclick=\"f1()\">"
        html += "<a href=\"http://localhost:8000/refresher?\" id =\"send-update\"><button>Refresh</button></a>"
        #html +="<meta content=\"text/html; charset=utf-8\" HTTP-EQUIV=\"refresh\" CONTENT=\"60\" />"

        html +="<style type=\"text/css\">
#tabs ul {
padding: 0px;
margin: 0px;
margin-left: 0px;
list-style-type: none;
}

#tabs ul li {
display: inline-block;
clear: none;
float: left;
height: 34px;
}

#tabs ul li a {
position: relative;
margin-top: 16px;
display: block;
margin-left: 6px;
line-height: 38px;
padding-left: 5px;
background-color: #b2b2b2;


z-index: 9999;
border: 1px solid #ccc;
border-bottom: 0px;
-moz-border-radius-topleft: 4px;
border-top-left-radius: 4px;
-moz-border-radius-topright: 4px;
border-top-right-radius: 4px;
width: 150px;
color: #000000;
text-decoration: none;

}

#tabs ul li a:hover {
text-decoration: underline;
}

#tabs #Content_Area {
position: relative;
margin-top: 16px;
display: block;
margin-left: 6px;
line-height: 18px;
padding-left: 10px;
background: #f6f6f6;
z-index: 9999;
border: 1px solid #ccc;
border-bottom: 1px;
-moz-border-radius-topleft: 4px;
border-top-left-radius: 4px;
-moz-border-radius-topright: 4px;
border-top-right-radius: 4px;
-moz-border-radius-bottomleft: 4px;
border-bottom-left-radius: 4px;
-moz-border-radius-bottomright: 4px;
border-bottom-right-radius: 4px;

padding: 0 15px;
clear:both;
overflow:hidden;
line-height:19px;
position: relative;
top: 20px;
z-index: 5;
height: 800px;
overflow: hidden;
}

table {
  padding: 10px;  
  width:100%;
  min-width: 500px;
  border-collapse: collapse;
}
 td {

}
.style1{
    background-color: #b2b2b2!important;
}
.style2{
    background-color: #f6f6f6!important;
}
p { padding-left: 15px; }
</style>
<script language=\"JavaScript\">
function readCookie(name){
return(document.cookie.match('(^|; )'+name+'=([^;]*)')||0)[2]
}
</script>"
        #font-weight: bold;
        #html +="<link rel=\"stylesheet\" type=\"text/css\" href=\"/edit2.css\">"
        html += "</head>"

        html +="<h1>Devices  </h1>"
        html += "<p>Updated every day at 6am</p>"
        client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation' , timeout: 60
        client.execute('SET TEXTSIZE 2147483647')
        environments = Array.new
        envQuery = client.execute("select distinct project from devices order by project desc")
        envQuery.each do |env|
          environments.push(env['project'])
        end

        #environments =["Sacramento","Ellington","Canadian"]
        html +="<form onLoad=\"tab('tab\"readCoookie('tab')\"' onLoad=\"tab('tab1')\" >"
        html +="<div id =\"Tabs\">"

        html +="<ul>"
        count =1
        environments.each do |env|
          #  html +=""
          html +="<li id=\"li_tab#{count}\"  onclick=\"tab('tab#{count}')\" onclick \"document.cookie='tab=#{count}'\"><a id='a_tab#{count}'>#{env}"

          #status
          results = client.execute("select * from devices where project ='#{env}' order by ip")
          results.each(:as => :array) do |row|
            if row[0] == "Idle"
              html += "<font color=\"green\"> <b>#{row[1]}</b></font><br><font size=\"1\">#{row[1]}</font></label></a></li>"
            elsif  row[0] == "Running"
              html += "</h2><font color=\"red\"> <b>#{row[0]}</b></font><br><label><font size=\"1\">#{row[1]}</font></label></a></li>"
            end
          end
          # end
          count = count +1
        end
        html +="</ul>"
        html+="<div id=\"Content_Area\" onLoad=\"tab('tab1')\">"
        count =1
        environments.each do |env|
          if count ==1 then
            html +="<div id='tab#{count}' style=\"display: show;\">"
          else
            html +="<div id='tab#{count}'  style=\"display: none;\">"
          end
          # html+="<h2><a name=\"#{env}\" id=\"#{env}\">#{env}</a></h2>"
          html +=  "<table  border=\"1\">"

          results = client.execute("select * from devices where project ='#{env}' order by ip")
          html +="<tr>"
          #formattedText= row[0].gsub(/\n/, "<br/>")
          html += "<td><b>IP</b></td><td><b>Product Version</b></td><td><b>Firmware Version</b></td><td><b>Xmega Version</b></td><td><b>Owner</b></td><td><b>Notes</b></td><td><b>Date Checked</b></td><td><b>User Name</b></td><td><b>Password</b></td>"

          # html += "<td style=\"font-size:12px\"><a href=\"/testdesc?#{row[0]}\"><b>  #{row[0]} </b></a></td><td>#{row[2]}</td><td>#{row[3]}</td><td>#{row[4]}</td><td>#{row[5]}</td><td>#{row[6]}</td><td>#{row[7]}</td><td>#{row[8]}</td><td>#{row[9]}</td><td>#{row[10]}</td><td>#{row[11]}</td>"

          html +="</tr>"

          results.each do |row|
            html +="<tr>"
            #formattedText= row[0].gsub(/\n/, "<br/>")
            html += "<td><a href=\"https://#{row['ip'].strip}/login.cs\" target='_blank'><b>#{row['ip']} </b></a></td><td>#{row['product_version']}</td><td>#{row['firmware_version']}</td><td>#{row['xmega_version']}</td><td>#{row['owner']}</td><td>#{row['notes']}</td><td>#{row['date_checked']}</td><td>#{row['username']}</td><td>#{row['password']}</td>"

            # html += "<td style=\"font-size:12px\"><a href=\"/testdesc?#{row[0]}\"><b>  #{row[0]} </b></a></td><td>#{row[2]}</td><td>#{row[3]}</td><td>#{row[4]}</td><td>#{row[5]}</td><td>#{row[6]}</td><td>#{row[7]}</td><td>#{row[8]}</td><td>#{row[9]}</td><td>#{row[10]}</td><td>#{row[11]}</td>"

            html +="</tr>"
          end
          html +="</table> <p style=\"font-size:20px\">"
          html +="</table></td></tr></table>"
          count = count+1
          html +="</div>"
        end
        html +="</div>"

        html +="<script type=\"text/javascript\"> function tab(tab){"
        count =1
        environments.each do |env|
          html +="document.getElementById('tab#{count}').style.display = 'none';"
          html +="document.getElementById('li_tab#{count}').setAttribute(\"class\", \"\");"

          html +="document.getElementById('a_tab#{count}').setAttribute(\"class\", \"style1\");"
          count = count +1
        end
        html +="document.getElementById(tab).style.display = 'block';

document.getElementById('a_'+tab).setAttribute(\"class\", \"style2\");
document.getElementById('li_'+tab).setAttribute(\"class\", \"active\");

}
</script>
"

        html += "<script type=\"text/javascript\">
  
   function f1() {
     var ip = document.getElementById(\"updateIp\").value;
   document.getElementById('send-update').setAttribute('href','/refresher?ip=' + ip);
    //form validation that recalls the page showing with supplied inputs.    
}
window.onload = function() {
    document.getElementById(\"updateIp\").onclick = function fun() {
        f1();
        //validation code to see State field is mandatory.  
    }
}
</script>"

        # html +="<script type=\"text/javascript\">document.getElementById('updateIp').on(\"keyup\",function(){
        # $('#send-update').attr(\"href\",\"/refresher?\"+$(this).val());
        #})"
        #   html += "document.getElementById('updateIp').on(\"keyup\",function(e){
        #if(e. keyCode === 13){
        #  var address = $('#send-update').attr('href');
        # window.location = address;
        #}

        #('\#send-update').attr(\"href\",\"/refresher?ip=\"+$(this).val());
        #})"

        #     html +=" <script type=\"text/javascript\">function f1() {
        #     alert(\"f1 called\");

        # }
        #  document.getElementById(\"updateId\").onLoad = function() {
        #     document.getElementById(\"updateId\").onclick = function fun() {
        #         alert(\"hello\");
        #         f1();
        #     }"
        html +="</script>"
        #     html +="<script type=\”text/javascript\”> function tab(tab) {
        # document.getElementById('tab1').style.display = 'none';
        # document.getElementById('tab2').style.display = 'none';
        # document.getElementById('tab3').style.display = 'none';
        # document.getElementById('tab4').style.display = 'none';
        # document.getElementById('tab5').style.display = 'none';
        # document.getElementById('tab6').style.display = 'none';
        # document.getElementById('tab7').style.display = 'none';
        # document.getElementById('tab8').style.display = 'none';
        # document.getElementById('li_tab1').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab2').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab3').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab4').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab5').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab6').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab7').setAttribute(\“class\”, \“\”);
        # document.getElementById('li_tab8').setAttribute(\“class\”, \“\”);
        # document.getElementById(tab).style.display = 'block';
        # document.getElementById('li_'+tab).setAttribute(\“class\”, \“active\”);
        # }
        # </script>"
        #html += "<input type='submit'></form></body></html>"
        client.close #close those dirty connections
        # Return OK (200), content-type: text/html, followed by the HTML itself
        return 200, "text/html", html
      end
    end
    class Refresh< WEBrick::HTTPServlet::AbstractServlet

      # Process the request, return response
      def do_GET(request, response)

        status, content_type, body = print_questions(request)

        response.status = status
        response['Content-Type'] = content_type
        response.body = body
      end

      # Construct the return HTML page
      def print_questions(request)


        url = request.request_uri.to_s
        #   interval =0
        if url.include?"?"
          params=url[(url.index('?')+1)..url.length]
          # puts"#{params}"

          env = params[(params.index('env=')+4)..(params.length)]
          #     env = params[(params.index('env=')+4)..params.length]
        end
        #  taken = taken.gsub('%28','(')
        # taken = taken.gsub('%29',')')
        # taken = taken.gsub('+',' ')
        system("cd ..&ruby runDCMain.rb #{env}")

        #    client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")
        #    results = client.query("update environments set owner ='#{taken}' where environment_name='#{env}'")
        html= "<html><body>"
        html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
        #  html+="<a href=\"/prod_counts\"><button>Daily Production Symphony Counts</button></a>  "
        html+="<a href=\"/results\"><button>QA Results page</button></a>  "
        #   html+="<a href=\"/devices\"><button>Devices</button></a>  "
        @auth = {:username => "Chris", :password => "ChrisGoodnight01"}
        dcBase = ""
        options = {:digest_auth => @auth }
        if env.upcase == "QA_UK"
          dcBase = "dexw5151"
        elsif env.upcase =="PREPROD_UK"
          dcBase = "DEXW5181"
        elsif  env.upcase =="DEV_UK"
          dcBase = "detw5151"
        elsif env.upcase =="DEV_US"
          dcBase = "USTW5033"
        elsif  env.upcase =="QA_US"
          dcBase = "USXW5052"
        end
        jobsResponse = HTTParty.get("http://#{dcBase}/di/services/batch/jobs",options)
        html += "<h1>Started DC Main on #{env}</h1><br><p> Hit back to return to results page</p><br>"
        html += "<h1>Last 5 DC log jobs</h1><br><table></p>"
        for i in 0..5
          html += "<a href=\"#{jobsResponse["jobs"]["job"][i][jobsResponse["jobs"]["job"][i].keys[0]]}/log\">#{jobsResponse["jobs"]["job"][i][jobsResponse["jobs"]["job"][i].keys[0]]}/log<br>"
        end
        html += "</table></p>"
        return 200, "text/html", html
      end

    end
    class Refresh2< WEBrick::HTTPServlet::AbstractServlet

      # Process the request, return response
      def do_GET(request, response)

        status, content_type, body = print_questions(request)

        response.status = status
        response['Content-Type'] = content_type
        response.body = body
      end

      # Construct the return HTML page
      def print_questions(request)


        url = request.request_uri.to_s
        #   interval =0
        if url.include?"?"
          params=url[(url.index('?')+1)..url.length]
          # puts"#{params}"

          env = params[(params.index('env=')+4)..(params.length)]
          #     env = params[(params.index('env=')+4)..params.length]
        end
        #  taken = taken.gsub('%28','(')
        # taken = taken.gsub('%29',')')
        # taken = taken.gsub('+',' ')
        system("cd ..&ruby runDCConductor.rb #{env}")

        #    client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")
        #    results = client.query("update environments set owner ='#{taken}' where environment_name='#{env}'")
        html= "<html><body>"
        html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
        #  html+="<a href=\"/prod_counts\"><button>Daily Production Symphony Counts</button></a>  "
        html+="<a href=\"/results\"><button>QA Results page</button></a>  "
        @auth = {:username => "Chris", :password => "ChrisGoodnight01"}
        dcBase = ""
        options = {:digest_auth => @auth }
        if env.upcase == "QA_UK"
          dcBase = "dexw5151"
        elsif env.upcase =="PREPROD_UK"
          dcBase = "DEXW5181"
        elsif  env.upcase =="DEV_UK"
          dcBase = "detw5151"
        elsif  env.upcase =="DEV_US"
          dcBase = "USTW5033"
        elsif  env.upcase =="QA_US"
          dcBase = "USXW5052"
        end
        jobsResponse = HTTParty.get("http://#{dcBase}/di/services/batch/jobs",options)
        html += "<h1>Started DC Conductor on #{env}</h1><br><p> Hit back to return to results page</p>"
        html += "<h1>Last 5 DC log jobs</h1><br><table></p>"
        for i in 0..5
          html += "<a href=\"#{jobsResponse["jobs"]["job"][i][jobsResponse["jobs"]["job"][i].keys[0]]}/log\">#{jobsResponse["jobs"]["job"][i][jobsResponse["jobs"]["job"][i].keys[0]]}/log<br>"
        end


        return 200, "text/html", html
      end
    end
      class Refresh3< WEBrick::HTTPServlet::AbstractServlet

      # Process the request, return response
      def do_GET(request, response)

        status, content_type, body = print_questions(request)

        response.status = status
        response['Content-Type'] = content_type
        response.body = body
      end

      # Construct the return HTML page
      def print_questions(request)

      
        url = request.request_uri.to_s
        testToRun =""
        #   interval =0
        if url.include?"?"
          params=url[(url.index('?')+1)..url.length]
          # puts"#{params}"

          testToRun = params[(params.index('test=')+5)..(params.length)]
          #     env = params[(params.index('env=')+4)..params.length]
        end
        #  taken = taken.gsub('%28','(')
        # taken = taken.gsub('%29',')')
        # taken = taken.gsub('+',' ')
        result = system("cd ..&ruby #{testToRun}")
        file = File.open(".\\webserverlog.txt","a")
        time1 = Time.now
    file.write ("#{time1}\t#{testToRun}\t#{result}\n")
file.close  
client = TinyTds::Client.new username: 'svc_cdm', password: 'password', dataserver: 'dexd5080.hr-applprep.de', database: 'automation'

        results = client.execute("SELECT TOP 1  r.test_name,tc.description,r.os,r.browser,r.enviro,r.status,r.date_run,r.branch,r.id as results_ID,r.image, tc.priority, r.artifacts FROM results r left join test_cases tc  on r.test_name =tc.test_name where r.test_name = '#{testToRun}' ORDER BY ID DESC" )
    #puts "#{query}"
    headers = results.fields # <= that's an array of field names, in order
    #this is a hack to make the results show up.  Not sure why
    results.each(:as => :array) do |row|
      row[0]
    end
    offset= "0"
    time = Time.new
    time = time -(offset.to_i * 86400 )
   

   dateName = "#{time.month}/#{time.day}/#{time.year}"
  html= "<html><body>"
        html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
        #  html+="<a href=\"/prod_counts\"><button>Daily Production Symphony Counts</button></a>  "
        html+="<a href=\"/results\"><button>QA Results page</button></a>  "
         html +="<br>Run tests in<table><tr>"
         html+="<td><a href=\"http://dexw5171.hr-applprep.de:8000/testrunner\"><button>QA_UK</button></a>  "
         html+="<a href=\"http://detw5126.hr-appltest.de:8000/testrunner\"><button>DEV_UK</button></a>  "
         html+="<a href=\"http://USTW5032.hr-appltest.de:8000/testrunner\"><button>DEV_US</button></a> </table> "
       
        html += "<h1>Results #{testToRun} </h1>"

   # html += "<label><b>Number of records = #{results.count} for #{enviro} that #{status} on #{dateName}</b></br>"
  

    html += "<p style=\"font-size:10px\">"
      html += "<label><b>Click on the test_name for a description of the test and an example of a passed test.  Click on the ID for the specific run test</b></br>"
    html +=  "<table border=\"1\" style=\"width:1000px\" >"
    html +="<tr><b>"
    for i in 0..10
      #if(i==6) #sort order page
      #else
        html += "<td>#{headers[i]}</td>"
      #end
    end
    html +="</tr></b>"

    debugcount = 0
    results.each(:as => :array) do |row|
      html +="<tr>"
      for i in 0..10
        if i ==0
          html += "<td style=\"font-size:10px\"><a href=\"/testdesc?#{row[i]}\"><b>  #{row[i]} </b></a></td>"
        elsif i<8 && i>0 || i ==10
          if i== 5 && (row[i].strip == "Failed")
            html += "<td style=\"font-size:14px\"><font color=\"red\"> #{row[i]}</font></td>"
          else
            html += "<td style=\"font-size:12px\">#{row[i]}</td>"
          end
      
        elsif i ==8
          html += "<td style=\"font-size:10px\"><a href=\"/specifictest?#{row[i]}\"><b>  #{row[i]} </b> <br></a></td>"
        elsif i ==9
         # html += "<td style=\"font-size:10px\"><a href=\"#{row[i]}.png\" target=\"_blank\"><b>  #{row[i]} </b></a><br>"
           html += "<td style=\"font-size:10px\">"

          if row[11]
            artifacts = row[11].split(",")
            artifacts.each do |artifact|
               artifact.slice! "["
               artifact.slice! "]"
               artifact.slice! "\"Y:\\\\\\\\AutomationLogs\\\\"
               artifact = artifact.gsub('\\\\\\\\\\\\','/')
               artifact = artifact.gsub("\"","")
               artifact.strip!
              if artifact.include?('\\')
              shortArtifact = artifact[(artifact.rindex('\\') + 1)..(artifact.length-2)]
            else
             shortArtifact = artifact
             end 
              html += "<a href=\"#{artifact}\" target=\"_blank\"><b>  #{shortArtifact} </b><br></a>"
            end
          end

          html += "</td>"
        end
      end
      html +="</tr>"

    end
    html +="</table> <p style=\"font-size:20px\">"







        #    client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")
        #    results = client.query("update environments set owner ='#{taken}' where environment_name='#{env}'")
      
        return 200, "text/html", html
      end

    end
    class EnviroTest< WEBrick::HTTPServlet::AbstractServlet

      # Process the request, return response
      def do_GET(request, response)

        status, content_type, body = print_questions(request)

        response.status = status
        response['Content-Type'] = content_type
        response.body = body
      end

      # Construct the return HTML page
      def print_questions(request)

      
     
  html= "<html><body>"
        html+="<a href=\"/testlisting\"><button>Test Case Listing page</button></a>  "
        #  html+="<a href=\"/prod_counts\"><button>Daily Production Symphony Counts</button></a>  "
        html+="<a href=\"/results\"><button>QA Results page</button></a>  "
       
      
          html+="<a href=\"http://http://dexw5171.hr-applprep.de:8000/testrunner\"><button>QA_UK</button></a>  "
          html+="<a href=\"http://http://detw5126.hr-applprep.de:8000/testrunner\"><button>DEV_UK</button></a>  "
          html+="<a href=\"http://http://USTW5032.hr-appltest.de:8000/testrunner\"><button>DEV_US</button></a>  "
    





        #    client = Mysql2::Client.new(:host => "  ", :username => " ",:password =>" ", :database =>" ")
        #    results = client.query("update environments set owner ='#{taken}' where environment_name='#{env}'")
      
        return 200, "text/html", html
      end

    end


    # Initialize our WEBrick server
    if $0 == __FILE__ then
      root = File.expand_path '~/Desktop/Scripts/WebServer'
      server = WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot =>'root')

      # server.mount "/devices" , Devices
      server.mount "/resultsold", WebForm
      server.mount "/initial", Initial
      # server.mount "/campaign_count", CampaignCount
      server.mount "/multiserverenviro", InitialDetails
      server.mount "/results", Tabbed
      server.mount "/details", Details
      server.mount "/details2", Details2
      server.mount "/trends", Trends
      server.mount "/specifictest",SpecificTest
      server.mount "/tabbed",Tabbed
      server.mount "/testdesc", TestDescription
      server.mount "/testlisting", TestListing
      server.mount "/testrunner", TestRunner
      # server.mount "/campaign_user_behavior", CampaignUserBehavior
      # server.mount "/campaign_user" , CampaignUser
      # server.mount "/campaign_behaviors" , CampaignBehaviors
      server.mount "",Tabbed
      #server.mount "/claim_enviro" , ClaimEnviro
      #server.mount "/prod_counts" , ProdCounts
      server.mount "/refresher" , Refresh
      server.mount "/refresher2" , Refresh2
      server.mount "/refresher3" , Refresh3
      server.mount "/environmentTest" , EnviroTest
      #server.mount "/logs",""
      trap "INT" do server.shutdown end
      server.start
      # s = WEBrick::HTTPServer.new(Port: 2000, DocumentRoot: "/Volumes/Quality Assurance")
      # s.start

    end
