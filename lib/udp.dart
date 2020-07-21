import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:multicast_lock/multicast_lock.dart';

class P2PClient {
  Map<String, List> events = {}; // Used to respond to monitored events
  int udpSendPort = 1234;
  int udpRecvPort = 4321;

  var sendSocket;
  var recvSocket;

  void addEventListener(String eventName, Function callback) {
    if (events.containsKey(eventName)) {
      events[eventName].add(callback);
    } else {
      events[eventName] = [callback];
    }
  }

  void removeEventListener(String eventName, Function callback) {
    if (events.containsKey(eventName)) {
      events[eventName].remove(callback);
    }
  }

  void send(String targetIP, int targetPort, String msg) {
    sendSocket.then((socket) {
      socket.send(Utf8Encoder().convert(msg), InternetAddress(targetIP), targetPort);
    });
  }

  connect() async{
    MulticastLock multicastLock = MulticastLock();
    await multicastLock.acquire();
    final address = InternetAddress('127.0.0.1');

    sendSocket = RawDatagramSocket.bind(InternetAddress.loopbackIPv4, udpSendPort);
    recvSocket = RawDatagramSocket.bind(InternetAddress.loopbackIPv4, udpRecvPort);

    recvSocket.then((socket) async {

      var interfaceEn0;
      List<NetworkInterface> interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4,);

      print('--------------------> $interfaces');

      for (var interface in interfaces) {
        if (interface.name == 'en0') {
          interfaceEn0 = interface;
        }
      }
      socket.setRawOption(RawSocketOption.fromInt(RawSocketOption.levelIPv4, RawSocketOption.IPv4MulticastInterface, 0));
      socket.joinMulticast(address, interfaceEn0);

      socket.multicastHops = 10;
      socket.broadcastEnabled = true;
      socket.readEventsEnabled = true;

      // Listen for socket events
      socket.listen((event) {
        if (event == RawSocketEvent.read) {
          Datagram dg = socket.receive();
          if (dg != null) {
            print('${dg.address}:${dg.port} -- ${utf8.decode(dg.data)}');
            String s = Utf8Decoder().convert(dg.data);

              for (var f in events['event']) {
                f(s);
              }
          }
        }
      });
    });
  }
}
