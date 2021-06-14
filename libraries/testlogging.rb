require "json"
require "selenium-webdriver"
gem "test-unit"

class Util
  attr_accessor :logging, :filename
  filename = ""
  @@enviro = ""
  @@brws =""
  @@usingEnviro=0
  @@loggingBrowser = "" 
   # Initializes logging
   #   filename full path and filename to open
  def initialize (filename)
    self.filename = filename
    time1 = Time.now
    file=File.open(filename,"a")
    file.write ("#{time1}\t#{filename} opened\n")
    file.close
  end
   # Sets the autorun variables
   #   env
   #   brw
  def setAutoRun(env,brw)
    @@enviro = env
    @@brws = brw
  end
   # Gets the autorun variables
  def retrieveAuto
    return @@enviro,@@brws
  end
   # Sets the Using enviro variable which indicates that a file was used to set the environment and browser
  def setUsingEnviro
    @@usingEnviro = 1
  end
   # Gets the current enviro variable
  def getUsingEnviro
    if @@usingEnviro==1
      true
    else
      false
    end
  end
   # Gets the name of the current log file
  def getLog
    return filename
  end
   # The main logging function.  If the global @@usingEnviro is 0 then logs to console
   #   message  the message to log
  def logging(message)
   #turned off but is code for debugging to make the logs less verbose
   if message.include?("---->")

      debugging = message.index("---->") -1
       if message.include?("xpath")
        # file2 = File.open(".\\siteobjects.txt","a")
       
        # parsedMessage = message.gsub("---->","\t").gsub("-->","\t").gsub("of type xpath","")
        # parsedMessage = "#{parsedMessage}\t#{@@loggingDriver.current_url}\n"
        # file2.write("#{parsedMessage}")
        # file2.close
 
      end
    message = message[0..debugging]

    #binding.pry
    end
    if @@usingEnviro==0 then
      #log to the console
      puts(message)
    end


    file = File.open(filename,"a")
    time1 = Time.now
    file.write ("#{time1}\t#{message}\n")
    file.close
  end
   def errorlogging(message)
   #turned off but is code for debugging to make the logs less verbose
   if message.include?("---->")

      debugging = message.index("---->") -1
       if message.include?("xpath")
        # file2 = File.open(".\\siteobjects.txt","a")
       
        # parsedMessage = message.gsub("---->","\t").gsub("-->","\t").gsub("of type xpath","")
        # parsedMessage = "#{parsedMessage}\t#{@@loggingDriver.current_url}\n"
        # file2.write("#{parsedMessage}")
        # file2.close
 
      end
    message = message[0..debugging]

    #binding.pry
    end
    if @@usingEnviro==0 then
      #log to the console
      puts(message)
    end


    file = File.open(filename,"a")
    time1 = Time.now
    file.write ("#{time1}\t <font color=\"red\">#{message}</font>\n")
    file.close
  end


  def share_driver(driver)
      @@loggingDriver = driver
  end
end
