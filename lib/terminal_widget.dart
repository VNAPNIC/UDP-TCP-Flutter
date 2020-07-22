import 'package:flutter/material.dart';

/// Terminal Screen
class TerminalWidget extends StatelessWidget {
  final List<String> terminals;
  final ScrollController controller;

  const TerminalWidget(this.terminals, this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.black,
      child: ListView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          return Text(
            terminals[index],
            style: TextStyle(color: Colors.white),
          );
        },
        itemCount: terminals.length,
        shrinkWrap: true,
      ),
    );
  }
}
