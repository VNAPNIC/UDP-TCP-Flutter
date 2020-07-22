import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/terminal_widget.dart';
import 'package:flutter_app/udp/udp_test.dart';

/// CDS Screen
class CDSWidget extends StatefulWidget {
  @override
  _CDSWidgetState createState() => _CDSWidgetState();
}

class _CDSWidgetState extends State<CDSWidget> {
  String ip = '224.0.2.200';
  int port = 7777; // default server port is 7777
  bool isConnected = false;

  List<String> terminals = [];

  var controller = ScrollController();

  UDPTest _udpTest = UDPTest();

  TextEditingController _myPortController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  connectPOS(int myPort) async {
    _udpTest.addReceiveEventListener(RESPONSE, (Datagram datagram) {
      // Add new message of the CDS to terminals
      terminals.add(
          'Res-[${datagram.address.address}:${datagram.port}]:\n${ascii.decode(datagram.data)}');

      setState(() {
        if (ascii.decode(datagram.data) == ACCEPT) isConnected = true;
      });
    });

    // Add my message sending to terminals
    _udpTest.addSenderEventListener(SENDER, (String str) {
      terminals.add('Send-[$ip:$port]:\n$str');
      setState(() {});
    });
    await _udpTest.connectServer(ip, port, myPort);
  }

  widgetConnect() => isConnected
      ? Row(
          children: <Widget>[
            SizedBox(
              width: 8.0,
            ),
            Expanded(
                child: TextField(
              controller: _messageController,
              decoration: InputDecoration(hintText: 'Enter a message'),
            )),
            SizedBox(
              width: 8.0,
            ),
            RaisedButton(
              onPressed: () {
                _udpTest.send(_messageController.text);
              },
              child: Text('Send'),
            )
          ],
        )
      : Row(
          children: <Widget>[
            SizedBox(
              width: 8.0,
            ),
            Expanded(
                child: TextField(
              controller: _myPortController,
              decoration: InputDecoration(
                hintText: 'My Port',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            )),
            SizedBox(
              width: 8.0,
            ),
            RaisedButton(
              onPressed: () {
                connectPOS(int.parse(_myPortController.text.toString()));
              },
              child: Text('Connect'),
            )
          ],
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widgetConnect(),
        SizedBox(
          height: 8.0,
        ),
        // My info
        Text(
          'Server is running!\n'
          'ip: $ip:$port',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8.0,
        ),
        // List terminal
        Expanded(
            child: Container(
                margin: EdgeInsets.all(8.0),
                child: TerminalWidget(terminals, controller))),
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}
