
import 'dart:convert';
import 'dart:io';

startServer(){
  ServerSocket.bind('127.0.0.1', 4041).then((serverSocket) {
    serverSocket.listen((socket) {
      socket.listen((s){
        print(utf8.decode(s));
      });
    });
  });
}

startClient(){
  Socket.connect('127.0.0.1', 4041).then((socket) {
    socket.write('Hello, World!');
  });
}