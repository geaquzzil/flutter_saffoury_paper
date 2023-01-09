import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/qr_code_widget.dart';
import 'package:flutter_view_controller/new_screens/home/base_home_main.dart';

class QrCodeWidgetListner extends StatelessWidget {
  const QrCodeWidgetListner({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifierCameraMode,
      builder: (context, value, child) {
        double height = value ? MediaQuery.of(context).size.height * .2 : 0;
        return SliverToBoxAdapter(
          child: AnimatedContainer(
              height: height,
              duration: const Duration(milliseconds: 200),
              child: QrCodeReader(
                getViewAbstract: true,
                currentHeight: height,
                onRead: (qr) {
                  readerViewAbstract.value = qr as ViewAbstract;
                },
              )),
        );
      },
    );
  }
}
