require 'webrick'

log = [[ $stderr, WEBrick::AccessLog::COMMON_LOG_FORMAT + ' POST=%{body}n']]

server = WEBrick::HTTPServer.new :Port => 8001, :AccessLog => log
server.mount_proc '/' do |req, res|
    req.attributes['body'] = req.body
    res.body = "Web server response:\n"
end
server.start
