#require 'sharepoint-ruby'
require 'curb'
site = Sharepoint::Site.new 'mysite.sharepoint.com', 'server-relative-site-url'
site.session.authenticate 'mylogin', 'mypassword'

blog = SharePoint::Site.new 'mytenant.sharepoint.com', 'sites/blog'
site.session.authenticate 'user', 'pwd'
lists = site.lists
for l in lists
  puts l.title
end