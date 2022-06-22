import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:lottie/lottie.dart';

class BaseSharedDetailsView extends StatelessWidget {
  ViewAbstract? viewAbstract;
  BaseSharedDetailsView({Key? key, required this.viewAbstract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: viewAbstract == null ? getEmptyView(context) : Text("TODO"));
  }

  Widget getEmptyView(BuildContext context) {
    //create a empty view with lottie
    return Center(
      child: Lottie.network(
          "https://assets3.lottiefiles.com/private_files/lf30_gctc76jz.json"),
    );
  }
}
