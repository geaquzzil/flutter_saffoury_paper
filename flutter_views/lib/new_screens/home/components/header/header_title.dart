import 'package:flutter/material.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:provider/provider.dart';

class HeaderTitleMain extends StatefulWidget {
  const HeaderTitleMain({Key? key}) : super(key: key);

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
          children: <Widget>[
            Text(context.watch<LargeScreenPageProvider>().getCurrentPageTitle(context),
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const Text('Craft beautiful UIs'),
            const Spacer(),
            const Expanded(
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
