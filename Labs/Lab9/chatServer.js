var net = require('net');
var eol = require('os').EOL;

var srvr = net.createServer();
var clientList = [];

srvr.on('connection', function(client) {
  client.name = client.remoteAddress + ':' + client.remotePort;
  client.write('Welcome, ' + client.name + eol);
  clientList.push(client);

  client.on('data', function(data) {
    broadcast(data, client);
  });
});

function broadcast(data, client) {
  data = data.toString().substring(0, data.length-2);
  if (data == "\\list"){
    list(client);
  }
  else if (data.substring(0, 7) == "\\rename"){
    var newname = data.substring(8);
    console.log('renaming ' + client.name + ' to ' + newname + '\n' );
    rename(newname, client);
  }
  else if (data.substring(0, 8) =="\\private"){
    var split_data = data.split(" ");
    var recipient = split_data[1];
    for (var i in clientList){
      if (clientList[i].name == recipient){
        var restored_message = split_data.slice(2).join(" ");
        private_message(restored_message, client, clientList[i]);
      }
    }

  }
  else {
    send_all(data, client);
  }
}
function send_all(data, client){
  for (var i in clientList) {
    if (client !== clientList[i]) {
      clientList[i].write(client.name + " says " + data + "\n");
    }
  }

}
function list(client){
  client.write("Other Users:\n");
  for (var i in clientList){
    if (client !== clientList[i]) {
      client.write(clientList[i].name+"\n");
    }
  }
}
function private_message(data, client, recipient){
  recipient.write(client.name + " says " + data + "\n");
}
function rename(newname, client){
  client.name = newname;
}
srvr.listen(9000);


