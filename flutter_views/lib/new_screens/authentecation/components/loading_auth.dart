import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAuth extends StatelessWidget {
  const LoadingAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Lottie.network(
              "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json"));
  }
}