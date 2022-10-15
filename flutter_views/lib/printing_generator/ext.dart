import 'package:flutter/material.dart' as mt;
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter_view_controller/models/prints/print_commad_abstract.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Widget buildTitle(mt.BuildContext context, PrintableMaster printObj,
        {PrintCommandAbstract? printCommandAbstract}) =>
    Padding(
        padding: EdgeInsets.symmetric(horizontal: 26, vertical: 5),
        child: Text(
          printObj.getPrintableInvoiceTitle(context, printCommandAbstract),
          style: TextStyle(
              fontSize: 20,
              color: PdfColor.fromHex(printObj.getPrintablePrimaryColor())),
        ));
