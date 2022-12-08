import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_screens/edit/controllers/ext.dart';
import 'package:flutter_view_controller/new_screens/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/new_screens/file_reader/file_rader_object_view_abstract.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../models/view_abstract.dart';
import 'excel_dropbox_generator.dart';

class FileReaderPage extends StatefulWidget {
  ViewAbstract viewAbstract;
  FileReaderPage({super.key, required this.viewAbstract});

  @override
  State<StatefulWidget> createState() => _FileReaderPageState();
}

class _FileReaderPageState extends State<FileReaderPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  String? _filePath;

  void _onIntroEnd(context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (_) => HomePage()),
    // );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(IconData assetName, [double width = 350]) {
    return Icon(assetName, size: width);
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'xls',
        'xlsx',
      ],
    );

    if (result != null) {
      //TODO IF WEB then we have to use readBytes instead
      String? path = result.files.single.path;
      setState(() {
        _filePath = path;
      });

      debugPrint("file path: $path");
      // if (path != null) File file = File(path);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    var pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.titleLarge!,
      bodyTextStyle: Theme.of(context).textTheme.bodyLarge!,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      // pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      canProgress: (page) {
        int _currentPage = page.round();
        if (_currentPage == 0) {
          return _filePath != null;
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
            title: "Import file",
            body: "Let\'s go right away! and import the file\n",
            image: _buildImage(Icons.file_copy),
            decoration: pageDecoration,
            footer: Column(
              children: [
                ElevatedButton(
                  child: Text("Import"),
                  onPressed: () async {
                    pickFile();
                  },
                ),
                getSpace(),
                if (_filePath != null)
                  Text(
                    _filePath!,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary),
                  )
              ],
            )),
        PageViewModel(
          title: "Select columns",
          bodyWidget: Column(
            children: [
              Text("SOSO"),
              if (_filePath != null)
                BaseEditWidget(
                  isTheFirst: true,
                  viewAbstract: FileReaderObject(
                      viewAbstract: widget.viewAbstract, filePath: _filePath!),
                )
            ],
          ),
          // body:
          //     "Download the Stockpile app and master the market with our mini-lesson.",
          image: _buildImage(Icons.abc_sharp, 50),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Kids and teens",
          body:
              "Kids and teens can track their stocks 24/7 and place trades that you approve.",
          image: _buildImage(Icons.access_time),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Full Screen Page",
          body:
              "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          // image: _buildFullscreenImage(),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),
        PageViewModel(
          title: "Another title page",
          body: "Another beautiful body text for this example onboarding",
          image: _buildImage(Icons.sos),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'FooButton',
              // style: TextStyle(color: Colors.white),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Title of last page - reversed",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on ", style: bodyStyle),
              Icon(Icons.edit),
              Text(" to edit a post", style: bodyStyle),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage(Icons.face),
          reverse: true,
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
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Theme.of(context).colorScheme.onBackground,
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
