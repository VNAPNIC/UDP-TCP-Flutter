import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/udp/udp_socket_base.dart';

start_server() async {
  final socket = await UDPSocket.bindSimple(7777);

  while (true) {
    final datagram = await socket.receive();
    print('---> Server received: ${ascii.decode(datagram.data)} from ${datagram.port}');
    socket.sendBack(datagram, ascii.encode('pong'));
  }
}

start_client(int port) async {
  final socket = await UDPSocket.bindSimple(port);
  socket.send(ascii.encode('ping'), 'localhost', 7777);
  final resp = await socket.receive();
  print('---> Client $port received: ${ascii.decode(resp.data)}');

  await socket.close();
  print('---> Client $port closed');
}

start_multicast_client(int port) async {
  final socket = await UDPSocket.bindMulticast('224.0.2.200',port);
  if (socket != null) {
    socket.send(ascii.encode('ping'), '224.0.2.200', 7777);
    final resp = await socket.receive();
    print('---> Client $port received: ${ascii.decode(resp.data)}');

    await socket.close();
    print('---> Client $port closed');
  }
}

start_multicast_server() async {
  final socket = await UDPSocket.bindMulticast('224.0.2.200',7777);
  while (true) {
    final datagram = await socket.receive();
    print('---> Server received: ${ascii.decode(datagram.data)} from ${datagram.port}');
    socket.sendBack(datagram, ascii.encode('pong'));
  }
}

// mark: the port must be server broadcast port
start_broadcast_client(int port) async {
  final socket = await UDPSocket.bindBroadcast(port);
  if (socket != null) {
    socket.send(ascii.encode('ping'), '192.168.1.255', port);
    final resp = await socket.receive();
    print('---> Client $port received: ${ascii.decode(resp.data)}');
    // `close` method of EasyUDPSocket is awaitable.
    await socket.close();
    print('---> Client $port closed');
  }
}