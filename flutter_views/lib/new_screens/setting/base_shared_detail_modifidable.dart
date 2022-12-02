import 'package:flutter/material.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/tables_widgets/cart_data_table_master.dart';
import 'package:flutter_view_controller/new_components/tab_bar/tab_bar.dart';
import 'package:flutter_view_controller/providers/settings/setting_provider.dart';
import 'package:flutter_view_controller/screens/base_shared_actions_header.dart';
import 'package:flutter_view_controller/screens/view/view_list_details.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../edit_new/base_edit_new.dart';

class BaseSettingDetailsView extends StatelessWidget {
  dynamic printSetting;
  BaseSettingDetailsView({Key? key, this.printSetting}) : super(key: key);
  Future<ViewAbstract?> getSetting(
      BuildContext context, ModifiableInterface settingObject) async {
    ViewAbstract? saved = await Configurations.get<ViewAbstract>(
        settingObject.getModifibleSettingObject(context),
        customKey: "_printsetting" + settingObject.runtimeType.toString());

    if (saved == null) {
      return settingObject.getModifibleSettingObject(context);
    } else {
      if (saved is PrintLocalSetting) {
        return saved.onSavedModiablePrintableLoaded(
            context, settingObject as ViewAbstract);
      }
      return saved;
    }
  }

  @override
  Widget build(BuildContext context) {
    ModifiableInterface? settingObject =
        context.watch<SettingProvider>().getSelectedObject;
    if (settingObject == null) {
      return getEmptyView(context);
    }
    return FutureBuilder<ViewAbstract?>(
      future: getSetting(context, settingObject),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
            controller: ScrollController(),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                BaseEditWidget(
                    viewAbstract: snapshot.data!,
                    isTheFirst: true,
                    onValidate: (viewAbstract) {
                      Configurations.save(
                          "_printsetting" +
                              settingObject.runtimeType.toString(),
                          viewAbstract);
                      context.read<SettingProvider>().change(settingObject);
                    }),
              ],
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget getEmptyView(BuildContext context) {
    //create a empty view with lottie
    return Center(
      child: Lottie.network(
          "https://assets4.lottiefiles.com/packages/lf20_gjvlmbzr.json"),
    );
  }
}
