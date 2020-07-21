
import 'dart:convert';
import 'dart:io';

start_server(){
  ServerSocket.bind('127.0.0.1', 4041).then((serverSocket) {
    serverSocket.listen((socket) {
      socket.listen((s){
        print(utf8.decode(s));
      });
    });
  });
}

start_client(){
  Socket.connect('127.0.0.1', 4041).then((socket) {
    socket.write('Hello, World!');
  });
}