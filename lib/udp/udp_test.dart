import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/udp/udp_socket_base.dart';

const RESPONSE = 'response';
const SENDER = 'sender';

const JOIN = 'join';
const ACCEPT = 'accept';
const RECEIVED = 'received';

class UDPTest {
  Map<String, dynamic> senderEvents = {};
  Map<String, dynamic> receiveEvents = {};

  UDPSocket cdsSocket;
  String ip; // server ip
  int port; // server port
  int myPort; // my port

  /// add sender event
  void addSenderEventListener(String eventName, Function callback) {
    if (senderEvents.containsKey(eventName)) {
      senderEvents[eventName].add(callback);
    } else {
      senderEvents[eventName] = [callback];
    }
  }

  /// add sender event
  void addReceiveEventListener(String eventName, Function callback) {
    if (receiveEvents.containsKey(eventName)) {
      receiveEvents[eventName].add(callback);
    } else {
      receiveEvents[eventName] = [callback];
    }
  }

  /// Connect server
  /// [ip] IP of server
  /// [port] port of server
  /// [myPort] my port
  connectServer(String ip, int port, int myPort) async {
    this.ip = ip;
    this.port = port;
    this.myPort = myPort;

    await _initCDSSocket();
    send(JOIN);
  }

  /// send a message to server
  send(String ms) async {
    await _initCDSSocket();

    if (cdsSocket != null) {
      final str = ascii.encode(ms);
      cdsSocket.send(str, ip, port);

      if (senderEvents.containsKey(SENDER))
        for (var f in senderEvents[SENDER]) {
          f(ascii.decode(str));
        }

      final datagram = await cdsSocket.receive();
      if (receiveEvents.containsKey(RESPONSE))
        for (var f in receiveEvents[RESPONSE]) {
          f(datagram);
        }

      close();
    }
  }

  /// IOS not create new instant RawDatagramSocket because crash
  _initCDSSocket() async {
    if (Platform.isAndroid) {
      cdsSocket = await UDPSocket.bindMulticast(ip, myPort);
    } else if (Platform.isIOS) {
      if (cdsSocket == null)
        cdsSocket = await UDPSocket.bindMulticast(ip, myPort);
    }
  }

  /// IOS not close socket
  close() {
    if (Platform.isAndroid) {
      cdsSocket.close();
    }
  }

  bindMulticastServer(String ip, int port) async {
    final socketServer = await UDPSocket.bindMulticast(ip, 7777);
    while (true) {
      final datagram = await socketServer.receive();
      if (receiveEvents.containsKey(RESPONSE))
        for (var f in receiveEvents[RESPONSE]) {
          f(datagram);
        }

      final ms = ascii.decode(datagram.data) == JOIN
          ? ascii.encode(ACCEPT)
          : ascii.encode(RECEIVED);
      socketServer.sendBack(datagram, ms);

      if (senderEvents.containsKey(SENDER))
        for (var f in senderEvents[SENDER]) {
          f(ascii.decode(ms));
        }
    }
  }
}
