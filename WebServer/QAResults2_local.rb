require 'rubygems'
#require 'sinatra'
require 'webrick'
#require 'mysql2'
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
    if url.include?"?"
      interval = url[(url.index('?')+1)..url.length]
    else
      interval = 0
    end
    time = Time.new
    time = time -(interval.to_i * 86400 )

    dateName = "#{time.month}/#{time.day}/#{time.year}"

    html   = "<html><META HTTP-EQUIV=\"refresh\" CONTENT=\"60\"><body><form method='POST' action='/save'>"
    html +="<h1>QA Automation Results for #{dateName}</h1>"
    environments =["uat","qdev","qa1","qa2","qa3","qa4","qa5","qa6","staging","uhcsteve","qaexternal","demo1","ux01"]

    client = Mysql2::Client.new(:host => "", :username => "",:password =>"d", :database =>"")
    environments.each do |env|
      html +="<form>"
      html +="<h2><a href=\"/trends?#{env}\">#{env} </a> </h2>"
      html +=  "<table border=\"1\" style=\"width:1000px\">"
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

    html   = "<html><META HTTP-EQUIV=\"refresh\" CONTENT=\"60\"><body><form method='POST' action='/save'>"
    html +="<h1>QA Environments </h1>"
    html +="<button type = \"submit\"><a href=\"/results\">ResultsPage </a></button>"
    html +="<button type = \"submit\"><a href=\"/testlisting\">Test Case Listing page </a></button>"
    # html +="<button type=\"button\" onClick=\"/Users/qa-user/Desktop/scripts/AllEnviroBuckedStatus.rb\">REFRESH</button>"

    environments =["production","uat","qdev","qa1","qa2","qa3","qa4","qa5","qa6","staging","qaexternal","uhcsteve","demo1","ux01"]

    client = Mysql2::Client.new(:host => "", :username => "",:password =>"", :database =>"")
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
    html +="<form>"

    html +=  "<table border=\"1\" style=\"width:1200px\">"
    environments.each do |env|

      if columns ==0 || columns ==4 || columns ==8
        html +="<tr>"
      end
      html+="<td>"
      #status
      results = client.query("select status,last_branch, date_of_branch,database_refresh,titan_last_branch,titan_date_of_branch,hermes_last_branch, hermes_date_of_branch,notes,installSha, titan_InstallSha, Hermes_InstallSha, EnviroStatus,hermes_core_db_refresh from environments where environment_name ='#{env}'")
      # puts "#{environments} results= #{results}"
      results.each(:as => :array) do |row|

        html +="<h2><a href=\"/results\">#{env} </a> #{row[12]}</h2>"
        if row[0] == "Idle"
          html += "<h4><label><b>Automation Status: </b></label> <font color=\"green\"> <b>#{row[0]}</b></font><br><label><b>Prime Branch:</b></label><label {text-allign: right;}> <font color=\"orange\">  #{row[1]}</font></label><br><label><b>Date of Branch: </b> #{row[2]}</label><br><label><b>Sha:</b>  #{row[9]}</label><br><label><b>PrimeDB refreshed:</b>  #{row[3]}</label><br><label><b>Titan Branch:</b> <font color=\"brown\">  #{row[4]} </font></label><br><label><b>Titan Date of Branch:</b>  #{row[5]}</label><br><label><b>Titan Sha:</b>  #{row[10]}</label><br><label><b>Hermes Branch:</b> <font color=\"pink\"> #{row[6]}</font></label><br><label><b>Hermes Date of Branch:</b>  #{row[7]}</label><br><label><b>Hermes Sha:</b>  #{row[11]}</label><br><label><b>Hermes/CoreDB refreshed:</b>  #{row[13]}</label><label><br><b>Notes:</b>  #{row[8]}</label><br></h4>"
        elsif  row[0] == "Running"
          html += "<h4><label><b>Automation Status: </b></label> <font color=\"red\"> <b>#{row[0]}</b></font><br><label><b>PrimeBranch: </b></label><label{text-allign: right;}> <font color=\"orange\">  #{row[1]}</font><br><label><b>Date of Branch: </b> #{row[2]}</label><br><label><b>Sha:</b>  #{row[9]}</label><br><label><b>PrimeDB refreshed: </b>  #{row[3]}</label><br><label><b>Titan Branch:</b> <font color=\"brown\">  #{row[4]} </font></label><br><label><b>Titan Sha:</b>  #{row[10]}</label><br><label><b>Titan Date of Branch:</b>  #{row[5]}</label><br><label><b>Hermes Branch:</b> <font color=\"pink\"> #{row[6]}</font></label><br><label><b>Hermes Date of Branch:</b>  #{row[7]}</label><br><label><b>Hermes Sha:</b>  #{row[11]}</label><br><label><br><label><b>Hermes/CoreDB refreshed:</b>  #{row[13]}</label><label><br><b>Notes:</b>  #{row[8]}</label><br></h4>"
        end
      end
      columns= columns+1

      # OS
      html +="</td>"
      if columns == 4 || columns ==8 ||columns ==12

        html +="</tr>"
      end



    end

    html +="</form>"
    html +="</td></tr></table>"
    html +="<button type = \"submit\"><a href=\"/results\">ResultsPage </a></button>"
    html +="<button type = \"submit\"><a href=\"/testlisting\">Test Case Listing page </a></button>"


    #html += "<input type='submit'></form></body></html>"
    client.close #close those dirty connections
    # Return OK (200), content-type: text/html, followed by the HTML itself
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
      browser = browser.gsub! "%20"," "
      brwsQry =1
    end
    params = params[params.index('&')+1..params.length]
    offset = params[params.index('=')+1..params.length]


    client = Mysql2::Client.new(:host => "", :username => "",:password =>"", :database =>"")

    html   = "<html><body><form method='POST' action='/save'>"

    if osQry==1
      results = client.query("select test_name,os,browser,enviro,status,date_run,branch,manual_check,id,image from results where date(date_run) = date_sub(date(now()),interval #{offset} day) and enviro =\"#{enviro}\" and status =\"#{status}\" and os =\"#{os}\" order by test_name" )
    elsif brwsQry==1
      puts browser
      results = client.query("select test_name,os,browser,enviro,status,date_run,branch,manual_check,id,image from results where date(date_run) = date_sub(date(now()),interval #{offset} day) and enviro =\"#{enviro}\" and status =\"#{status}\" and browser =\"#{browser}\" order by test_name" )
    else
      results = client.query("select test_name,os,browser,enviro,status,date_run,branch,manual_check,id,image from results where date(date_run) = date_sub(date(now()),interval #{offset} day) and enviro =\"#{enviro}\" and status =\"#{status}\" order by test_name" )
    end
    headers = results.fields # <= that's an array of field names, in order
    time = Time.new
    time = time -(offset.to_i * 86400 )


    dateName = "#{time.month}/#{time.day}/#{time.year}"

    html += "<label><b>Number of records = #{results.count} for #{enviro} that #{status} on #{dateName}</b></br>"
    html += "<label><b>Click on the test_name for a description of the test and an example of a passed test.  Click on the ID for the specific run test</b></br>"

    html += "<p style=\"font-size:8px\">"
    html +=  "<table border=\"1\" style=\"width:1000px\" >"
    html +="<tr><b>"
    for i in 0..9
      if(i==5)
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


    results.each(:as => :array) do |row|
      html +="<tr>"
      for i in 0..9
        if i ==0
          html += "<td style=\"font-size:10px\"><a href=\"/testdesc?#{row[i]}\"><b>  #{row[i]} </b></a></td>"
        elsif i<8 && i>0
          html += "<td style=\"font-size:12px\">#{row[i]}</td>"
        elsif i ==8
          html += "<td style=\"font-size:10px\"><a href=\"/specifictest?#{row[i]}\"><b>  #{row[i]} </b></a></td>"
        elsif i ==9
          html += "<td style=\"font-size:10px\"><a href=\"http:///logs/#{row[i]}.png\" target=\"_blank\"><b>  #{row[i]} </b></a></td>"
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
      #  puts "params before = #{params}\n"
      # params = params[params.index('&')+1..params.length]
      # puts "params = #{params}\n"
      # puts " location of = #{params.index('=')+1}\n"
      # puts "params length = #{params.length}\n"
      # puts "location of & #{params.index('&')-1}\n"
      browser = params[params.index('=')+1..params.index('&')-1]
      browser = browser.gsub! "%20"," "
      brwsQry =1
    end
    params = params[params.index('&')+1..params.length]
    offset = params[params.index('=')+1..params.length]


    client = Mysql2::Client.new(:host => "", :username => "",:password =>"", :database =>"")

    html   = "<html><body><form method='POST' action='/save'>"

    if osQry==1
      results = client.query("select test_name,os,browser,enviro,status,date_run,branch,manual_check,id,image from results where date(date_run) = date_sub(date(now()),interval #{offset} day) and enviro =\"#{enviro}\" and status =\"#{status}\" and os =\"#{os}\" order by date_run" )
    elsif brwsQry==1
      #puts browser
      results = client.query("select test_name,os,browser,enviro,status,date_run,branch,manual_check,id,image from results where date(date_run) = date_sub(date(now()),interval #{offset} day) and enviro =\"#{enviro}\" and status =\"#{status}\" and browser =\"#{browser}\" order by date_run" )
    else
      results = client.query("select test_name,os,browser,enviro,status,date_run,branch,manual_check,id,image from results where date(date_run) = date_sub(date(now()),interval #{offset} day) and enviro =\"#{enviro}\" and status =\"#{status}\" order by date_run" )
    end
    headers = results.fields # <= that's an array of field names, in order
    time = Time.new
    time = time -(offset.to_i * 86400 )


    dateName = "#{time.month}/#{time.day}/#{time.year}"

    html += "<label><b>Number of records = #{results.count} for #{enviro} that #{status} on #{dateName}</b></br>"
    html += "<p style=\"font-size:8px\">"
    html +=  "<table border=\"1\" style=\"width:1000px\" >"
    html +="<tr><b>"
    for i in 0..9

      html += "<td>#{headers[i]}</td>"

    end
    html +="</tr></b>"


    results.each(:as => :array) do |row|
      html +="<tr>"
      for i in 0..9
        if i ==0
          html += "<td style=\"font-size:10px\"><a href=\"/testdesc?#{row[i]}\"><b>  #{row[i]} </b></a></td>"
        elsif i<8 && i>0
          html += "<td style=\"font-size:12px\">#{row[i]}</td>"
        elsif i ==8
          html += "<td style=\"font-size:10px\"><a href=\"/specifictest?#{row[i]}\"><b>  #{row[i]} </b></a></td>"
        elsif i ==9
          html += "<td style=\"font-size:10px\"><a href=\"http:///logs/#{row[i]}.png\" target=\"_blank\"><b>  #{row[i]} </b></a></td>"
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
    client = Mysql2::Client.new(:host => "", :username => "",:password =>"", :database =>"")
    for interval in 0..29 do
        newPassed = "select distinct (select count('status')  from results where date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"Passed\" and enviro =\"#{env}\" ) as passed from results"
        results = client.query(newPassed)
        results.each(:as => :array) do |row|
          passed[interval]=row[0]
        end
        #Failed
        newFailed = "select distinct (select count('status')  from results where date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"failed\" and enviro =\"#{env}\" ) as passed from results"
        results = client.query(newFailed)
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



        client = Mysql2::Client.new(:host => "", :username => "",:password =>"", :database =>"")

        html   = "<html><body><form method='POST' action='/save'>"
        html += "<p style=\"font-size:8px\">"
        html +=  "<table border=\"1\" style=\"width:1000px\" >"

        results = client.query("select results, image from results where id =\"#{recordnum}\"" )

        results.each(:as => :array) do |row|
          html +="<tr>"
          formattedText= row[0].gsub(/\n/, "<br/>")
          html += "<td style=\"font-size:10px\"><a href=\"http:///logs/#{row[1]}.png \" target=\"_blank\"><b>  #{row[1]} </b></a></td>"
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



        client = Mysql2::Client.new(:host => "", :username => "",:password =>"", :database =>"n")

        html   = "<html><body><form method='POST' action='/save'>"
        html += "<p style=\"font-size:8px\">"
        html +=  "<table border=\"1\" style=\"width:1000px\" >"

        results = client.query("select description from test_cases where test_name =\"#{testname}\"" )

        results.each(:as => :array) do |row|
          html +="<tr>"
          formattedText= row[0].gsub(/\n/, "<br/>")
          html += "<td style=\"font-size:12px\">#{formattedText}</td>"

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


        client = Mysql2::Client.new(:host => "", :username => "",:password =>"d", :database =>"")

        html   = "<html><body><form method='POST' action='/save'>"
        html += "<p style=\"font-size:8px\">"
        html +=  "<table border=\"1\" style=\"width:1000px\" >"
        html += "<td style=\"font-size:12px\"><b>Test Name </b></td><td>qa1</td><td>qa2</td><td>qa3</td><td>qa4</td><td>qa5</td><td>qa6</td><td>uat</td><td>staging</td><td>windows</td><td>mac</td><td>smoke</td>"

        html +="</tr>"

        results = client.query("select * from test_cases order by test_name asc" )

        results.each(:as => :array) do |row|
          html +="<tr>"
          #formattedText= row[0].gsub(/\n/, "<br/>")
          html += "<td style=\"font-size:12px\"><a href=\"/testdesc?#{row[0]}\"><b>  #{row[0]} </b></a></td><td>#{row[2]}</td><td>#{row[3]}</td><td>#{row[4]}</td><td>#{row[5]}</td><td>#{row[6]}</td><td>#{row[7]}</td><td>#{row[8]}</td><td>#{row[9]}</td><td>#{row[10]}</td><td>#{row[11]}</td>"

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
        url = request.request_uri.to_s
        if url.include?"?"
          interval = url[(url.index('?')+1)..url.length]
        else
          interval = 0
        end
        time = Time.new
        time = time -(interval.to_i * 86400 )

        dateName = "#{time.month}/#{time.day}/#{time.year}"
        # html+= "<script type=\"text/javascript\" src=\"~/Desktop/Scripts/WebServer/domtab.js\"></script>"
        html ="<head>"
        html  += "<html><META HTTP-EQUIV=\"refresh\" CONTENT=\"60\" /><body><form method='POST' action='/save'>"
        #html +="<meta content=\"text/html; charset=utf-8\" HTTP-EQUIV=\"refresh\" CONTENT=\"60\" />"

        html +="<style type=\"text/css\">
