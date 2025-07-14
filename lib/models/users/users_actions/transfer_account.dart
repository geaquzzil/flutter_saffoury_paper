import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/request_options.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/v_mirrors.dart';
import 'package:flutter_view_controller/models/view_abstract_stand_alone.dart';

import '../customers.dart';
import '../employees.dart';

@reflector
class TransferAccount
    extends ViewAbstractStandAloneCustomViewApi<TransferAccount> {
  Employee employee;
  Customer customerFrom;
  Customer customerTo;
  TransferAccount(this.employee, this.customerFrom, this.customerTo);
  @override
  TransferAccount getSelfNewInstance() {
    //TODO
    return TransferAccount(Employee(), Customer(), Customer());
  }

  @override
  TransferAccount fromJsonViewAbstract(Map<String, dynamic> json) {
    // TODO: implement fromJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  Map<String, IconData> getFieldIconDataMap() {
    // TODO: implement getFieldIconDataMap
    throw UnimplementedError();
  }

  @override
  Map<String, String> getFieldLabelMap(BuildContext context) {
    // TODO: implement getFieldLabelMap
    throw UnimplementedError();
  }

  @override
  String? getMainDrawerGroupName(BuildContext context) {
    // TODO: implement getMainDrawerGroupName
    throw UnimplementedError();
  }

  @override
  List<String> getMainFields({BuildContext? context}) {
    // TODO: implement getMainFields
    throw UnimplementedError();
  }

  @override
  bool getCustomStandAloneWidgetIsPadding() {
    return false;
  }

  @override
  String getMainHeaderLabelTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderLabelTextOnly
    throw UnimplementedError();
  }

  @override
  String getMainHeaderTextOnly(BuildContext context) {
    // TODO: implement getMainHeaderTextOnly
    throw UnimplementedError();
  }

  @override
  IconData getMainIconData() {
    // TODO: implement getMainIconData
    throw UnimplementedError();
  }

  @override
  String? getTableNameApi() => null;

  //todo api
  @override
  List<String>? getCustomAction() {
    return ["action_transfer_account"];
  }

  @override
  Map<String, dynamic> toJsonViewAbstract() {
    // TODO: implement toJsonViewAbstract
    throw UnimplementedError();
  }

  @override
  ResponseType getCustomStandAloneResponseType() {
    // TODO: implement getCustomStandAloneResponseType
    throw UnimplementedError();
  }

  @override
  Widget getCustomStandAloneWidget(BuildContext context) {
    // TODO: implement getCustomStandAloneWidget
    throw UnimplementedError();
  }

  @override
  List<Widget>? getCustomeStandAloneSideWidget(BuildContext context) => null;

  @override
  Widget? getCustomFloatingActionWidget(BuildContext context) {
    return null;
  }

  @override
  RequestOptions? getRequestOption({
    required ServerActions action,
    RequestOptions? generatedOptionFromListCall,
  }) {
    // TODO: implement getRequestOption
    throw UnimplementedError();
  }

  @override
  List<String>? getRequestedForginListOnCall({required ServerActions action}) {
    // TODO: implement getRequestedForginListOnCall
    throw UnimplementedError();
  }
}

// @RestOption(Action = "action_transfer_account", ChangeActionOnAdd = true)
// public class TransferringAccount extends ViewAbstract<TransferringAccount> {
//     @View(Type = Enums.ViewType.EXTENDED_AS_LIST, Priority = 0, ExpandIfCardView = true)
//     public Employee employee;
//     @View(Type = Enums.ViewType.EXTENDED_AS_LIST, Priority = 1, ExpandIfCardView = true)
//     public Customer customerFrom;
//     @View(Type = Enums.ViewType.DROP_LIST, Priority = 2, SeparateFromOtherView = true, SeparateFromInsideOtherView = true, RequireField = true)
//     public Customer customerTo;
//     public int from;
//     public int to;

//     public TransferringAccount(Customer from) {
//         employee = GlobalVariables.getEmployeeInstance();
//         this.customerFrom = from;
//         this.from = customerFrom.iD;
//     }

//     @Override
//     public boolean isSupportConfirmationDialogOption(Context context) {
//         return false;
//     }

//     @Override
//     public boolean setNewInstanceOnViewAbstractEditActivity() {
//         return false;
//     }

//     @Override
//     public Spanned getFieldLabel(Context context, Field field) {
//         switch (field.getName()) {
//             case "customerTo":
//                 return getHtmlFormat(context.getString(R.string.to));
//             case "purchasePrice":
//                 return getHtmlFormat(context.getString(R.string.purchases_price));
//             case "sellPrice":
//                 return getHtmlFormat(context.getString(R.string.sellPrice));
//             case "unit":
//                 return getHtmlFormat(context.getString(R.string.unit));
//             case "comments":
//                 return getHtmlFormat(context.getString(R.string.comments));
//         }

//         return super.getFieldLabel(context, field);
//     }

//     @Override
//     public MaterialDrawableBuilder.IconValue getCustomDrawableIcon(Context context) {
//         return MaterialDrawableBuilder.IconValue.ACCOUNT_SWITCH;
//     }

//     @Override
//     public MaterialDrawableBuilder.IconValue getDialogIcon(Context context) {
//         return getCustomDrawableIcon(context);
//     }

//     @Override
//     public boolean onAfterValidate(Context context) {
//         if (customerTo.iD == customerFrom.iD) {
//             Field field = null;
//             try {
//                 field = getField("customerFrom");
//             } catch (Exception e) {
//                 e.printStackTrace();
//             }
//             errorList.add(
//                     new BannerAdapterObject.BannerErrorFieldAndDescription(field,
//                             context.getString(R.string.errorCantTransferringToSameAccount), getFieldView(field)));

//             return false;
//         }
//         return super.onAfterValidate(context);
//     }

//     @Override
//     public void onDropListItemSelected(Context context, Field field, Object o) {
//         try {
//             field.set(this, o);
//         } catch (IllegalAccessException e) {
//             e.printStackTrace();
//         }
//         super.onDropListItemSelected(context, field, o);
//     }

//     @Override
//     public HashMap<String, Object> getCustomParams(Context context) {
//         HashMap<String, Object> hashMap = new HashMap<>();
//         hashMap.put("from", from);
//         hashMap.put("to", customerTo.iD);
//         return hashMap;
//     }

//     @Override
//     public UserLevels getUserPermissionLevel() {
//         return GlobalVariables.GetUserPermission();
//     }

//     @Override
//     public Spanned getHeaderText(Context context) {
//         return getHtmlFormat(String.format("%s <big>%s</big>", context.getString(R.string.transfer_account), customerFrom.getName()));
//     }

//     @Override
//     public Spanned getHeaderLabel(Context context) {
//         return getHtmlFormat(context.getString(R.string.transfer_account));
//     }

//     @Override
//     public Spanned getListHeaderLabel(Context context) {
//         return getHeaderLabel(context);
//     }
// }
