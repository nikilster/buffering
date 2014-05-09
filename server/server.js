var app = require('express')()
  , server = require('http').createServer(app)
  , io = require('socket.io').listen(server);

server.listen(8080);

/*
	Mobile
*/
app.get('/', function (req, res) {

  // Output a message to the socket
  // TODO: Figure out how to send to an individual socket
  // For now we are just blasting out to everyone
  io.sockets.emit('pushup', {count: 5});
  res.json({"status":"success"});
  res.end();
});
