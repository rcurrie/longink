http = require 'http'
url = require 'url'
util = require 'util'
fs = require 'fs'
nodeStatic = require 'node-static'

staticServer = new nodeStatic.Server('../client')

httpServer = http.createServer (request, response) ->
	command = url.parse(request.url, true)
	switch command.pathname			
		when '/status'
			response.writeHead 200, {'Content-Type': 'text/html'}
			response.write 'Server up and running\n'
			response.end()

		when '/articles'
			console.log 'Serving up articles'
			httpRequest = http.get { host: 'news.ycombinator.com', port: 80, path: '/rss'}, (httpResponse) ->
				httpResponse.on 'data', (chunk) ->
					response.write chunk, 'binary'
				httpResponse.on 'end', (chunk) ->
					response.end()
			httpRequest.end()

		else 
			request.addListener 'end', ->
				console.log("Servicing static request to " + request.url)
				staticServer.serve(request, response)

httpServer.listen(3000)
console.log 'Server listening on port 3000'