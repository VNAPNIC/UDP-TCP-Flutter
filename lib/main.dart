import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/tcp/tcp_test.dart';
//import 'package:flutter_app/udp.dart';
//import 'package:flutter_app/udp/udp_test.dart';

//P2PClient client = P2PClient();

main() async{
//  start_server();
//  start_client(8001);
//  start_broadcast_client(8003);
//  start_multicast_server();
  start_server();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String data = '';

  @override
  void initState() {
    super.initState();
//    client.connect();
//
//    client.addEventListener('event', (data) {
//      setState(() {
//        this.data = data;
//        _counter++;
//      });
//    });
  }

  void _incrementCounter() {
//    client.send(InternetAddress.loopbackIPv4.address, client.udpRecvPort, '${InternetAddress.loopbackIPv4.address}');
//    setState(() {});
//    start_multicast_client(8002);
  start_client();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'InternetAddress: ${InternetAddress.loopbackIPv4.address} | isMulticast: ${InternetAddress.loopbackIPv4.isMulticast} \n'
              'IPv4MulticastInterface: ${RawSocketOption.IPv4MulticastInterface} \n'
              'levelUdp: ${RawSocketOption.levelUdp} \n'
              'levelSocket: ${RawSocketOption.levelSocket}',
            ),
            Text(
              '$data: $_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
