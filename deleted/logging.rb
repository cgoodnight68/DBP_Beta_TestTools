require "json"
require "selenium-webdriver"
gem "test-unit"

class Util
  attr_accessor :logging, :filename
  filename = ""
  @@enviro = ""
  @@brws =""
  @@usingEnviro=0

   # Initializes logging
   #   filename full path and filename to open
  def initialize (filename)
    self.filename = filename
    time1 = Time.now
    file=File.open(filename,"a")
    file.write ("#{time1}\t#{filename} opened\n")
    file.close
  end
   # sets the autorun variables
   
  def setAutoRun(env,brw)
    @@enviro = env
    @@brws = brw
  end

  def retrieveAuto
    return @@enviro,@@brws
  end
  def setUsingEnviro
    @@usingEnviro = 1
  end
  def getUsingEnviro
    if @@usingEnviro==1
      true
    else
      false
    end
  end

  def getLog
    return filename
  end

  def logging(message)
   #turned off but is code for debugging to make the logs less verbose
    if message.include?("---->")
    binding.pry
      debugging = message.index("---->") -1
       file2 = File.open("c:\\users\\g0h\\zenith\\automation\\siteobjects.txt","a")
    file.write ( "#{message[debugging..(message.length - 1)]}\n" )
    file.close
    binding.pry
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

end
