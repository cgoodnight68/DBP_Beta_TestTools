#Introduction 
  The Overall framework for Hannover RE automation.  Written in ruby/selenium with a Ms SQL server back end.  
  For results  go to http://dexw5171.hr-applprep.de:8000/
  For test case descriptions go to http://dexw5171.hr-applprep.de:8000/testlisting



#Getting Started
To run all of these commands start in either powershell or command prompt as admin
To get started I like to install chocolatey a package manager for windows.  https://chocolatey.org/install

At a cmd prompt

@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

  #Install ruby
 
  
  download the installer from https://rubyinstaller.org/  then the 2.3.3 ruby or just https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.3.exe

  or 
  
   choco install ruby  (for now don't do this.  choco has 2.4 of ruby so we don't want that)
   
  
   #Get GIT
  Get the windows installer of git https://git-scm.com/download/win and install it
  
  #get code
 I like to have the code in my user directory so go to your user directory (ie C:\Users\g0h) 
and run  
 
  git clone  https://hannover-re.visualstudio.com/hlramerica/_git/Zenith_Automation automation

  #install Gems 
  Because of our restricted network access I have downloaded all the gems necessary
  Go to the automation\gems folder in the command line.  Type in gem install *.gem

  All gems should be installed (gem list at the command line)

  #final setup
  Make a folder in the Automation folder called logs
  
#Build and Test
No need to build the code. To run a test, simply get the latest version, from your git repository by typing git pull.
Then to run a test, then simply at the command line type ruby TestcaseName.rb  (i.e.  ruby .\1_GetDCAndZenithVersions.rb) The test will prompt you for environment
and browser to test in.   Results are logged locally and in the webserver.

Tests can also be run from the webserver directly.  Start at http://dexw5171.hr-applprep.de:8000/testlisting and select an environment to run then choose the test to run.


#Contribute
