import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pos_widget.dart';
import 'package:flutter_app/udp/udp_test.dart';

import 'cds_widget.dart';

main() async {
  runApp(MyApp());
}

enum Permission { NODE, POS, CDS }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'TCP/UDP'),
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
  Permission permission = Permission.NODE;

  void _selectPermission(Permission permission) {
    setState(() {
      this.permission = permission;
    });
  }

  Widget content() {
    if (permission == Permission.POS) {
      return POSWidget();
    } else if (permission == Permission.CDS) {
      return CDSWidget();
    } else {
      return Column(
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            child: Container(
                color: Colors.red,
                child: Center(
                    child: Text(
                  'Start POS',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ))),
            onTap: () {
              _selectPermission(Permission.POS);
            },
          )),
          Expanded(
              child: GestureDetector(
            child: Container(
                color: Colors.green,
                child: Center(
                    child: Text(
                  'Start CDS',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ))),
            onTap: () {
              _selectPermission(Permission.CDS);
            },
          ))
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: content(),
      ),
    );
  }
}
