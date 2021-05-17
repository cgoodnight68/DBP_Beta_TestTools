This is a collection of beta automation tools for DBP.  This is a prototype of automation in Ruby that will be moved over to JAVA.  

Installation

Ruby is installed on Mac but you will need to install some gems.  

First Clone the repository.  

Then from the command line enter

gem install pry

gem install httparty

gem install json

gem install net-http


That is it for installation! 


Note that to run these tests you will need to VPN in DBP.  

Once logged in you can run a script by typing in the command line 
ruby theScriptToRun.rb

ie. ruby DBP-T239.rb

The script will ask for the environment (full base url, ie. integration.deliverybizpro.co)
Then the script will ask for the database, this is the db name (i.e. integration)
then will prompt for the browser to use.  At this time it is only chrome.  Enter chrome and hit return.

The test will run and results will show up in http://ec2-54-201-168-175.us-west-2.compute.amazonaws.com/.  Logs will also be dumped along with screen shots in the logs folder in this repository along with snapshots.

The current set of scripts can be run in a batch using sh DBP_Smoke.rb.  Before running a file named environment_variables.txt needs to be created with the environment, the database, and the browser each on a separate line.  The environment_variables2.txt file is a sample.  If this file exists, the scripts will run unprompted using the values in this file. 


