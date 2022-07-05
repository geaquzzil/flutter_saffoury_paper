import 'package:flutter/material.dart';

class HeaderTitleMain extends StatefulWidget {
  HeaderTitleMain({Key? key}) : super(key: key);

  @override
  State<HeaderTitleMain> createState() => _HeaderTitleMainState();
}

class _HeaderTitleMainState extends State<HeaderTitleMain> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: const <Widget>[
            Text('Deliver features faster',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text('Craft beautiful UIs'),
            Spacer(),
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain, // otherwise the logo will be tiny
                child: FlutterLogo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
