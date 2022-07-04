import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NetworkFaildAuth extends StatelessWidget {
  const NetworkFaildAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Expanded(
          child: Lottie.network(
              "https://assets10.lottiefiles.com/packages/lf20_lvuoopxx.json"),
        ),
        Expanded(
          child: TextButton(onPressed: () {}, child: Text("Retr")),
        )
      ]),
    );
  }
}
