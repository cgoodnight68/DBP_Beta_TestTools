README
This is a collection of beta automation tools for DBP (GitHub - cgoodnight68/DBP_Beta_TestTools ).  This is a prototype of automation in Ruby that will be moved over to JAVA.

Installation
Ruby is installed on Mac but it is a crippled version.  Install a fresh version of ruby using the following instructions:Install RVM in macOS (step by step) .  At the line to install ruby enter ruby 2.6.3.

First Clone the repository.

Install homebrew. at the command line run
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Then we need to install mysql so at the command line
brew install mysql
then postgres
brew install postgresql
then  openssl
brew install openssl@1.1


A gem file has been added to the repository, to use it make sure to install bundler beforehand (in your console/cmd/ssh) with  gem install bundler
and then write in the console

bundle install

If this fails you can install the gems manually with the following

Note:  if you have the default ruby installed on your mac you may need to run the following command
export GEM_HOME="$HOME/.gem"

Then from the command line enter

gem install pry

gem install httparty

gem install json

gem install net-http

gem install selenium-webdriver

gem install net-ssh

gem install net-sftp

gem instll roo

gem install roo-xls

gem install open-uri

gem install test-unit

gem install mysql2

gem install net-ssh-gateway

gem install logging

gem install openssl

gem install webdriver

First we need to install homebrew. at the command line run
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
Then we need to install mysql so at the command line
brew install mysql
then you should be able to do
gem install mysql2

for the next gem Posgres needs to be installed, install with brew install postgresql.
If Brew not installed install it with /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

gem install pg

Chromedriver installation
Download the chromedriver from https://chromedriver.chromium.org/downloads 
Unpack the zip and put the  chromedriver into an accessible path.

If you already have it installed, you need to replace your current chromedriver with the one in this zip file.  You can find the path to the current chromedriver by typing

which chromedriver

in terminal. It will give you the path to the current chromedriver
Copy the new version of the chromedriver to that path (overwriting the original).

Then, in the terminal, go to that path and execute the following command
xattr -d com.apple.quarantine chromedriver

Additional configuration
See below for Setting the DBPKEY to setup the encryption key.

See below for Setting the JUDD.PEM file

Running tests
At this point you can run tests.

Note that to run these tests you will need to VPN in DBP.
Once logged in you can run a script by typing in the command line
ruby theScriptToRun.rb

ie. ruby DBP-T239.rb

The script will ask for the environment (full base url, ie. integration.deliverybizpro.co)
Then the script will ask for the database, this is the db name (i.e. integration)
then will prompt for the browser to use.  At this time it is only chrome.  Enter chrome and hit return.

The test will run and results will show up in http://ec2-54-201-168-175.us-west-2.compute.amazonaws.com/.  Logs will also be dumped along with screen shots in the logs folder in this repository along with snapshots.

The current set of scripts can be run in a batch using sh DBP_Smoke.rb (runs the full link check) or DBP_Smoke_daily.rb .  Before running a file named environment_variables.txt needs to be created with the environment, the database, and the browser each on a separate line.  For environments where the database is NOT in the integration host, the fourth line can be used to specify the ip address of the db host.   The environment_variables2.txt file is a sample.  If this file exists, the scripts will run unprompted using the values in this file. If you want to run individual tests and enter the environment, database and browser type, simply delete the environment_variables.txt

Setting the DBPKEY
Add the following  environment variable to your mac

export DBPKEY= xxxxx

Replace xxxx with the 1Password DBPKEY for Automation out in the QA Testing Vault


 

Set Permanent Environment Variable
Permanent environment variables are added to the .bash_profile file:

Find the path to 

.bash_profile by using:


~/.bash-profile
Open the 

.bash_profile file with a text editor of your choice.  (i.e. vi ~/.bash-profile)

Scroll down to the end of the 

.bash_profile file.

Use the 

export command to add new environment variables:


export [variable_name]=[variable_value]
Save any changes you made to the 

.bash_profile file.

Execute the new 

.bash_profile by either restarting the terminal window or using:


source ~/.bash-profile
 

Setting the JUDD.PEM file
The judd.pem file needs to be installed for connecting to the different DBP databases

Out in 1Password is the file in the DBP Master Key vault


 

Download the file to your local machine.  Create a directory at the user root i.e. ~/bin (on mac this is the user directory i.e. cgoodnight/bin on windows this is the c:\users\username\bin).  Put the judd.pem file in this directory.

 

 

 

