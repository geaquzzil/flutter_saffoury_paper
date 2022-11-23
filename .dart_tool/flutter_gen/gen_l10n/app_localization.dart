import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localization_ar.dart';
import 'app_localization_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localization.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SaffouryPaper'**
  String get appTitle;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Saffoury Paper'**
  String get app_name;

  /// No description provided for @app_id.
  ///
  /// In en, this message translates to:
  /// **'ca-app-pub-4658218924549085~6259254114'**
  String get app_id;

  /// No description provided for @ad_unit_id.
  ///
  /// In en, this message translates to:
  /// **'ca-app-pub-4658218924549085/3360384762'**
  String get ad_unit_id;

  /// No description provided for @title_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get title_dashboard;

  /// No description provided for @title_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get title_notifications;

  /// No description provided for @dollarSymbol.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get dollarSymbol;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @cant_connect.
  ///
  /// In en, this message translates to:
  /// **'Can not connect, try again later'**
  String get cant_connect;

  /// No description provided for @syp.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get syp;

  /// No description provided for @sellPriceFormat.
  ///
  /// In en, this message translates to:
  /// **'Sell price for 1\$ is equals to '**
  String get sellPriceFormat;

  /// No description provided for @buyPriceFormat.
  ///
  /// In en, this message translates to:
  /// **'Buy price for 1\$ is equals to '**
  String get buyPriceFormat;

  /// No description provided for @product_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get product_name;

  /// No description provided for @product_width.
  ///
  /// In en, this message translates to:
  /// **'Width (MM)'**
  String get product_width;

  /// No description provided for @product_length.
  ///
  /// In en, this message translates to:
  /// **'Length (MM)'**
  String get product_length;

  /// No description provided for @product_bill.
  ///
  /// In en, this message translates to:
  /// **'Bill No'**
  String get product_bill;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @error_invalid_retail_price.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get error_invalid_retail_price;

  /// No description provided for @error_already_exists.
  ///
  /// In en, this message translates to:
  /// **'Product already exists on cart!'**
  String get error_already_exists;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @action_sign_in.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get action_sign_in;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'GUEST'**
  String get guest;

  /// No description provided for @action_sign_in_short.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get action_sign_in_short;

  /// No description provided for @error_invalid_phone.
  ///
  /// In en, this message translates to:
  /// **'Username is invalid'**
  String get error_invalid_phone;

  /// No description provided for @show_pwd.
  ///
  /// In en, this message translates to:
  /// **'Show Password'**
  String get show_pwd;

  /// No description provided for @error_invalid_password.
  ///
  /// In en, this message translates to:
  /// **'This password is too short'**
  String get error_invalid_password;

  /// No description provided for @error_incorrect_password.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Username or password'**
  String get error_incorrect_password;

  /// No description provided for @error_login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed!'**
  String get error_login_failed;

  /// No description provided for @error_field_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get error_field_required;

  /// No description provided for @add_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get add_to_cart;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @error_empty.
  ///
  /// In en, this message translates to:
  /// **'No items to show'**
  String get error_empty;

  /// No description provided for @success_upload.
  ///
  /// In en, this message translates to:
  /// **'Upload was successful!'**
  String get success_upload;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'(KG)'**
  String get kg;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @gsm.
  ///
  /// In en, this message translates to:
  /// **'GSM'**
  String get gsm;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @size_tow_dots.
  ///
  /// In en, this message translates to:
  /// **'Size:'**
  String get size_tow_dots;

  /// No description provided for @permission.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permission;

  /// No description provided for @communicate.
  ///
  /// In en, this message translates to:
  /// **'Communicate'**
  String get communicate;

  /// No description provided for @product_origin.
  ///
  /// In en, this message translates to:
  /// **'Product Origin'**
  String get product_origin;

  /// No description provided for @activated.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get activated;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Order(s)'**
  String get orders;

  /// No description provided for @receipts.
  ///
  /// In en, this message translates to:
  /// **'Receipt(s)'**
  String get receipts;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @product_unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get product_unit;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @equality.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get equality;

  /// No description provided for @no_content.
  ///
  /// In en, this message translates to:
  /// **'No content to show'**
  String get no_content;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @cap_new.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get cap_new;

  /// No description provided for @calculations.
  ///
  /// In en, this message translates to:
  /// **'Calculations'**
  String get calculations;

  /// No description provided for @incomes.
  ///
  /// In en, this message translates to:
  /// **'Incomes'**
  String get incomes;

  /// No description provided for @account_name.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get account_name;

  /// No description provided for @title_activity_product_movement.
  ///
  /// In en, this message translates to:
  /// **'Product(s) movements'**
  String get title_activity_product_movement;

  /// No description provided for @remaining_weight_label.
  ///
  /// In en, this message translates to:
  /// **'Remaining weight'**
  String get remaining_weight_label;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share app'**
  String get share;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee(s)'**
  String get employee;

  /// No description provided for @manufacture.
  ///
  /// In en, this message translates to:
  /// **'Manufactures'**
  String get manufacture;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product(s)'**
  String get product;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @product_type.
  ///
  /// In en, this message translates to:
  /// **'Product Type'**
  String get product_type;

  /// No description provided for @total_roll.
  ///
  /// In en, this message translates to:
  /// **'Roll(s) Count'**
  String get total_roll;

  /// No description provided for @noti_message_1.
  ///
  /// In en, this message translates to:
  /// **'I look forward to receiving your payment this week.'**
  String get noti_message_1;

  /// No description provided for @noti_message_2.
  ///
  /// In en, this message translates to:
  /// **'Thank you in advance for your prompt payment.'**
  String get noti_message_2;

  /// No description provided for @noti_message_3.
  ///
  /// In en, this message translates to:
  /// **'This is a friendly reminder that your invoice [#] payment is due next week'**
  String get noti_message_3;

  /// No description provided for @noti_message_4.
  ///
  /// In en, this message translates to:
  /// **'Please let me know if you have any questions about the invoice or if there’s anything I can do for you.'**
  String get noti_message_4;

  /// No description provided for @fb_new_product_1.
  ///
  /// In en, this message translates to:
  /// **'SaffouryPaper is pleased to announce a new line of products just arrived . Click to learn more'**
  String get fb_new_product_1;

  /// No description provided for @fb_new_product_2.
  ///
  /// In en, this message translates to:
  /// **'SaffouryPaper, your exclusive source for high quality products, The new load includes new sizes and gsms just for you deserve , Click To Learn More Now.'**
  String get fb_new_product_2;

  /// No description provided for @fb_new_product_3.
  ///
  /// In en, this message translates to:
  /// **'A load of new goods just arrived just available in our company'**
  String get fb_new_product_3;

  /// No description provided for @this_day.
  ///
  /// In en, this message translates to:
  /// **'This day'**
  String get this_day;

  /// No description provided for @money_fund.
  ///
  /// In en, this message translates to:
  /// **'Money Fund'**
  String get money_fund;

  /// No description provided for @spendings.
  ///
  /// In en, this message translates to:
  /// **'Expense(s)'**
  String get spendings;

  /// No description provided for @retry_connection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get retry_connection;

  /// No description provided for @retry_connection_message.
  ///
  /// In en, this message translates to:
  /// **'Sorry, no Internet connectivity detected. Please reconnect and try again.'**
  String get retry_connection_message;

  /// No description provided for @total_incomes.
  ///
  /// In en, this message translates to:
  /// **'Total income(s)'**
  String get total_incomes;

  /// No description provided for @purchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchases;

  /// No description provided for @balance_due.
  ///
  /// In en, this message translates to:
  /// **'Balance due'**
  String get balance_due;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'buy'**
  String get buy;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @grade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get grade;

  /// No description provided for @forget_get_account.
  ///
  /// In en, this message translates to:
  /// **'Forget password ?'**
  String get forget_get_account;

  /// No description provided for @unit_price.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get unit_price;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @movments.
  ///
  /// In en, this message translates to:
  /// **'Movements'**
  String get movments;

  /// No description provided for @sheets.
  ///
  /// In en, this message translates to:
  /// **'(Sheets)'**
  String get sheets;

  /// No description provided for @print_options.
  ///
  /// In en, this message translates to:
  /// **'Print and download options'**
  String get print_options;

  /// No description provided for @copies.
  ///
  /// In en, this message translates to:
  /// **'Copies'**
  String get copies;

  /// No description provided for @printerName.
  ///
  /// In en, this message translates to:
  /// **'Printer Name'**
  String get printerName;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @server_name.
  ///
  /// In en, this message translates to:
  /// **'Server Name'**
  String get server_name;

  /// No description provided for @shipment_price.
  ///
  /// In en, this message translates to:
  /// **'Shipment Price'**
  String get shipment_price;

  /// No description provided for @sellDollar.
  ///
  /// In en, this message translates to:
  /// **'العملات'**
  String get sellDollar;

  /// No description provided for @error_server_not_connected.
  ///
  /// In en, this message translates to:
  /// **'Can not connect to the server!'**
  String get error_server_not_connected;

  /// No description provided for @size_analyzer.
  ///
  /// In en, this message translates to:
  /// **'Size analyzer'**
  String get size_analyzer;

  /// No description provided for @error_sheet_zero.
  ///
  /// In en, this message translates to:
  /// **'Sheets can not be zero!'**
  String get error_sheet_zero;

  /// No description provided for @errDuplicatedEntery.
  ///
  /// In en, this message translates to:
  /// **'Error duplicate entry!'**
  String get errDuplicatedEntery;

  /// No description provided for @asc_ordering.
  ///
  /// In en, this message translates to:
  /// **'Enable ascending order'**
  String get asc_ordering;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @print_guide.
  ///
  /// In en, this message translates to:
  /// **'Print client guide'**
  String get print_guide;

  /// No description provided for @transfer_to_another.
  ///
  /// In en, this message translates to:
  /// **'Transfer to another account'**
  String get transfer_to_another;

  /// No description provided for @total_quantity.
  ///
  /// In en, this message translates to:
  /// **'Total quantity'**
  String get total_quantity;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @block_des.
  ///
  /// In en, this message translates to:
  /// **'Block the current account'**
  String get block_des;

  /// No description provided for @confirm_send_message_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm send a message to the selected account'**
  String get confirm_send_message_title;

  /// No description provided for @cofirm_send_message.
  ///
  /// In en, this message translates to:
  /// **'This may result charges on your phone bill ?'**
  String get cofirm_send_message;

  /// No description provided for @total_price.
  ///
  /// In en, this message translates to:
  /// **'Total price'**
  String get total_price;

  /// No description provided for @transfer_account.
  ///
  /// In en, this message translates to:
  /// **'Transferring account'**
  String get transfer_account;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Report title'**
  String get title;

  /// No description provided for @sales_analysis.
  ///
  /// In en, this message translates to:
  /// **'Sales Analysis'**
  String get sales_analysis;

  /// No description provided for @profit_analysis.
  ///
  /// In en, this message translates to:
  /// **'Profit And Loss Analysis'**
  String get profit_analysis;

  /// No description provided for @best_selling_GSM.
  ///
  /// In en, this message translates to:
  /// **'Best selling GSM'**
  String get best_selling_GSM;

  /// No description provided for @best_selling_size.
  ///
  /// In en, this message translates to:
  /// **'Best selling size'**
  String get best_selling_size;

  /// No description provided for @best_profitable_product.
  ///
  /// In en, this message translates to:
  /// **'Best profitable product(s)'**
  String get best_profitable_product;

  /// No description provided for @best_selling_category.
  ///
  /// In en, this message translates to:
  /// **'Best selling category'**
  String get best_selling_category;

  /// No description provided for @total_sales.
  ///
  /// In en, this message translates to:
  /// **'Total sales'**
  String get total_sales;

  /// No description provided for @overView_best_selling.
  ///
  /// In en, this message translates to:
  /// **'Best selling overview'**
  String get overView_best_selling;

  /// No description provided for @overview_sales_quantity.
  ///
  /// In en, this message translates to:
  /// **'Overview of sales quantity'**
  String get overview_sales_quantity;

  /// No description provided for @total_sales_Revenue.
  ///
  /// In en, this message translates to:
  /// **'Total sales revenue(s)'**
  String get total_sales_Revenue;

  /// No description provided for @total_expenses.
  ///
  /// In en, this message translates to:
  /// **'Total expense(s)'**
  String get total_expenses;

  /// No description provided for @dashboard_and_rep.
  ///
  /// In en, this message translates to:
  /// **'Dashboard And Reporting'**
  String get dashboard_and_rep;

  /// No description provided for @brief_details.
  ///
  /// In en, this message translates to:
  /// **'Print product in brief details'**
  String get brief_details;

  /// No description provided for @messsaging.
  ///
  /// In en, this message translates to:
  /// **'Messaging And Notifications'**
  String get messsaging;

  /// No description provided for @compose_hint.
  ///
  /// In en, this message translates to:
  /// **'Write a message to send it to all clients'**
  String get compose_hint;

  /// No description provided for @messaging.
  ///
  /// In en, this message translates to:
  /// **'Messaging'**
  String get messaging;

  /// No description provided for @err_permission.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to complete the action'**
  String get err_permission;

  /// No description provided for @user_name.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get user_name;

  /// No description provided for @approx.
  ///
  /// In en, this message translates to:
  /// **'≈'**
  String get approx;

  /// No description provided for @single_sheet_weight.
  ///
  /// In en, this message translates to:
  /// **'1Sheet Weight'**
  String get single_sheet_weight;

  /// No description provided for @send_account_info.
  ///
  /// In en, this message translates to:
  /// **'Send account Info (SMS)'**
  String get send_account_info;

  /// No description provided for @send_account_info_des.
  ///
  /// In en, this message translates to:
  /// **'Send the current account username, password and other information via (SMS)'**
  String get send_account_info_des;

  /// No description provided for @log_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get log_in;

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Conditions and the Privacy Policy'**
  String get terms_and_conditions;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish phone number'**
  String get publish;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @nextPayment.
  ///
  /// In en, this message translates to:
  /// **'Next payment(s)'**
  String get nextPayment;

  /// No description provided for @agree_terms_and_condition.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions and the Privacy Policy'**
  String get agree_terms_and_condition;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy;

  /// No description provided for @more_app.
  ///
  /// In en, this message translates to:
  /// **'More Apps'**
  String get more_app;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback And Suggestions'**
  String get feedback;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @open_license.
  ///
  /// In en, this message translates to:
  /// **'Open-Source Licenses'**
  String get open_license;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @subment.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get subment;

  /// No description provided for @selling_policy.
  ///
  /// In en, this message translates to:
  /// **'Selling Policies'**
  String get selling_policy;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone_number;

  /// No description provided for @printing_settings.
  ///
  /// In en, this message translates to:
  /// **'Printing settings'**
  String get printing_settings;

  /// No description provided for @report_footer.
  ///
  /// In en, this message translates to:
  /// **'Report footer'**
  String get report_footer;

  /// No description provided for @cash_box.
  ///
  /// In en, this message translates to:
  /// **'Cash box'**
  String get cash_box;

  /// No description provided for @install_facebook.
  ///
  /// In en, this message translates to:
  /// **'Install Facebook to continue'**
  String get install_facebook;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @previousBalance.
  ///
  /// In en, this message translates to:
  /// **'Previous balance'**
  String get previousBalance;

  /// No description provided for @total_net_profit.
  ///
  /// In en, this message translates to:
  /// **'Total net profit(s)'**
  String get total_net_profit;

  /// No description provided for @add_new.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get add_new;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @purchases_price.
  ///
  /// In en, this message translates to:
  /// **'Purchases price'**
  String get purchases_price;

  /// No description provided for @returnedProduct.
  ///
  /// In en, this message translates to:
  /// **'Returned Product'**
  String get returnedProduct;

  /// No description provided for @hideInvoiceUnitAndTotalPrice.
  ///
  /// In en, this message translates to:
  /// **'Hide invoice unit and total price'**
  String get hideInvoiceUnitAndTotalPrice;

  /// No description provided for @hideAccountBalance.
  ///
  /// In en, this message translates to:
  /// **'Hide account balance'**
  String get hideAccountBalance;

  /// No description provided for @printInvoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Print Invoice label'**
  String get printInvoiceLabel;

  /// No description provided for @printInvoiceLabelDes.
  ///
  /// In en, this message translates to:
  /// **'Set the invoice label printer from the pc. Otherwise, the label may print in the main printer'**
  String get printInvoiceLabelDes;

  /// No description provided for @hidePaymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Hide payment amount'**
  String get hidePaymentAmount;

  /// No description provided for @customs_clearnces.
  ///
  /// In en, this message translates to:
  /// **'Customs Clearances'**
  String get customs_clearnces;

  /// No description provided for @totalWaste.
  ///
  /// In en, this message translates to:
  /// **'Total waste'**
  String get totalWaste;

  /// No description provided for @reams.
  ///
  /// In en, this message translates to:
  /// **'(Reams)'**
  String get reams;

  /// No description provided for @not_now.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get not_now;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @write_review_tow.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write_review_tow;

  /// No description provided for @youHaveToAgreeterms.
  ///
  /// In en, this message translates to:
  /// **'You have to agree with our terms & conditions'**
  String get youHaveToAgreeterms;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @showSubTotlas.
  ///
  /// In en, this message translates to:
  /// **'Show subtotals'**
  String get showSubTotlas;

  /// No description provided for @hideAccountAddressAndPhone.
  ///
  /// In en, this message translates to:
  /// **'Hide account phone and address'**
  String get hideAccountAddressAndPhone;

  /// No description provided for @hideCurrency.
  ///
  /// In en, this message translates to:
  /// **'Hide currency'**
  String get hideCurrency;

  /// No description provided for @fillChangedProduct.
  ///
  /// In en, this message translates to:
  /// **'Fill product(s) that changed its original status to another color'**
  String get fillChangedProduct;

  /// No description provided for @showProductStatus.
  ///
  /// In en, this message translates to:
  /// **'Show the current product(s) status'**
  String get showProductStatus;

  /// No description provided for @allClintes.
  ///
  /// In en, this message translates to:
  /// **'All Clients Notebook'**
  String get allClintes;

  /// No description provided for @address1.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address1;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @viewAsLedger.
  ///
  /// In en, this message translates to:
  /// **'View as ledger'**
  String get viewAsLedger;

  /// No description provided for @showTotalCount.
  ///
  /// In en, this message translates to:
  /// **'Show total count'**
  String get showTotalCount;

  /// No description provided for @showReporting.
  ///
  /// In en, this message translates to:
  /// **'View summary reports in detailed mode'**
  String get showReporting;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @sellPrice.
  ///
  /// In en, this message translates to:
  /// **'Sell price'**
  String get sellPrice;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comment(s)'**
  String get comments;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @undefined.
  ///
  /// In en, this message translates to:
  /// **'Undefined'**
  String get undefined;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @pay1.
  ///
  /// In en, this message translates to:
  /// **'Payment in advance'**
  String get pay1;

  /// No description provided for @pay2.
  ///
  /// In en, this message translates to:
  /// **'Payment in the end of the week after invoice date'**
  String get pay2;

  /// No description provided for @pay3.
  ///
  /// In en, this message translates to:
  /// **'Payment seven days after invoice date'**
  String get pay3;

  /// No description provided for @pay4.
  ///
  /// In en, this message translates to:
  /// **'Payment ten days after invoice date'**
  String get pay4;

  /// No description provided for @pay5.
  ///
  /// In en, this message translates to:
  /// **'Payment 30 days after invoice date'**
  String get pay5;

  /// No description provided for @pay6.
  ///
  /// In en, this message translates to:
  /// **'End of month'**
  String get pay6;

  /// No description provided for @pay7.
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery'**
  String get pay7;

  /// No description provided for @pay8.
  ///
  /// In en, this message translates to:
  /// **'Payment of agreed amounts at stage'**
  String get pay8;

  /// No description provided for @waste1.
  ///
  /// In en, this message translates to:
  /// **'10 (mm)'**
  String get waste1;

  /// No description provided for @waste2.
  ///
  /// In en, this message translates to:
  /// **'20 (mm)'**
  String get waste2;

  /// No description provided for @waste3.
  ///
  /// In en, this message translates to:
  /// **'30 (mm)'**
  String get waste3;

  /// No description provided for @waste4.
  ///
  /// In en, this message translates to:
  /// **'40 (mm)'**
  String get waste4;

  /// No description provided for @waste5.
  ///
  /// In en, this message translates to:
  /// **'50 (mm)'**
  String get waste5;

  /// No description provided for @waste6.
  ///
  /// In en, this message translates to:
  /// **'60 (mm)'**
  String get waste6;

  /// No description provided for @waste7.
  ///
  /// In en, this message translates to:
  /// **'70 (mm)'**
  String get waste7;

  /// No description provided for @waste8.
  ///
  /// In en, this message translates to:
  /// **'80 (mm)'**
  String get waste8;

  /// No description provided for @waste9.
  ///
  /// In en, this message translates to:
  /// **'90 (mm)'**
  String get waste9;

  /// No description provided for @waste10.
  ///
  /// In en, this message translates to:
  /// **'100 (mm)'**
  String get waste10;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get thisYear;

  /// No description provided for @pallet.
  ///
  /// In en, this message translates to:
  /// **'Pallet(s)'**
  String get pallet;

  /// No description provided for @palletOne.
  ///
  /// In en, this message translates to:
  /// **'Pallet'**
  String get palletOne;

  /// No description provided for @reel.
  ///
  /// In en, this message translates to:
  /// **'Reel(s)'**
  String get reel;

  /// No description provided for @wasted.
  ///
  /// In en, this message translates to:
  /// **'Wasted'**
  String get wasted;

  /// No description provided for @termsDate.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get termsDate;

  /// No description provided for @cutRequest.
  ///
  /// In en, this message translates to:
  /// **'Cut request(s)'**
  String get cutRequest;

  /// No description provided for @cutRequestResult.
  ///
  /// In en, this message translates to:
  /// **'Cut request(s) result(s)'**
  String get cutRequestResult;

  /// No description provided for @productsInput.
  ///
  /// In en, this message translates to:
  /// **'Product(s) input'**
  String get productsInput;

  /// No description provided for @productsOutput.
  ///
  /// In en, this message translates to:
  /// **'Product(s) output'**
  String get productsOutput;

  /// No description provided for @transfers.
  ///
  /// In en, this message translates to:
  /// **'Transfer(s)'**
  String get transfers;

  /// No description provided for @purchasesRefund.
  ///
  /// In en, this message translates to:
  /// **'Purchase(s) refund'**
  String get purchasesRefund;

  /// No description provided for @ordersRefund.
  ///
  /// In en, this message translates to:
  /// **'Order(s) refund'**
  String get ordersRefund;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @openingStock.
  ///
  /// In en, this message translates to:
  /// **'Opening stock'**
  String get openingStock;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @threeZeroPrice.
  ///
  /// In en, this message translates to:
  /// **'\"Three zeros \"'**
  String get threeZeroPrice;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @printAndDownload.
  ///
  /// In en, this message translates to:
  /// **'Print and download'**
  String get printAndDownload;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @showOnly.
  ///
  /// In en, this message translates to:
  /// **'Show only'**
  String get showOnly;

  /// No description provided for @printOptionsEnum.
  ///
  /// In en, this message translates to:
  /// **'Print options'**
  String get printOptionsEnum;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @saveOnly.
  ///
  /// In en, this message translates to:
  /// **'Save only'**
  String get saveOnly;

  /// No description provided for @printerLabelName.
  ///
  /// In en, this message translates to:
  /// **'Label printer name'**
  String get printerLabelName;

  /// No description provided for @reportOption.
  ///
  /// In en, this message translates to:
  /// **'Report options'**
  String get reportOption;

  /// No description provided for @reportHeader.
  ///
  /// In en, this message translates to:
  /// **'Report header'**
  String get reportHeader;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Product(s)'**
  String get products;

  /// No description provided for @invoices.
  ///
  /// In en, this message translates to:
  /// **'Invoice(s)'**
  String get invoices;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credit(s)'**
  String get credits;

  /// No description provided for @debits.
  ///
  /// In en, this message translates to:
  /// **'Debits'**
  String get debits;

  /// No description provided for @productLabel.
  ///
  /// In en, this message translates to:
  /// **'Product label'**
  String get productLabel;

  /// No description provided for @printType.
  ///
  /// In en, this message translates to:
  /// **'Print type'**
  String get printType;

  /// No description provided for @invoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice label'**
  String get invoiceLabel;

  /// No description provided for @instock.
  ///
  /// In en, this message translates to:
  /// **'Instock'**
  String get instock;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @cantAddMoreItem.
  ///
  /// In en, this message translates to:
  /// **'Can not add more items'**
  String get cantAddMoreItem;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @errCantEditCutRequest.
  ///
  /// In en, this message translates to:
  /// **'Can not edit cut request because it\\\'s generated from cut request result'**
  String get errCantEditCutRequest;

  /// No description provided for @errCantEditJournalVoucher.
  ///
  /// In en, this message translates to:
  /// **'Can not edit this record because it\\\'s generated from journal voucher record'**
  String get errCantEditJournalVoucher;

  /// No description provided for @journalVoucher.
  ///
  /// In en, this message translates to:
  /// **'Journal Voucher'**
  String get journalVoucher;

  /// No description provided for @journalAccount.
  ///
  /// In en, this message translates to:
  /// **'Journal account'**
  String get journalAccount;

  /// No description provided for @directPayment.
  ///
  /// In en, this message translates to:
  /// **'Direct payment'**
  String get directPayment;

  /// No description provided for @oneDashOneCredits.
  ///
  /// In en, this message translates to:
  /// **'1–1 Credit/Debit'**
  String get oneDashOneCredits;

  /// No description provided for @oneDashOneDebits.
  ///
  /// In en, this message translates to:
  /// **'1–1 Debit'**
  String get oneDashOneDebits;

  /// No description provided for @remainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining balance'**
  String get remainingBalance;

  /// No description provided for @payemntAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment amount'**
  String get payemntAmount;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get contactInfo;

  /// No description provided for @addressInfo.
  ///
  /// In en, this message translates to:
  /// **'Address info'**
  String get addressInfo;

  /// No description provided for @errorWarehouseIsEquals.
  ///
  /// In en, this message translates to:
  /// **'Please select different  from to warehouse'**
  String get errorWarehouseIsEquals;

  /// No description provided for @errorOneOrMoreWarehouseIsNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Error, one or the both warehouses is not selected!'**
  String get errorOneOrMoreWarehouseIsNotSelected;

  /// No description provided for @printerSetting.
  ///
  /// In en, this message translates to:
  /// **'Printer settings'**
  String get printerSetting;

  /// No description provided for @priceInfo.
  ///
  /// In en, this message translates to:
  /// **'Price info'**
  String get priceInfo;

  /// No description provided for @total_sales_refunds.
  ///
  /// In en, this message translates to:
  /// **'Total sales refund(s)'**
  String get total_sales_refunds;

  /// No description provided for @pendingCutRequest.
  ///
  /// In en, this message translates to:
  /// **'Pending Cut Request(s)'**
  String get pendingCutRequest;

  /// No description provided for @viewParents.
  ///
  /// In en, this message translates to:
  /// **'View parents'**
  String get viewParents;

  /// No description provided for @productParents.
  ///
  /// In en, this message translates to:
  /// **'Parents'**
  String get productParents;

  /// No description provided for @errSelectAnotherJournalAccount.
  ///
  /// In en, this message translates to:
  /// **'\"Please select another journal account \"'**
  String get errSelectAnotherJournalAccount;

  /// No description provided for @sendToClient.
  ///
  /// In en, this message translates to:
  /// **'Send to a client'**
  String get sendToClient;

  /// No description provided for @findSimilar.
  ///
  /// In en, this message translates to:
  /// **'Find similar product(s)'**
  String get findSimilar;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account(s) type'**
  String get accountType;

  /// No description provided for @customerContacts.
  ///
  /// In en, this message translates to:
  /// **'Customer contacts'**
  String get customerContacts;

  /// No description provided for @total_count.
  ///
  /// In en, this message translates to:
  /// **'Total count'**
  String get total_count;

  /// No description provided for @addAllToCart.
  ///
  /// In en, this message translates to:
  /// **'Add all to cart'**
  String get addAllToCart;

  /// No description provided for @printAsCatalog.
  ///
  /// In en, this message translates to:
  /// **'Print as catalog'**
  String get printAsCatalog;

  /// No description provided for @collectSimilarProducts.
  ///
  /// In en, this message translates to:
  /// **'Collect similar products'**
  String get collectSimilarProducts;

  /// No description provided for @hideQuantity.
  ///
  /// In en, this message translates to:
  /// **'Hide quantity'**
  String get hideQuantity;

  /// No description provided for @totalInput.
  ///
  /// In en, this message translates to:
  /// **'Total input'**
  String get totalInput;

  /// No description provided for @totalOutput.
  ///
  /// In en, this message translates to:
  /// **'Total output'**
  String get totalOutput;

  /// No description provided for @customerRequestSizes.
  ///
  /// In en, this message translates to:
  /// **'Customer request(s)'**
  String get customerRequestSizes;

  /// No description provided for @sheetsPerReam.
  ///
  /// In en, this message translates to:
  /// **'Sheets per ream'**
  String get sheetsPerReam;

  /// No description provided for @action_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get action_settings;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @set_exchange_rate_buy.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate (BUY)'**
  String get set_exchange_rate_buy;

  /// No description provided for @set_exchange_rate_sell.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate (SELL)'**
  String get set_exchange_rate_sell;

  /// No description provided for @old_exchange_rate_sell.
  ///
  /// In en, this message translates to:
  /// **'Old exchange rate (SELL)'**
  String get old_exchange_rate_sell;

  /// No description provided for @old_exchange_rate_buy.
  ///
  /// In en, this message translates to:
  /// **'Old exchange rate (BUY)'**
  String get old_exchange_rate_buy;

  /// No description provided for @disable_notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Disable Notifications'**
  String get disable_notifications_title;

  /// No description provided for @enable_server_title.
  ///
  /// In en, this message translates to:
  /// **'Enable SaffouryPaper Server'**
  String get enable_server_title;

  /// No description provided for @sypDots.
  ///
  /// In en, this message translates to:
  /// **'S.Y.P'**
  String get sypDots;

  /// No description provided for @errOnlyAdminsCanBlockEmployee.
  ///
  /// In en, this message translates to:
  /// **'Only admins can block employees'**
  String get errOnlyAdminsCanBlockEmployee;

  /// No description provided for @exchange.
  ///
  /// In en, this message translates to:
  /// **'Exchange'**
  String get exchange;

  /// No description provided for @setCustomsDeclarationToProduct.
  ///
  /// In en, this message translates to:
  /// **'Customs declaration to products'**
  String get setCustomsDeclarationToProduct;

  /// No description provided for @forLabel.
  ///
  /// In en, this message translates to:
  /// **'For'**
  String get forLabel;

  /// No description provided for @restToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get restToDefault;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup server'**
  String get backup;

  /// No description provided for @newRecord.
  ///
  /// In en, this message translates to:
  /// **'This is a new record'**
  String get newRecord;

  /// No description provided for @enableMultiEditing.
  ///
  /// In en, this message translates to:
  /// **'Enable editing by multiple employees'**
  String get enableMultiEditing;

  /// No description provided for @errWidthNotEqualsToProduct.
  ///
  /// In en, this message translates to:
  /// **'The sum of the width of the required sizes is (not equal) to the width of the original product'**
  String get errWidthNotEqualsToProduct;

  /// No description provided for @errQuantityNotEqualsToProduct.
  ///
  /// In en, this message translates to:
  /// **'The sum of total request sizes quantity are (not equal) to the request quantity'**
  String get errQuantityNotEqualsToProduct;

  /// No description provided for @reservationInvoice.
  ///
  /// In en, this message translates to:
  /// **'Reservation'**
  String get reservationInvoice;

  /// No description provided for @mustBePaidBefore.
  ///
  /// In en, this message translates to:
  /// **'This invoice must be paid before'**
  String get mustBePaidBefore;

  /// No description provided for @money_fund_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Money fund dashboard'**
  String get money_fund_dashboard;

  /// No description provided for @pendingReservationInvoices.
  ///
  /// In en, this message translates to:
  /// **'Pending reservation invoice(s)'**
  String get pendingReservationInvoices;

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New product(s)'**
  String get newProduct;

  /// No description provided for @openApp.
  ///
  /// In en, this message translates to:
  /// **'Open app'**
  String get openApp;

  /// No description provided for @notDueYet.
  ///
  /// In en, this message translates to:
  /// **'Not due yet'**
  String get notDueYet;

  /// No description provided for @overDue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overDue;

  /// No description provided for @before.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get before;

  /// No description provided for @until.
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get until;

  /// No description provided for @blockMood.
  ///
  /// In en, this message translates to:
  /// **'Block mood'**
  String get blockMood;

  /// No description provided for @totalSheetNumberByReams.
  ///
  /// In en, this message translates to:
  /// **'Total sheet(s)'**
  String get totalSheetNumberByReams;

  /// No description provided for @weightPerSheet.
  ///
  /// In en, this message translates to:
  /// **'Weight per one sheet'**
  String get weightPerSheet;

  /// No description provided for @pricePerSheet.
  ///
  /// In en, this message translates to:
  /// **'Price per one sheet'**
  String get pricePerSheet;

  /// No description provided for @sheetsInNotPrac.
  ///
  /// In en, this message translates to:
  /// **'Sheet(s)'**
  String get sheetsInNotPrac;

  /// No description provided for @per_each.
  ///
  /// In en, this message translates to:
  /// **'Per each'**
  String get per_each;

  /// No description provided for @nameInArabic.
  ///
  /// In en, this message translates to:
  /// **'Name in arabic'**
  String get nameInArabic;

  /// No description provided for @token.
  ///
  /// In en, this message translates to:
  /// **'Notification token'**
  String get token;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @products_type.
  ///
  /// In en, this message translates to:
  /// **'Product(s) type'**
  String get products_type;

  /// No description provided for @improterInfo.
  ///
  /// In en, this message translates to:
  /// **'Supplier Company Information'**
  String get improterInfo;

  /// No description provided for @customsNumber.
  ///
  /// In en, this message translates to:
  /// **'Customs clearance number'**
  String get customsNumber;

  /// No description provided for @grain.
  ///
  /// In en, this message translates to:
  /// **'Grain'**
  String get grain;

  /// No description provided for @numOfOverdues.
  ///
  /// In en, this message translates to:
  /// **'Num of overdues'**
  String get numOfOverdues;

  /// No description provided for @interimInvoice.
  ///
  /// In en, this message translates to:
  /// **'Interim invoice(s)'**
  String get interimInvoice;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'Item count'**
  String get itemCount;

  /// No description provided for @untilEndOf.
  ///
  /// In en, this message translates to:
  /// **'Until end of'**
  String get untilEndOf;

  /// No description provided for @expencesThenIncomes.
  ///
  /// In en, this message translates to:
  /// **'Expense(s) then income(s)'**
  String get expencesThenIncomes;

  /// No description provided for @incomesThenExpences.
  ///
  /// In en, this message translates to:
  /// **'Income(s) then Expense(s)'**
  String get incomesThenExpences;

  /// No description provided for @pendingFirst.
  ///
  /// In en, this message translates to:
  /// **'Pending first'**
  String get pendingFirst;

  /// No description provided for @valueInDollar.
  ///
  /// In en, this message translates to:
  /// **'Value in (Dollar)'**
  String get valueInDollar;

  /// No description provided for @a3ProductLabel.
  ///
  /// In en, this message translates to:
  /// **'Print as A3 size (29.7 x 42.0)'**
  String get a3ProductLabel;

  /// No description provided for @a4ProductLabel.
  ///
  /// In en, this message translates to:
  /// **'Print as A4 size (21.0 x 29.7)'**
  String get a4ProductLabel;

  /// No description provided for @a5ProductLabel.
  ///
  /// In en, this message translates to:
  /// **'Print as A5 size (14.8 x 21.0)'**
  String get a5ProductLabel;

  /// No description provided for @tenByTwintyProductLabel.
  ///
  /// In en, this message translates to:
  /// **'Print as (20 x 10) size'**
  String get tenByTwintyProductLabel;

  /// No description provided for @swipeUpToLogin.
  ///
  /// In en, this message translates to:
  /// **'Swipe up to login'**
  String get swipeUpToLogin;

  /// No description provided for @employeesWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Employee\\\'s warehouse'**
  String get employeesWarehouse;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @anotherScanCodeDetected.
  ///
  /// In en, this message translates to:
  /// **'Skipped! Another scan code detected'**
  String get anotherScanCodeDetected;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @customerRequestSizesDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer request(s) size details'**
  String get customerRequestSizesDetails;

  /// No description provided for @startEndPage.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get startEndPage;

  /// No description provided for @startEndPageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1, 1–8 , 6'**
  String get startEndPageHint;

  /// No description provided for @calculationsDes.
  ///
  /// In en, this message translates to:
  /// **'Find a specific measurement calculation within the product specifications'**
  String get calculationsDes;

  /// No description provided for @simialrProducts.
  ///
  /// In en, this message translates to:
  /// **'Similar Product(s)'**
  String get simialrProducts;

  /// No description provided for @sorting.
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get sorting;

  /// No description provided for @broadcast.
  ///
  /// In en, this message translates to:
  /// **'Broadcast'**
  String get broadcast;

  /// No description provided for @showInvoiceRefund.
  ///
  /// In en, this message translates to:
  /// **'Show invoice refund(s)'**
  String get showInvoiceRefund;

  /// No description provided for @switchProductType.
  ///
  /// In en, this message translates to:
  /// **'Switch product type name'**
  String get switchProductType;

  /// No description provided for @changeAll.
  ///
  /// In en, this message translates to:
  /// **'Change all'**
  String get changeAll;

  /// No description provided for @changeOnlyCutRoll.
  ///
  /// In en, this message translates to:
  /// **'Change only cutted product(s)'**
  String get changeOnlyCutRoll;

  /// No description provided for @originalProductType.
  ///
  /// In en, this message translates to:
  /// **'Original product type'**
  String get originalProductType;

  /// No description provided for @totalIncomesAndExpences.
  ///
  /// In en, this message translates to:
  /// **'Total incoming and outgoing'**
  String get totalIncomesAndExpences;

  /// No description provided for @threeZeroPriceDes.
  ///
  /// In en, this message translates to:
  /// **'Multiply the original value by 1000'**
  String get threeZeroPriceDes;

  /// No description provided for @asc_orderingDes.
  ///
  /// In en, this message translates to:
  /// **'Sort in asc order'**
  String get asc_orderingDes;

  /// No description provided for @printAsCatalogDes.
  ///
  /// In en, this message translates to:
  /// **'Show the first page as company profile'**
  String get printAsCatalogDes;

  /// No description provided for @hideQuantityDes.
  ///
  /// In en, this message translates to:
  /// **'Hide product quantities available'**
  String get hideQuantityDes;

  /// No description provided for @adminSetting.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get adminSetting;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutMessage;

  /// No description provided for @customQuanitity.
  ///
  /// In en, this message translates to:
  /// **'Custom quantity'**
  String get customQuanitity;

  /// No description provided for @dontPrintWasteProductLabel.
  ///
  /// In en, this message translates to:
  /// **'Do not print the wasted product'**
  String get dontPrintWasteProductLabel;

  /// No description provided for @hideCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Hide customer name'**
  String get hideCustomerName;

  /// No description provided for @deletePcSoftware.
  ///
  /// In en, this message translates to:
  /// **'Delete pc software'**
  String get deletePcSoftware;

  /// No description provided for @defaultReportSize.
  ///
  /// In en, this message translates to:
  /// **'Default report size'**
  String get defaultReportSize;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @hideTerms.
  ///
  /// In en, this message translates to:
  /// **'Hide terms'**
  String get hideTerms;

  /// No description provided for @send_cut_request_info.
  ///
  /// In en, this message translates to:
  /// **'Send cut request(s) info'**
  String get send_cut_request_info;

  /// No description provided for @sendViaSMS.
  ///
  /// In en, this message translates to:
  /// **'Send Via SMS'**
  String get sendViaSMS;

  /// No description provided for @sendViaWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Send Via Whatsapp'**
  String get sendViaWhatsapp;

  /// No description provided for @shareContent.
  ///
  /// In en, this message translates to:
  /// **'Share content'**
  String get shareContent;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @grainOnTheLengthOfCut.
  ///
  /// In en, this message translates to:
  /// **'Grain according to the length of the cut'**
  String get grainOnTheLengthOfCut;

  /// No description provided for @grainOn.
  ///
  /// In en, this message translates to:
  /// **'Grain on'**
  String get grainOn;

  /// No description provided for @availableIn.
  ///
  /// In en, this message translates to:
  /// **'Available in'**
  String get availableIn;

  /// No description provided for @cantConnectConnectToRetry.
  ///
  /// In en, this message translates to:
  /// **'Can not connect to server, Click here to reconnect!'**
  String get cantConnectConnectToRetry;

  /// No description provided for @mr.
  ///
  /// In en, this message translates to:
  /// **'Mr/Mrs'**
  String get mr;

  /// No description provided for @changeQuantity.
  ///
  /// In en, this message translates to:
  /// **'Change quantity'**
  String get changeQuantity;

  /// No description provided for @customerBalance.
  ///
  /// In en, this message translates to:
  /// **'Customer balance'**
  String get customerBalance;

  /// No description provided for @showBarcodes.
  ///
  /// In en, this message translates to:
  /// **'Show barcodes'**
  String get showBarcodes;

  /// No description provided for @showBarcodesDes.
  ///
  /// In en, this message translates to:
  /// **'Show all product barcodes details'**
  String get showBarcodesDes;

  /// No description provided for @hideEmployee.
  ///
  /// In en, this message translates to:
  /// **'Hide employee name'**
  String get hideEmployee;

  /// No description provided for @errLaunchApp.
  ///
  /// In en, this message translates to:
  /// **'Action not launching correctly'**
  String get errLaunchApp;

  /// No description provided for @accountStatement.
  ///
  /// In en, this message translates to:
  /// **'Account statement'**
  String get accountStatement;

  /// No description provided for @errServerNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, we are currently unable to connect you to our servers\\n\nPlease contact the administrator …'**
  String get errServerNotAvailable;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @last.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get last;

  /// No description provided for @title_activity_test_to_remove.
  ///
  /// In en, this message translates to:
  /// **'test_to_remove'**
  String get title_activity_test_to_remove;

  /// No description provided for @tab_text_1.
  ///
  /// In en, this message translates to:
  /// **'Tab 1'**
  String get tab_text_1;

  /// No description provided for @tab_text_2.
  ///
  /// In en, this message translates to:
  /// **'Tab 2'**
  String get tab_text_2;

  /// No description provided for @trySizeAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'Try size analyzer'**
  String get trySizeAnalyzer;

  /// No description provided for @trySizeAnalyzerDes.
  ///
  /// In en, this message translates to:
  /// **'Try Volume Analyzer to find the closest possible size through the options you want'**
  String get trySizeAnalyzerDes;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @justArrived.
  ///
  /// In en, this message translates to:
  /// **'Just arrived'**
  String get justArrived;

  /// No description provided for @basedOnYourSearch.
  ///
  /// In en, this message translates to:
  /// **'Based on your search'**
  String get basedOnYourSearch;

  /// No description provided for @quantityShortCut.
  ///
  /// In en, this message translates to:
  /// **'QTY'**
  String get quantityShortCut;

  /// No description provided for @unitPriceShortCut.
  ///
  /// In en, this message translates to:
  /// **'U.P'**
  String get unitPriceShortCut;

  /// No description provided for @warehouseShortCut.
  ///
  /// In en, this message translates to:
  /// **'W.R.C'**
  String get warehouseShortCut;

  /// No description provided for @productWithoutS.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productWithoutS;

  /// No description provided for @chooseBrand.
  ///
  /// In en, this message translates to:
  /// **'Choose brand'**
  String get chooseBrand;

  /// No description provided for @errorCantTransferringToSameAccount.
  ///
  /// In en, this message translates to:
  /// **'Can not transferring to same account, please select another account'**
  String get errorCantTransferringToSameAccount;

  /// No description provided for @activeCurrentAccount.
  ///
  /// In en, this message translates to:
  /// **'Allow this account to use the app'**
  String get activeCurrentAccount;

  /// No description provided for @cargoTransporters.
  ///
  /// In en, this message translates to:
  /// **'Cargo transporter(s)'**
  String get cargoTransporters;

  /// No description provided for @governorates.
  ///
  /// In en, this message translates to:
  /// **'Governorate(s)'**
  String get governorates;

  /// No description provided for @carNumber.
  ///
  /// In en, this message translates to:
  /// **'Car number'**
  String get carNumber;

  /// No description provided for @productsColors.
  ///
  /// In en, this message translates to:
  /// **'Product color(s)'**
  String get productsColors;

  /// No description provided for @adsImages.
  ///
  /// In en, this message translates to:
  /// **'Ads image(s)'**
  String get adsImages;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @there.
  ///
  /// In en, this message translates to:
  /// **'There'**
  String get there;

  /// No description provided for @productsWithSimilarSize.
  ///
  /// In en, this message translates to:
  /// **'Product(s) with similar size'**
  String get productsWithSimilarSize;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most popular'**
  String get mostPopular;

  /// No description provided for @dashboard_and_repCheck.
  ///
  /// In en, this message translates to:
  /// **'Check out your dashboard and reports'**
  String get dashboard_and_repCheck;

  /// No description provided for @lifetime.
  ///
  /// In en, this message translates to:
  /// **'Life time'**
  String get lifetime;

  /// No description provided for @notDisposited.
  ///
  /// In en, this message translates to:
  /// **'Not deposited'**
  String get notDisposited;

  /// No description provided for @desposited.
  ///
  /// In en, this message translates to:
  /// **'Deposited'**
  String get desposited;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @customerBalances.
  ///
  /// In en, this message translates to:
  /// **'Customer balances'**
  String get customerBalances;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @hideCargoInfo.
  ///
  /// In en, this message translates to:
  /// **'Hide transporter information'**
  String get hideCargoInfo;

  /// No description provided for @featuresMayBeUnAv.
  ///
  /// In en, this message translates to:
  /// **'Some features may be unavailable. Please check that you have enable all permissions'**
  String get featuresMayBeUnAv;

  /// No description provided for @hiThere.
  ///
  /// In en, this message translates to:
  /// **'Hi, There'**
  String get hiThere;

  /// No description provided for @signInWithYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your account'**
  String get signInWithYourAccount;

  /// No description provided for @app_name_spanned.
  ///
  /// In en, this message translates to:
  /// **'SaffouryPaper'**
  String get app_name_spanned;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @no_search_result.
  ///
  /// In en, this message translates to:
  /// **'No result(s)!'**
  String get no_search_result;

  /// No description provided for @basedOnYourLastSearch.
  ///
  /// In en, this message translates to:
  /// **'Based on your last search'**
  String get basedOnYourLastSearch;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get searching;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search…'**
  String get search;

  /// No description provided for @denied_permission_cant_show.
  ///
  /// In en, this message translates to:
  /// **'Denied permission'**
  String get denied_permission_cant_show;

  /// No description provided for @dateEnum.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateEnum;

  /// No description provided for @block_all_message.
  ///
  /// In en, this message translates to:
  /// **'Block all message'**
  String get block_all_message;

  /// No description provided for @cantConnect.
  ///
  /// In en, this message translates to:
  /// **'Can not connect, try again later'**
  String get cantConnect;

  /// No description provided for @cantConnectRetry.
  ///
  /// In en, this message translates to:
  /// **'Can not connect, retry!'**
  String get cantConnectRetry;

  /// No description provided for @errOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed for some reason!'**
  String get errOperationFailed;

  /// No description provided for @errLogin.
  ///
  /// In en, this message translates to:
  /// **'Login error: There is an error in logging you in. Please try again later.'**
  String get errLogin;

  /// No description provided for @successAdded.
  ///
  /// In en, this message translates to:
  /// **'Successfully added!'**
  String get successAdded;

  /// No description provided for @successEdited.
  ///
  /// In en, this message translates to:
  /// **'Successfully edited!'**
  String get successEdited;

  /// No description provided for @successDeleted.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted!'**
  String get successDeleted;

  /// No description provided for @navigation_drawer_open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get navigation_drawer_open;

  /// No description provided for @navigation_drawer_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get navigation_drawer_close;

  /// No description provided for @pleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please select…'**
  String get pleaseSelect;

  /// No description provided for @accountNotActive.
  ///
  /// In en, this message translates to:
  /// **'Account not activated'**
  String get accountNotActive;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loadImage.
  ///
  /// In en, this message translates to:
  /// **'Load image'**
  String get loadImage;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @moreThreeDots.
  ///
  /// In en, this message translates to:
  /// **'More…'**
  String get moreThreeDots;

  /// No description provided for @editing.
  ///
  /// In en, this message translates to:
  /// **'Editing'**
  String get editing;

  /// No description provided for @notDefined.
  ///
  /// In en, this message translates to:
  /// **'Not defined'**
  String get notDefined;

  /// No description provided for @errField.
  ///
  /// In en, this message translates to:
  /// **'This field is required!'**
  String get errField;

  /// No description provided for @errFieldIsIncorrect.
  ///
  /// In en, this message translates to:
  /// **'is incorrect'**
  String get errFieldIsIncorrect;

  /// No description provided for @errFieldShouldBeLess.
  ///
  /// In en, this message translates to:
  /// **'is incorrect, should be less than'**
  String get errFieldShouldBeLess;

  /// No description provided for @errFieldShouldBeGreater.
  ///
  /// In en, this message translates to:
  /// **'is in correct, should be greater than'**
  String get errFieldShouldBeGreater;

  /// No description provided for @errFieldShouldBeBetween.
  ///
  /// In en, this message translates to:
  /// **'is in correct, should be between'**
  String get errFieldShouldBeBetween;

  /// No description provided for @pick.
  ///
  /// In en, this message translates to:
  /// **'Pick'**
  String get pick;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @ip.
  ///
  /// In en, this message translates to:
  /// **'IP'**
  String get ip;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @available_servers.
  ///
  /// In en, this message translates to:
  /// **'Available Servers'**
  String get available_servers;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @totalPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Total per month'**
  String get totalPerMonth;

  /// No description provided for @cantOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Can not open file for some reason  !'**
  String get cantOpenFile;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @isAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'is added to cart'**
  String get isAddedToCart;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No items!'**
  String get noItems;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @setNullable.
  ///
  /// In en, this message translates to:
  /// **'Set nullable'**
  String get setNullable;

  /// No description provided for @addNewSubObject.
  ///
  /// In en, this message translates to:
  /// **'Add new sub object'**
  String get addNewSubObject;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @errValidation.
  ///
  /// In en, this message translates to:
  /// **'There is an error in one or more fields.'**
  String get errValidation;

  /// No description provided for @successUpdated.
  ///
  /// In en, this message translates to:
  /// **'Successfully updated!'**
  String get successUpdated;

  /// No description provided for @printUsingServer.
  ///
  /// In en, this message translates to:
  /// **'Print using local server'**
  String get printUsingServer;

  /// No description provided for @printQuickUsingServer.
  ///
  /// In en, this message translates to:
  /// **'Print quickly without using the print options dialog (using the last saved setting)'**
  String get printQuickUsingServer;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to '**
  String get areYouSure;

  /// No description provided for @enable_server.
  ///
  /// In en, this message translates to:
  /// **'Enable all users to use SaffouryPaper app (If you disable it only managers will continue using app)'**
  String get enable_server;

  /// No description provided for @disable_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notification will not send to your users any more!'**
  String get disable_notifications;

  /// No description provided for @set_exchange_rate_message.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number.'**
  String get set_exchange_rate_message;

  /// No description provided for @errBarcode.
  ///
  /// In en, this message translates to:
  /// **'Error getting barcode value!'**
  String get errBarcode;

  /// No description provided for @printAfterAdd.
  ///
  /// In en, this message translates to:
  /// **'Print after successfully added'**
  String get printAfterAdd;

  /// No description provided for @addNewAfterAdd.
  ///
  /// In en, this message translates to:
  /// **'Add another new record after successfully added'**
  String get addNewAfterAdd;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @allChangesWillDiscard.
  ///
  /// In en, this message translates to:
  /// **'You will lose all changes you have made to it'**
  String get allChangesWillDiscard;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @customDate.
  ///
  /// In en, this message translates to:
  /// **'Custom date'**
  String get customDate;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @cantLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Can not load image!'**
  String get cantLoadImage;

  /// No description provided for @iD.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get iD;

  /// No description provided for @ad_app_id.
  ///
  /// In en, this message translates to:
  /// **'ca-app-pub-4658218924549085~6259254114'**
  String get ad_app_id;

  /// No description provided for @continuousScan.
  ///
  /// In en, this message translates to:
  /// **'Continuous Scan'**
  String get continuousScan;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get chooseFile;

  /// No description provided for @defaultOnClickAction.
  ///
  /// In en, this message translates to:
  /// **'Default action when click on list item'**
  String get defaultOnClickAction;

  /// No description provided for @expandCard.
  ///
  /// In en, this message translates to:
  /// **'Expand/Collapse card'**
  String get expandCard;

  /// No description provided for @showAsDialog.
  ///
  /// In en, this message translates to:
  /// **'Show as dialog'**
  String get showAsDialog;

  /// No description provided for @showAsActivity.
  ///
  /// In en, this message translates to:
  /// **'Show as activty'**
  String get showAsActivity;

  /// No description provided for @defaultOnSwipeListItemAction.
  ///
  /// In en, this message translates to:
  /// **'Default action when swipe on a list item'**
  String get defaultOnSwipeListItemAction;

  /// No description provided for @defaultOnSwipeListItemActionRight.
  ///
  /// In en, this message translates to:
  /// **'Default action when swipe on a list item (Right)'**
  String get defaultOnSwipeListItemActionRight;

  /// No description provided for @defaultOnSwipeListItemActionLeft.
  ///
  /// In en, this message translates to:
  /// **'Default action when swipe on a list item (Left)'**
  String get defaultOnSwipeListItemActionLeft;

  /// No description provided for @defaultStartupPage.
  ///
  /// In en, this message translates to:
  /// **'Default startup page'**
  String get defaultStartupPage;

  /// No description provided for @defaultConfirmationAction.
  ///
  /// In en, this message translates to:
  /// **'Default confirmation action'**
  String get defaultConfirmationAction;

  /// No description provided for @defaultOnScanAction.
  ///
  /// In en, this message translates to:
  /// **'Default action when scan barcode completed'**
  String get defaultOnScanAction;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @pressBackAgain.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgain;

  /// No description provided for @sendAndExit.
  ///
  /// In en, this message translates to:
  /// **'Send and exit'**
  String get sendAndExit;

  /// No description provided for @shareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareLabel;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @notSupportArabicLanguageForNow.
  ///
  /// In en, this message translates to:
  /// **'Not supported arabic language for now'**
  String get notSupportArabicLanguageForNow;

  /// No description provided for @quickPrint.
  ///
  /// In en, this message translates to:
  /// **'Quick print'**
  String get quickPrint;

  /// No description provided for @errSetSavedPrintOption.
  ///
  /// In en, this message translates to:
  /// **'Error, You have to save at least one print option to use quick printing'**
  String get errSetSavedPrintOption;

  /// No description provided for @errQuickPrinting.
  ///
  /// In en, this message translates to:
  /// **'Quick printing failed for some reason'**
  String get errQuickPrinting;

  /// No description provided for @errSelectServerToSave.
  ///
  /// In en, this message translates to:
  /// **'Error, Connect to at least one server to be able to save'**
  String get errSelectServerToSave;

  /// No description provided for @shareURLLabel.
  ///
  /// In en, this message translates to:
  /// **'Share URL'**
  String get shareURLLabel;

  /// No description provided for @permissionName.
  ///
  /// In en, this message translates to:
  /// **'Permission name'**
  String get permissionName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @my_cart.
  ///
  /// In en, this message translates to:
  /// **'My cart'**
  String get my_cart;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get learnMore;

  /// No description provided for @sortAndFilter.
  ///
  /// In en, this message translates to:
  /// **'Sort and filter'**
  String get sortAndFilter;

  /// No description provided for @loadAll.
  ///
  /// In en, this message translates to:
  /// **'Load all'**
  String get loadAll;

  /// No description provided for @selectItems.
  ///
  /// In en, this message translates to:
  /// **'Select item(s)'**
  String get selectItems;

  /// No description provided for @selectMultibleItemsFrom.
  ///
  /// In en, this message translates to:
  /// **'Select multiple items from'**
  String get selectMultibleItemsFrom;

  /// No description provided for @ascSorting.
  ///
  /// In en, this message translates to:
  /// **'Ascending sort'**
  String get ascSorting;

  /// No description provided for @descSorting.
  ///
  /// In en, this message translates to:
  /// **'Descending sort'**
  String get descSorting;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @bestMatsh.
  ///
  /// In en, this message translates to:
  /// **'Scan result'**
  String get bestMatsh;

  /// No description provided for @startAddingToCartHint.
  ///
  /// In en, this message translates to:
  /// **'Hint:\\nStart adding to cart, by swiping the product item to the left'**
  String get startAddingToCartHint;

  /// No description provided for @unknowError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknowError;

  /// No description provided for @errCantBeNull.
  ///
  /// In en, this message translates to:
  /// **'Error, this field can not be null'**
  String get errCantBeNull;

  /// No description provided for @errorFounded.
  ///
  /// In en, this message translates to:
  /// **'Error founded!'**
  String get errorFounded;

  /// No description provided for @chooseAction.
  ///
  /// In en, this message translates to:
  /// **'Choose action'**
  String get chooseAction;

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention!'**
  String get attention;

  /// No description provided for @no_summary.
  ///
  /// In en, this message translates to:
  /// **'No summary!'**
  String get no_summary;

  /// No description provided for @countinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get countinue;

  /// No description provided for @youHave.
  ///
  /// In en, this message translates to:
  /// **'You have'**
  String get youHave;

  /// No description provided for @unUsed.
  ///
  /// In en, this message translates to:
  /// **'Unused'**
  String get unUsed;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recently'**
  String get recent;

  /// No description provided for @turnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get turnOn;

  /// No description provided for @cameraAccess.
  ///
  /// In en, this message translates to:
  /// **'Camera access is denied'**
  String get cameraAccess;

  /// No description provided for @denied_camera_permssion.
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Please allow access to your camera to start scanning'**
  String get denied_camera_permssion;

  /// No description provided for @enteryInterval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get enteryInterval;

  /// No description provided for @dateEnteryInterval.
  ///
  /// In en, this message translates to:
  /// **'Select dateThis yearThis monthCustom'**
  String get dateEnteryInterval;

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'مرحبًا {r}.\\nأردنا فقط أن نعرف أننا نستمتع حقًا بالعمل معك ، قم بتنزيل SaffouryPaper الآن على {r}\\nاسم المستخدم:{r}\\nكلمة المرور:{r}\\nرصيدك الحالي:{r}\\n'**
  String get welcome_message;

  /// No description provided for @welcome_message_employees.
  ///
  /// In en, this message translates to:
  /// **'مرحبًا {r}.\\nأردنا فقط أن نعرف أننا نستمتع حقًا بالعمل معك ، قم بتنزيل SaffouryPaper الآن على {r}\\nاسم المستخدم:{r}\\nكلمة المرور:{r}\\n'**
  String get welcome_message_employees;

  /// No description provided for @dollar_format.
  ///
  /// In en, this message translates to:
  /// **'{r} \$'**
  String get dollar_format;

  /// No description provided for @syp_format.
  ///
  /// In en, this message translates to:
  /// **'{r} SYP'**
  String get syp_format;

  /// No description provided for @product_size_f.
  ///
  /// In en, this message translates to:
  /// **'Size: {r} ✗ {r}'**
  String get product_size_f;

  /// No description provided for @product_size_roll_f.
  ///
  /// In en, this message translates to:
  /// **'Width: {r}'**
  String get product_size_roll_f;

  /// No description provided for @product_size_roll_f_string.
  ///
  /// In en, this message translates to:
  /// **'Width: {r}'**
  String get product_size_roll_f_string;

  /// No description provided for @product_notes_format.
  ///
  /// In en, this message translates to:
  /// **'Notes:\\n•{r}'**
  String get product_notes_format;

  /// Greet the user by their name.
  ///
  /// In en, this message translates to:
  /// **'({r}) is not selected!'**
  String errFieldNotSelected(String r);

  /// No description provided for @price_dollar.
  ///
  /// In en, this message translates to:
  /// **'Price: {r} \$'**
  String get price_dollar;

  /// No description provided for @last_payment_format_with_d.
  ///
  /// In en, this message translates to:
  /// **'Last Credit: {r} • {r}'**
  String get last_payment_format_with_d;

  /// No description provided for @last_spend_format.
  ///
  /// In en, this message translates to:
  /// **'Last expense: {r} • {r}'**
  String get last_spend_format;

  /// No description provided for @balanceFormat.
  ///
  /// In en, this message translates to:
  /// **'Balance: {r}'**
  String get balanceFormat;

  /// No description provided for @level_f.
  ///
  /// In en, this message translates to:
  /// **'Level: {r}'**
  String get level_f;

  /// No description provided for @last_payment_with_date.
  ///
  /// In en, this message translates to:
  /// **'{r} on {r}'**
  String get last_payment_with_date;

  /// No description provided for @kg_format.
  ///
  /// In en, this message translates to:
  /// **'{r} (KG)'**
  String get kg_format;

  /// No description provided for @date_format_and_by.
  ///
  /// In en, this message translates to:
  /// **'Date: {r} • {r}'**
  String get date_format_and_by;

  /// No description provided for @order_format.
  ///
  /// In en, this message translates to:
  /// **'Orders: {r}'**
  String get order_format;

  /// No description provided for @wastSize_f.
  ///
  /// In en, this message translates to:
  /// **'Waste size: {r} ✗ {r}'**
  String get wastSize_f;

  /// No description provided for @wastSizeFlip_f.
  ///
  /// In en, this message translates to:
  /// **'Waste size: {r} ✗ {r}'**
  String get wastSizeFlip_f;

  /// No description provided for @size_roll_res.
  ///
  /// In en, this message translates to:
  /// **'Cut the roller on {r} ≈ {r} (Sheets)'**
  String get size_roll_res;

  /// No description provided for @size_roll_res_with_width.
  ///
  /// In en, this message translates to:
  /// **'Cut the roller on {r} then {r} '**
  String get size_roll_res_with_width;

  /// No description provided for @wastSize_f2.
  ///
  /// In en, this message translates to:
  /// **'Waste size: {r} ✗ {r} • {r} ✗ {r}'**
  String get wastSize_f2;

  /// No description provided for @wastSizeFlip_f2.
  ///
  /// In en, this message translates to:
  /// **'Waste size: {r} ✗ {r} • {r} ✗ {r}'**
  String get wastSizeFlip_f2;

  /// No description provided for @size_res_f.
  ///
  /// In en, this message translates to:
  /// **'{r} {r} (KG) • {r} '**
  String get size_res_f;

  /// No description provided for @requestedSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Requested sizes'**
  String get requestedSizeLabel;

  /// No description provided for @size_res_f_without_dollar.
  ///
  /// In en, this message translates to:
  /// **'{r} {r} (KG) {r}'**
  String get size_res_f_without_dollar;

  /// No description provided for @size_res_flip_f.
  ///
  /// In en, this message translates to:
  /// **'{r} {r} (KG) • {r} '**
  String get size_res_flip_f;

  /// No description provided for @maxWaste.
  ///
  /// In en, this message translates to:
  /// **'Max possible waste'**
  String get maxWaste;

  /// No description provided for @tow_strings.
  ///
  /// In en, this message translates to:
  /// **'{r} {r}'**
  String get tow_strings;

  /// No description provided for @addToFormat.
  ///
  /// In en, this message translates to:
  /// **'Add to {r}'**
  String get addToFormat;

  /// No description provided for @toFormat.
  ///
  /// In en, this message translates to:
  /// **'to {r}'**
  String get toFormat;

  /// No description provided for @addFormat.
  ///
  /// In en, this message translates to:
  /// **'Add {r}'**
  String get addFormat;

  /// No description provided for @sheets_string_f.
  ///
  /// In en, this message translates to:
  /// **'{r} Sheet(s)'**
  String get sheets_string_f;

  /// No description provided for @dollar_and_syp_format.
  ///
  /// In en, this message translates to:
  /// **'{r} \$ • {r} SYP'**
  String get dollar_and_syp_format;

  /// No description provided for @dollar_and_kg_format.
  ///
  /// In en, this message translates to:
  /// **'{r} \$ • {r} KG'**
  String get dollar_and_kg_format;

  /// No description provided for @tryToSearchBySizeAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'Click here, To search for ({r}) by size analyzer'**
  String get tryToSearchBySizeAnalyzer;

  /// No description provided for @not_payed_format.
  ///
  /// In en, this message translates to:
  /// **'You have {r} customers who have not paid for a long time, with {r} overdue bill(s)'**
  String get not_payed_format;

  /// No description provided for @sellDollar_format.
  ///
  /// In en, this message translates to:
  /// **'شراء {r} طبق لاصق بسعر {r}'**
  String get sellDollar_format;

  /// No description provided for @rowCountFormat.
  ///
  /// In en, this message translates to:
  /// **'{r} row(s) was'**
  String get rowCountFormat;

  /// No description provided for @errCantEditFormatFromTo.
  ///
  /// In en, this message translates to:
  /// **'Can not edit {r} because it\\\'s generated from {r}'**
  String get errCantEditFormatFromTo;

  /// No description provided for @searchInFormat.
  ///
  /// In en, this message translates to:
  /// **'Search in {r}…'**
  String get searchInFormat;

  /// No description provided for @errSomeOperationField.
  ///
  /// In en, this message translates to:
  /// **'Some items fields to {r}, for some reason !'**
  String get errSomeOperationField;

  /// No description provided for @errCantListBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Error, {r} list is empty or contains one or more wrong items'**
  String get errCantListBeEmpty;

  /// No description provided for @chooseActionYouLike.
  ///
  /// In en, this message translates to:
  /// **'Choose the action you would like to do for \\n{r}\\nTo complete the operation'**
  String get chooseActionYouLike;

  /// No description provided for @app_fo.
  ///
  /// In en, this message translates to:
  /// **'≈ {r}'**
  String get app_fo;

  /// No description provided for @clickToFormat.
  ///
  /// In en, this message translates to:
  /// **'Click to {r}'**
  String get clickToFormat;

  /// No description provided for @noti_message_1_F.
  ///
  /// In en, this message translates to:
  /// **'I look forward to receiving your payment this week, knowing that your last payment was: {r} The remaining balance is {r}'**
  String get noti_message_1_F;

  /// No description provided for @noti_message_2_F.
  ///
  /// In en, this message translates to:
  /// **'Thank you in advance for your prompt payment, i want to let you know that your last payment was: {r}\\nThe remaining balance is {r}'**
  String get noti_message_2_F;

  /// No description provided for @noti_message_3_F.
  ///
  /// In en, this message translates to:
  /// **'This is a friendly reminder that your invoice [#] payment is due to be paid next week, knowing that your last payment was: {r}\\nThe remaining balance is {r}'**
  String get noti_message_3_F;

  /// No description provided for @noti_message_4_F.
  ///
  /// In en, this message translates to:
  /// **'Please let me know if you have any questions about the invoice or if there’s anything I can do for you, knowing that your last payment was: {r}\\n\nThe remaining balance is {r}'**
  String get noti_message_4_F;

  /// No description provided for @top.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get top;

  /// No description provided for @middle.
  ///
  /// In en, this message translates to:
  /// **'Middle'**
  String get middle;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Check out'**
  String get checkout;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @subTotal.
  ///
  /// In en, this message translates to:
  /// **'Sub total'**
  String get subTotal;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand total'**
  String get grandTotal;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @hideAccountPhone.
  ///
  /// In en, this message translates to:
  /// **'Hide account phone'**
  String get hideAccountPhone;

  /// No description provided for @hideAccountAdress.
  ///
  /// In en, this message translates to:
  /// **'Hide account address'**
  String get hideAccountAdress;

  /// No description provided for @hideCompanyTerms.
  ///
  /// In en, this message translates to:
  /// **'Hide company terms'**
  String get hideCompanyTerms;

  /// No description provided for @hideCompanyNotes.
  ///
  /// In en, this message translates to:
  /// **'Hide company notes'**
  String get hideCompanyNotes;

  /// No description provided for @hideDate.
  ///
  /// In en, this message translates to:
  /// **'Hide date'**
  String get hideDate;

  /// No description provided for @hidePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Hide payment method'**
  String get hidePaymentMethod;

  /// No description provided for @hideDueDate.
  ///
  /// In en, this message translates to:
  /// **'Hide due date'**
  String get hideDueDate;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
