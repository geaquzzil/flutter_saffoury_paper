import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/base_controller_with_save_state.dart';
import 'package:pdf/pdf.dart';

class PaperOriantaionController
    extends BaseWidgetControllerWithSave<PaperOriantation> {
  const PaperOriantaionController(
      {super.key, super.initialValue, super.onValueSelectedFunction});

  @override
  State<PaperOriantaionController> createState() => _PaperTypeControllerState();

  static PaperOriantation findPaperOriantation(PdfPageFormat pdf) {
    return pdf.width > pdf.height
        ? PaperOriantation.landscape
        : PaperOriantation.portial;
  }
}

class _PaperTypeControllerState extends State<PaperOriantaionController>
    with
        BaseWidgetControllerWithSaveState<PaperOriantation,
            PaperOriantaionController> {
  @override
  Widget build(BuildContext context) {
    // return Text("dsa");
    Widget landscape = IconButton(
      onPressed: () {
        notifyValueSelected(PaperOriantation.portial);
      },
      icon: Transform.rotate(
        angle: -math.pi / 2,
        child: Icon(
          Icons.note_outlined,
          color: getColor(PaperOriantation.portial),
        ),
      ),
    );

    Widget portial = IconButton(
      onPressed: () {
        notifyValueSelected(PaperOriantation.landscape);
      },
      icon: Icon(
        Icons.note_outlined,
        color: getColor(PaperOriantation.landscape),
      ),
    );
    return Row(mainAxisSize: MainAxisSize.min, children: [landscape, portial]);
  }

  Color getColor(PaperOriantation forWho) {
    // return Colors.green;
    // it was Theme.of(context).colorScheme.onPrimaryContainer
    return initialValue == forWho
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;
  }
}

enum PaperOriantation { landscape, portial }
