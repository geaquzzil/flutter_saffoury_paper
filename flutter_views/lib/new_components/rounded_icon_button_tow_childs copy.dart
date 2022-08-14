// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RoundedIconButtonTowChilds2 extends StatelessWidget {
  Widget largChild;
  IconData smallIcon;
  RoundedIconButtonTowChilds2({
    Key? key,
    required this.largChild,
    required this.smallIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // CircleAvatar(
          //   child: Icon(largChild),
          // ),
          largChild,
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 20,
              width: 20,
              child: IconButton(
                icon: Icon(smallIcon),
                onPressed: () {
                  // pickFile();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

//   void pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'png', 'jpeg'],
//     );

//     if (result != null) {
//       //TODO IF WEB then we have to use readBytes instead
//       String? path = result.files.single.path;
//       debugPrint("file path: $path");
//       // if (path != null) File file = File(path);
//     } else {
//       // User canceled the picker
//     }

// // if (result != null) {
// //   File file = File(result.files.single.path);
// // } else {
// //   // User canceled the picker
// // }
//   }
}
