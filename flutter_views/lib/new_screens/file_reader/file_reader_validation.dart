import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/new_screens/file_reader/file_rader_object_view_abstract.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class FileReaderValidationWidget extends StatelessWidget {
  FileReaderObject fileReaderObject;
  FileReaderValidationWidget({super.key, required this.fileReaderObject});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context
            .read<FilterableListApiProvider<FilterableData>>()
            .getServerData(fileReaderObject.viewAbstract),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(snapshot.data.toString());
          }
          return Center(
            child: Lottie.network(
                "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json"),
          );
        }));
  }
}
