var app = require("cf-runtime").CloudApp;

var port = app.port || 3000;

require("http").createServer(function (req, res) {
  res.writeHead(200, {"Content-Type" : "text/html"});
  res.end("Hello from Cloud!");
}).listen(port);