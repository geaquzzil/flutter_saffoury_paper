import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class EditControllerFilePicker extends StatefulWidget {
  ViewAbstract viewAbstract;
  String field;
  EditControllerFilePicker(
      {super.key, required this.viewAbstract, required this.field});

  @override
  State<EditControllerFilePicker> createState() =>
      _EditControllerFilePickerState();
}

class _EditControllerFilePickerState extends State<EditControllerFilePicker> {
  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  Uint8List dataFromBase64String(String base64String) {
    // debugPrint("dataFromBase64String $base64String");
    return base64Decode(base64String);
  }

  String base64String(Uint8List? data) {
    if (data == null) return "";
    String base64 = base64Encode(data);
    // debugPrint("base64Encode $base64");
    return base64;
  }

  bool isHasImage() {
    return widget.viewAbstract.getImageUrlAddHost(context) != null;
  }

  bool isURL() {
    String? image = widget.viewAbstract.getImageUrlAddHost(context);
    if (image == null) return false;
    return Uri.parse(image).isAbsolute;
  }

  Widget getImageWidget() {
    if (isHasImage()) {
      if (isURL()) {
        return widget.viewAbstract.getCardLeadingCircleAvatar(context);
      } else {
        return Image.memory(
          dataFromBase64String(widget.viewAbstract.getFieldValue(widget.field)),
          width: 200,
          fit: BoxFit.fitWidth,
        );
      }
    } else {
      return widget.viewAbstract.getCardLeadingCircleAvatar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getImageWidget(),
          ElevatedButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  File file2 = File(result.files.single.path!);

                  //  Uint8List fileBytes = result.files.first.bytes;
                  PlatformFile file = result.files.first;
                  widget.viewAbstract.setFieldValue(
                      widget.field, base64String(file2.readAsBytesSync()));
                  debugPrint(file.name);

                  debugPrint(file.extension);
                  debugPrint(file.path);
                  setState(() {});
                  // File file = File(result.files.single.path);
                } else {
                  // User canceled the picker
                }
              },
              label: Text(AppLocalizations.of(context)!.loadImage))
        ],
      ),
    );
  }
}