#tabs ul {
padding: 0px;
margin: 0px;
margin-left: 10px;
list-style-type: none;
}

#tabs ul li {
display: inline-block;
clear: none;
float: left;
height: 30px;
}

#tabs ul li a {
position: relative;
margin-top: 16px;
display: block;
margin-left: 6px;
line-height: 18px;
padding-left: 10px;
background: #f6f6f6;
z-index: 9999;
border: 1px solid #ccc;
border-bottom: 0px;
-moz-border-radius-topleft: 4px;
border-top-left-radius: 4px;
-moz-border-radius-topright: 4px;
border-top-right-radius: 4px;
width: 100px;
color: #000000;
text-decoration: none;

}

#tabs ul li a:hover {
text-decoration: underline;
}

#tabs #Content_Area {
padding: 0 15px;
clear:both;
overflow:hidden;
line-height:19px;
position: relative;
top: 20px;
z-index: 5;
height: 600px;
overflow: hidden;
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

        html +="<h1>QA Automation Results for #{dateName}</h1>"
        environments =["uat","qdev","qa1","qa2","qa3","qa4","qa5","qa6","staging","uhcsteve","qaexternal","demo1","ux01"]
        html +="<form onLoad=\"tab('tab\"readCoookie('tab')\"'>"
        html +="<div id =\"Tabs\">"

        client = Mysql2::Client.new(:host => "", :username => "",:password =>"", :database =>"n")
        html +="<ul>"
        count =1
        environments.each do |env|
          #  html +=""
          html +="<li id=\"li_tab#{count}\" onclick=\"tab('tab#{count}')\" onclick \"document.cookie='tab=#{count}'\"><a>#{env}"

          #status
          results = client.query("select status, last_branch, date_of_branch from environments where environment_name ='#{env}'")
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
        html+="<div id=\"Content_Area\">"
        count =1
        environments.each do |env|
          if count ==1 then
            html +="<div id='tab#{count}'>"
          else
            html +="<div id='tab#{count}'  style=\"display: none;\">"
          end
          # html+="<h2><a name=\"#{env}\" id=\"#{env}\">#{env}</a></h2>"
          html +=  "<table border=\"1\" style=\"width:1100px\">"
          html +="<tr><td>"
          html +="<h2><a href=\"/trends?#{env}\">#{env} </a> </h2>"
          #Passed
          passedVal=0
          newPassed = "select distinct (select count('status')  from results where date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"Passed\" and enviro =\"#{env}\" ) as passed from results"
          results = client.query(newPassed)
          results.each(:as => :array) do |row|
            passedVal=row[0].to_i
            #puts "passedVal =#{passedVal}"
            html += "<label><a href=\"/details?enviro=#{env}&status=Passed&dateoffset=#{interval}\"><b>Passed: </b></a></label> <font color=\"green\"> <b>#{row[0]}</b></font><br>"
          end
          #Failed
          failedVal=0
          newFailed = "select distinct (select count('status')  from results where date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"failed\" and enviro =\"#{env}\" ) as passed from results"
          results = client.query(newFailed)
          results.each(:as => :array) do |row|
            failedVal=row[0].to_i
            # puts "failedVal=#{failedVal}"
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
              passedVal=row[0]
              html += "<label><a href=\"/details?enviro=#{env}&status=Passed&os=#{osHolder}&dateoffset=#{interval}\"><b>  Passed: </b></a></label> <font color=\"green\"> <b>#{row[0]}  </b></font>"
            end
            #Failed
            newFailed = "select distinct (select count('status')  from results where os like \"#{osHolder}\" and date(date_run) = date_sub(date(now()),interval #{interval} day)  and status =\"Failed\" and enviro =\"#{env}\" ) as passed from results"
            results = client.query(newFailed)
            results.each(:as => :array) do |row|
              failedVal=row[0]
              html += "<label><a href=\"/details?enviro=#{env}&status=Failed&os=#{osHolder}&dateoffset=#{interval}\"><b> Failed: </b></a></label> <font color=\"red\"><b>#{row[0]}  </b></font>"
            end
            if passedVal>0
              # puts "passedVal =#{passedVal}"
              #puts "failedVal=#{failedVal}"
              percentage = (passedVal.to_f/(passedVal.to_f + failedVal.to_i) * 100)
              # puts percentage
              html +="<label style=\"text-align: right;\">  ====>#{percentage.round(2)}\%</label></li>"
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
          #  html+="</tab>"
          # html +="</form>"
          html +="</td></tr></table>"
          count = count+1
          html +="</div>"
        end
        html +="</div>"
        html +="<script type=\"text/javascript\"> function tab(tab){
