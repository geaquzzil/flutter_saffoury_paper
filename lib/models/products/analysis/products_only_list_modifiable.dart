import 'package:flutter_saffoury_paper/models/prints/print_product_list.dart';
import 'package:flutter_view_controller/interfaces/printable/printable_master.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
import 'package:flutter_view_controller/models/prints/print_local_setting.dart';

class ProductOnlyList extends ModifiablePrintableInterface<PrintProductList> {
  @override
  String getModifiableMainGroupName(BuildContext context) {
    // TODO: implement getModifiableMainGroupName
    throw UnimplementedError();
  }

  @override
  PrintableMaster<PrintLocalSetting> getModifiablePrintablePdfSetting(
      BuildContext context) {
    // TODO: implement getModifiablePrintablePdfSetting
    throw UnimplementedError();
  }

  @override
  IconData getModifibleIconData() {
    // TODO: implement getModifibleIconData
    throw UnimplementedError();
  }

  @override
  PrintProductList getModifibleSettingObject(BuildContext context) {
    // TODO: implement getModifibleSettingObject
    throw UnimplementedError();
  }

  @override
  String getModifibleTitleName(BuildContext context) {
    // TODO: implement getModifibleTitleName
    throw UnimplementedError();
  }
}
