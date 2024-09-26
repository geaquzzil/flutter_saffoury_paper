import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/file_reader/exporter/file_rader_object_exporter_view_abstract.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'file_raderl_list_object_exporter_view_abstract.dart';

enum PrintPageType { single, list, self_list }

enum FileExporterPageType { LIST, SINGLE }

///TODO api if viewAbstract is null
class FileExporterPage extends StatefulWidget {
  ViewAbstract viewAbstract;
  List<ViewAbstract>? list;

  FileExporterPage({super.key, required this.viewAbstract, this.list});

  @override
  State<StatefulWidget> createState() => _FileExporterPage();
}

class _FileExporterPage extends State<FileExporterPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  late FileExporterObject fileReaderObject;
  FileExporterObject? validatefileReaderObject;

  @override
  void initState() {
    super.initState();
    if (widget.list != null) {
      fileReaderObject = FileExporterListObject(
          viewAbstract: widget.viewAbstract, list: widget.list!);
    } else {
      fileReaderObject = FileExporterObject(viewAbstract: widget.viewAbstract);
    }
  }

  void _onIntroEnd(context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (_) => HomePage()),
    // );
  }

  Widget _buildImage(IconData assetName, [double width = 350]) {
    return Icon(assetName, size: width);
  }

  // void pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: [
  //       'xls',
  //       'xlsx',
  //     ],
  //   );

  //   if (result != null) {
  //     //TODO IF WEB then we have to use readBytes instead
  //     String? path = result.files.single.path;
  //     setState(() {
  //       _filePath = path;
  //       fileReaderObject = FileReaderObject(
  //           viewAbstract: widget.viewAbstract, filePath: _filePath!);
  //       fileReaderObject.init(context);
  //     });

  //     debugPrint("file path: $path");
  //     // if (path != null) File file = File(path);
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    fileReaderObject.init(context);
    const bodyStyle = TextStyle(fontSize: 19.0);

    var pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.titleLarge!,
      bodyTextStyle: Theme.of(context).textTheme.bodyLarge!,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      // pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: introKey,
      canProgress: (page) {
        int currentPage = page.round();
        if (currentPage == 0) {
          bool res = validatefileReaderObject != null;
          return res;
        } else if (currentPage == 1) {
          bool res = validatefileReaderObject != null;
          return res;
        }
        return true;
      },
      onSkip: () {},
      onChange: (value) {},

      // globalBackgroundColor: Colors.white,
      // autoScrollDuration: 3000,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage(Icons.flutter_dash, 40),
          ),
        ),
      ),
      // globalFooter: SizedBox(
      //   width: double.infinity,
      //   height: 60,
      //   child: ElevatedButton(
      //     child: const Text(
      //       'Let\'s go right away!',
      //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      //     ),
      //     onPressed: () => _onIntroEnd(context),
      //   ),
      // ),
      pages: [
        PageViewModel(
          title: AppLocalizations.of(context)!.selectColXsl,
          bodyWidget: Column(
            children: [
              const Text("SOSO"),
              BaseEditWidget(
                isTheFirst: true,
                onValidate: (viewAbstract) {
                  setState(() {
                    validatefileReaderObject =
                        viewAbstract as FileExporterObject?;
                  });

                  // if (validatefileReaderObject != null) {
                  //   (validatefileReaderObject as FileReaderObject)
                  //       .viewAbstract = widget.viewAbstract;

                  // }
                },
                viewAbstract: fileReaderObject,
              )
            ],
          ),
          // body:
          //     "Download the Stockpile app and master the market with our mini-lesson.",
          // image: _buildImage(Icons.abc_sharp, 50),
          decoration: pageDecoration,
        ),
        PageViewModel(
          //TODO Translate
          title: "Exporting verfication",
          body:
              "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          // image: _buildFullscreenImage(),
          footer: FutureBuilder(
            future: fileReaderObject.generateExcel(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return OutlinedButton(
                    onPressed: () {},
                    child: Text(AppLocalizations.of(context)!.ok));
              }
              return const Text("ERRRo");
            },
          ),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: Text(AppLocalizations.of(context)!.skip,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: Text(AppLocalizations.of(context)!.done,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Theme.of(context).colorScheme.onSurface,
        activeColor: Theme.of(context).colorScheme.primary,
        activeSize: const Size(22.0, 10.0),
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        // color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
