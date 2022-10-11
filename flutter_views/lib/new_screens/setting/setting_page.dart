import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_invoice_interface.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/new_components/ext.dart';
import 'package:flutter_view_controller/new_screens/setting/base_shared_detail_modifidable.dart';
import 'package:flutter_view_controller/new_screens/setting/list_sticky_setting_page.dart';
import 'package:flutter_view_controller/printing_generator/page/pdf_page.dart';
import 'package:flutter_view_controller/providers/settings/setting_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Row(children: [
        Expanded(
            // It takes 5/6 part of the screen
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const ListStickySettingWidget(),
                ],
              ),
            )),
        if (SizeConfig.isDesktop(context))
          Expanded(
              flex: size.width > 1340 ? 8 : 10, child: desideLyout(context))
      ]),
    );
  }

  Widget desideLyout(BuildContext context) {
    ModifiableInterface? selectedObject =
        context.watch<SettingProvider>().getSelectedObject;
    if (selectedObject == null ||
        selectedObject is! ModifiablePrintableInterface) {
      return Container(
          // color: Colors.grey,
          // padding: const EdgeInsets.all(10),
          // decoration: getShadowBoxDecoration(),
          child: const Center(
        child: BaseSettingDetailsView(),
      ));
    }

    return Container(
        // color: Colors.grey,
        // padding: const EdgeInsets.all(10),
        // decoration: getShadowBoxDecoration(),
        child: Row(
      children: [
        Expanded(
          child: Center(
            child: BaseSettingDetailsView(),
          ),
        ),
        Expanded(
            child: PdfPage(
          invoiceObj: selectedObject.getModifiablePrintableOnSetting(context),
        )),
      ],
    ));
  }
}