document.getElementById('tab1').style.display = 'none';
document.getElementById('tab2').style.display = 'none';
document.getElementById('tab3').style.display = 'none';
document.getElementById('tab4').style.display = 'none';
document.getElementById('tab5').style.display = 'none';
document.getElementById('tab6').style.display = 'none';
document.getElementById('tab7').style.display = 'none';
document.getElementById('tab8').style.display = 'none';
document.getElementById('li_tab1').setAttribute(\"class\", \"\");
document.getElementById('li_tab2').setAttribute(\"class\", \"\");
document.getElementById('li_tab3').setAttribute(\"class\", \"\");
document.getElementById('li_tab4').setAttribute(\"class\", \"\");
document.getElementById('li_tab5').setAttribute(\"class\", \"\");
document.getElementById('li_tab6').setAttribute(\"class\", \"\");
document.getElementById('li_tab7').setAttribute(\"class\", \"\");
document.getElementById('li_tab8').setAttribute(\"class\", \"\");
document.getElementById(tab).style.display = 'block';
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



    # Initialize our WEBrick server
    if $0 == __FILE__ then
      root = File.expand_path '~/Desktop/Scripts/WebServer'
       if "#{RUBY_PLATFORM}"=="i386-mingw32"
        server = WEBrick::HTTPServer.new(:Port => 8001, :DocumentRoot =>'H:\\\\AutomationLogs')
      else

      server = WEBrick::HTTPServer.new(:Port => 8001, :DocumentRoot =>'H:\\\\AutomationLogs')
      end
      # server.mount "/resultsold", WebForm
      # server.mount "/initial", Initial
      # server.mount "/results", Tabbed
      # server.mount "/details", Details
      # server.mount "/details2", Details2
      # server.mount "/trends", Trends
      # server.mount "/specifictest",SpecificTest
      # server.mount "/tabbed",Tabbed
      # server.mount "/testdesc", TestDescription
      # server.mount "/testlisting", TestListing
      # server.mount "",Initial
      trap "INT" do server.shutdown end
      server.start
     # s = WEBrick::HTTPServer.new(Port: 2000, DocumentRoot: "/Volumes/Quality Assurance")
     # s.start
      end
