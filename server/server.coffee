http = require 'http'
https = require 'https'
url = require 'url'
util = require 'util'
fs = require 'fs'
nodeStatic = require 'node-static'

staticServer = new nodeStatic.Server('../client')

#==============================================================================
httpServer = http.createServer (request, response) ->
  command = url.parse(request.url, true)
  console.log command.pathname
  switch command.pathname     
    when '/status'
      response.writeHead 200, {'Content-Type': 'text/html'}
      response.write 'Longink server is up and running\n'
      response.end()

    when '/articles'
      console.log 'Serving up articles'
      httpsRequest = https.get "https://news.ycombinator.com/rss", (httpResponse) ->
        httpResponse.on 'data', (chunk) ->
          response.write chunk, 'binary'
        httpResponse.on 'end', (chunk) ->
          response.end()      
      httpsRequest.end()

    else 
      request.addListener 'end', ->
        console.log("Servicing static request to " + request.url)
        staticServer.serve(request, response)
      request.resume()

httpServer.listen(3000)
console.log 'Server listening on port 3000'
