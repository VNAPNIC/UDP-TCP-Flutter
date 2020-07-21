import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';

/// EasyUDPSocket is a wrapper over RawDatagramSocket
/// to make life easier.
class UDPSocket {
  final RawDatagramSocket rawSocket;
  final StreamQueue _eventQueue;

  /// create an EasyUDPSocket with a RawDatagramSocket
  UDPSocket(this.rawSocket) : _eventQueue = StreamQueue(rawSocket);

  /// create an EasyUDPSocket and bind to host:port
  static Future<UDPSocket> bind(dynamic host, int port,
      {bool reuseAddress = true, bool reusePort = false, int ttl = 1}) async {
    final socket = await RawDatagramSocket.bind(host, port,
        reuseAddress: reuseAddress, reusePort: reusePort, ttl: ttl);
    return UDPSocket(socket);
  }

  /// create an EasyUDPSocket and bind to random port.
  static Future<UDPSocket> bindRandom(dynamic host,
      {bool reuseAddress = true, bool reusePort = false, int ttl = 1}) {
    return bind(host, 0,
        reuseAddress: reuseAddress, reusePort: reusePort, ttl: ttl);
  }

  static Future<UDPSocket> bindSimple(int port, [bool reusePort = false]) async {
    RawDatagramSocket socket =
    await RawDatagramSocket.bind(InternetAddress.anyIPv4, port, reusePort: reusePort);
    return UDPSocket(socket);
  }

  static Future<UDPSocket> bindMulticast(String ip, int port, [bool reusePort = false]) async {
    RawDatagramSocket socket =
    await RawDatagramSocket.bind(InternetAddress.anyIPv4, port, reusePort: reusePort);
    try {
      InternetAddress group = (await InternetAddress.lookup(ip))[0];
      socket.joinMulticast(group);
      socket.multicastLoopback = false;
      return UDPSocket(socket);
    } catch (e) {
      print('create multicast failure: $e');
      return null;
    }
  }


  static Future<UDPSocket> bindBroadcast(int port, [bool reusePort = false]) async {
    RawDatagramSocket socket =
    await RawDatagramSocket.bind(InternetAddress.anyIPv4, port, reusePort: reusePort);
    try {
      socket.broadcastEnabled = true;
      return UDPSocket(socket);
    } catch (e) {
      print('create broadcast failure: $e');
      return null;
    }
  }

  /// receive a Datagram from the socket.
  Future<Datagram> receive({int timeout, bool explode = false}) {
    final completer = Completer<Datagram>.sync();
    if (timeout != null) {
      Future.delayed(Duration(milliseconds: timeout)).then((_) {
        if (!completer.isCompleted) {
          if (explode) {
            completer.completeError('EasyUDP: Receive Timeout');
          } else {
            completer.complete(null);
          }
        }
      });
    }
    Future.microtask(() async {
      try {
        while (true) {
          final event = await _eventQueue.peek;
          if (event == RawSocketEvent.closed) {
            if (completer.isCompleted) return;
            completer.complete(null);
            break;
          } else if (event == RawSocketEvent.read) {
            await _eventQueue.next;
            if (completer.isCompleted) return;
            completer.complete(rawSocket.receive());
            break;
          } else {
            await _eventQueue.next;
          }
        }
      } catch (e) {
        print('receive fail: $e');
      }
    });
    return completer.future;
  }

  /// send some data with this socket.
  Future<int> send(List<int> buffer, dynamic address, int port) async {
    InternetAddress addr;
    if (address is InternetAddress) {
      addr = address;
    } else if (address is String) {
      print('-------------------->  send: $buffer | $address | $port');
      addr = (await InternetAddress.lookup(address))[0];
    } else {
      throw 'address must be either an InternetAddress or a String';
    }
    return rawSocket.send(buffer, addr, port);
  }

  /// use `sendBack` to send message to where a Datagram comes from.
  /// This is a shorthand of socket.send(somedata, datagram.address, datagram.port);
  int sendBack(Datagram datagram, List<int> buffer) {
    return rawSocket.send(buffer, datagram.address, datagram.port);
  }

  /// close the socket.
  Future<void> close() async {
    try {
      rawSocket.close();
      while (await _eventQueue.peek != RawSocketEvent.closed) {
        await _eventQueue.next;
      }
      await _eventQueue.cancel();
    } catch (e) {
      print('close fail: $e');
    }
  }
}