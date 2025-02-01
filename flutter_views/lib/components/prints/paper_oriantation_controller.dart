import 'package:flutter/material.dart';
import 'package:flutter_view_controller/components/base_controller_with_save_state.dart';
import 'package:flutter_view_controller/new_components/cards/cards.dart';
import 'dart:math' as math;

import 'package:flutter_view_controller/new_screens/theme.dart';

class PaperOriantaionController
    extends BaseWidgetControllerWithSave<PaperOriantation> {
  const PaperOriantaionController(
      {super.key, super.initialValue, super.onValueSelectedFunction});

  @override
  State<PaperOriantaionController> createState() => _PaperTypeControllerState();
}

class _PaperTypeControllerState extends State<PaperOriantaionController>
    with
        BaseWidgetControllerWithSaveState<PaperOriantation,
            PaperOriantaionController> {
  @override
  Widget build(BuildContext context) {
    Widget landscape = IconButton(
      onPressed: () {
        notifyValueSelected(PaperOriantation.landscape);
      },
      icon: Transform.rotate(
        angle: -math.pi / 2,
        child: Icon(
          Icons.note_outlined,
          color: getColor(PaperOriantation.landscape),
        ),
      ),
    );

    Widget portial = IconButton(
      onPressed: () {
        notifyValueSelected(PaperOriantation.portial);
      },
      icon: Icon(
        Icons.note_outlined,
        color: getColor(PaperOriantation.landscape),
      ),
    );
    bool isLarge = isLargeScreen(context);
    if (isLarge) {
      landscape = Cards(
        type: CardType.normal,
        child: (isHovered) => landscape,
      );
      portial = Cards(
        type: CardType.normal,
        child: (isHovered) => portial,
      );
    }
    return Row(mainAxisSize: MainAxisSize.min, children: [landscape, portial]);
  }

  Color getColor(PaperOriantation forWho) {
    // it was Theme.of(context).colorScheme.onPrimaryContainer
    return initialValue == forWho
        ? Theme.of(context).highlightColor
        : Theme.of(context).colorScheme.onPrimaryContainer;
  }
}

enum PaperOriantation { landscape, portial }
