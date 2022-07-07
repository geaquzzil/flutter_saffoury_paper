import 'package:flutter/material.dart';

class BaseHomeCartPage extends StatefulWidget {
  BaseHomeCartPage({Key? key}) : super(key: key);

  @override
  State<BaseHomeCartPage> createState() => _BaseHomeCartPageState();
}

class _BaseHomeCartPageState extends State<BaseHomeCartPage> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Row(children: [
          Expanded(flex: 3,child: Container(color: Colors.grey.shade100)),
          Expanded(flex: 1,child: Container(color: Colors.grey.shade100),),
      ]),
    );
  }
}
