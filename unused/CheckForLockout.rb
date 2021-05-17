require 'viewpoint'
#include Viewpoint::EWS
for i in 1..1000
	print("checking for lock")
result= system("powershell.exe >&1 \"Get-ADUser svc_ZenithWebServer -Properties * | Select-Object LockedOut\"")

if result == true
     print("There was a lockout, sending email")
      endpoint = 'https://us6x5003.hannover-re.grp:444/EWS/exchange.asmx'
      user = 'g0h'
      pass = 'G00dnight$2'
      #opts = http_opts: {ssl_verify_mode: 0}

      cli = Viewpoint::EWSClient.new endpoint, user, pass,http_opts: {ssl_verify_mode: 0}

       cli.send_message do |m|
  m.subject = "hannover-re\\svc_ZenithWebServer account is locked"
  m.body    = "The hannover-re\\svc_ZenithWebServer account is locked"
  m.to_recipients << 'Chris.Goodnight@hlramerica.com'
end

end
print("loop #{i} done")
sleep(60)

end