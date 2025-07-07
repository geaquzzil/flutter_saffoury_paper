import 'package:flutter/material.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/new_screens/actions/edit_new/base_edit_new.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/web_button.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../constants.dart';

class SignInPageWithoutHeaders extends StatelessWidget {
  final ValueNotifier<ViewAbstract?> _loginState =
      ValueNotifier<ViewAbstract?>(null);
  AuthUserLogin user = AuthUserLogin();
  void Function()? onPressRegister;
  void Function(ViewAbstract? viewAbstract)? onPressLogin;
  SignInPageWithoutHeaders(
      {super.key, this.onPressRegister, this.onPressLogin});

  @override
  Widget build(BuildContext context) {
    debugPrint("SignInPageWithoutHeaders ${double.infinity}");
    return body(double.infinity, context);
  }

  Widget header(double width, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.signInWithYourAccount,
          style: const TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: CompanyLogo(
            size: 100,
          ),
        )
      ],
    );
  }

  Widget body(double width, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    flex: 0,
                    child: header(width, context),
                  ),
                  Expanded(
                      flex: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BaseEditWidget(
                            viewAbstract: user,
                            isTheFirst: true,
                            requireOnValidateEvenIfNull: true,
                            onValidate: (viewAbstract) {
                              _loginState.value = viewAbstract;
                            },
                          ),
                          Selector<AuthProvider<AuthUser>, Status>(
                            builder: (context, value, child) {
                              Widget child;
                              TextStyle? style = Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: value == Status.Authenticated
                                          ? Colors.green
                                          : Theme.of(context)
                                              .colorScheme
                                              .error);
                              if (value == Status.Blocked) {
                                child = Text(
                                  AppLocalizations.of(context)!.errLogin,
                                  style: style,
                                );
                              } else if (value == Status.Authenticated) {
                                child = Text(
                                  AppLocalizations.of(context)!.log_in,
                                  style: style,
                                );
                              } else if (value == Status.Authenticating) {
                                child = const LinearProgressIndicator();
                              } else if (value == Status.Unauthenticated) {
                                child = Text(
                                  AppLocalizations.of(context)!
                                      .error_incorrect_password,
                                  style: style,
                                );
                              } else {
                                child = const SizedBox();
                              }
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: child,
                              );
                            },
                            selector: (p0, p1) => p1.getStatus,
                          ),
                          ValueListenableBuilder<ViewAbstract?>(
                            valueListenable: _loginState,
                            builder: (context, value, child) => WebButton(
                              width: double.infinity,
                              title: AppLocalizations.of(context)!
                                  .log_in
                                  .toUpperCase(),
                              onPressed: value != null
                                  ? () {
                                      debugPrint(
                                          "AuthProvider  ds auth user =>phone: ${(value as AuthUserLogin?)?.phone} password: ${(value as AuthUserLogin?)?.password}");
                                      AuthUser auth = AuthUser();
                                      auth.password =
                                          (value as AuthUserLogin).password;
                                      auth.phone = value.phone;
                                      onPressLogin?.call(auth);
                                    }
                                  : null,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.dontHaveAccount,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.youCan,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(width: 15),
                              TextButton(
                                onPressed: () {
                                  onPressRegister?.call();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.regestierHere,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInPage extends BaseWebPage {
  final ValueNotifier<ViewAbstract?> _loginState =
      ValueNotifier<ViewAbstract?>(null);
  AuthUserLogin user = AuthUserLogin();
  SignInPage({super.key});

  @override
  Widget getContentWidget(BuildContext context) {
    return ScreenHelper(
      largeTablet: body(kDesktopMaxWidth, context),
      smallTablet: body(kTabletMaxWidth, context),
      mobile: body(getMobileMaxWidth(context), context),
    );
  }

  Widget header(double width, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.signInWithYourAccount,
          style: const TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          AppLocalizations.of(context)!.youDontHavePermission,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.youCan,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () {
                debugPrint("${MediaQuery.of(context).size.width}");
              },
              child: Text(
                AppLocalizations.of(context)!.regestierHere,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: CompanyLogo(
            size: 100,
          ),
        )
      ],
    );
  }

  Widget body(double width, BuildContext context) {
    return Center(
      child: MaxWidthBox(
        // shrinkWrap: true,
        maxWidth: width,
        // minWidth: width,
        // defaultScale: false,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Wrap(
                      spacing: 20.0,
                      runSpacing: 20.0,
                      children: [
                        SizedBox(
                          width: isMobile(context)
                              ? constraints.maxWidth - 20.0
                              : constraints.maxWidth / 2 - 20.0,
                          height: MediaQuery.of(context).size.height - 100,
                          child: header(width, context),
                        ),
                        SizedBox(
                          width: isMobile(context)
                              ? constraints.maxWidth - 20.0
                              : constraints.maxWidth / 2 - 20.0,
                          height: MediaQuery.of(context).size.height - 100,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height / 6),
                            child: Column(
                              children: [
                                BaseEditWidget(
                                  viewAbstract: user,
                                  isTheFirst: true,
                                  requireOnValidateEvenIfNull: true,
                                  onValidate: (viewAbstract) {
                                    _loginState.value = viewAbstract;
                                  },
                                ),
                                Selector<AuthProvider<AuthUser>, Status>(
                                  builder: (context, value, child) {
                                    Widget child;
                                    TextStyle? style = Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: value == Status.Authenticated
                                                ? Colors.green
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .error);
                                    if (value == Status.Blocked) {
                                      child = Text(
                                        AppLocalizations.of(context)!.errLogin,
                                        style: style,
                                      );
                                    } else if (value == Status.Authenticated) {
                                      child = Text(
                                        AppLocalizations.of(context)!.log_in,
                                        style: style,
                                      );
                                    } else if (value == Status.Authenticating) {
                                      child = const LinearProgressIndicator();
                                    } else if (value ==
                                        Status.Unauthenticated) {
                                      child = Text(
                                        AppLocalizations.of(context)!
                                            .error_incorrect_password,
                                        style: style,
                                      );
                                    } else {
                                      child = const SizedBox();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: child,
                                    );
                                  },
                                  selector: (p0, p1) => p1.getStatus,
                                ),
                                ValueListenableBuilder<ViewAbstract?>(
                                  valueListenable: _loginState,
                                  builder: (context, value, child) => WebButton(
                                    width: double.infinity,
                                    title: "SIGN IN",
                                    onPressed: value != null
                                        ? () {
                                            debugPrint(
                                                "AuthProvider  ds auth user =>phone: ${(value as AuthUserLogin?)?.phone} password: ${(value as AuthUserLogin?)?.password}");
                                            AuthUser auth = AuthUser();
                                            auth.password =
                                                (value as AuthUserLogin)
                                                    .password;
                                            auth.phone = value.phone;
                                            context
                                                .read<AuthProvider<AuthUser>>()
                                                .signIn(
                                                    context: context,
                                                    onResponeCallback:
                                                        OnResponseCallback(
                                                      onBlocked: () {},
                                                      onEmailOrPassword: () {},
                                                    ),
                                                    user: auth);
                                          }
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Row(children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey[300],
                                      height: 50,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Text("Or continue with"),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey[400],
                                      height: 50,
                                    ),
                                  ),
                                ]),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _loginWithButton(context,
                                        image: Icons.g_mobiledata),
                                    _loginWithButton(context,
                                        image: Icons.g_mobiledata_rounded,
                                        isActive: true),
                                    _loginWithButton(context,
                                        image: Icons.facebook),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formLogin(double width, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 6),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              //Enter username or email
              hintText: AppLocalizations.of(context)!.user_name,
              filled: true,

              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.password,
              counterText: AppLocalizations.of(context)!.forget_get_account,
              suffixIcon: const Icon(
                Icons.visibility_off_outlined,
              ),
              filled: true,
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // WebButton(
          //   title: "Sign in",
          //   onPressed: () {
          //     context.read<AuthProvider<AuthUser>>().signIn();
          //   },
          // ),
          const SizedBox(height: 40),
          Row(children: [
            Expanded(
              child: Divider(
                color: Colors.grey[300],
                height: 50,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Or continue with"),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey[400],
                height: 50,
              ),
            ),
          ]),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _loginWithButton(context, image: Icons.g_mobiledata),
              _loginWithButton(context,
                  image: Icons.g_mobiledata_rounded, isActive: true),
              _loginWithButton(context, image: Icons.facebook),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loginWithButton(BuildContext context,
      {required IconData image, bool isActive = false}) {
    return IconButton(iconSize: 50, onPressed: () {}, icon: Icon(image));
    return Container(
      width: 90,
      height: 70,
      decoration: isActive
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  spreadRadius: 10,
                  blurRadius: 30,
                )
              ],
              borderRadius: BorderRadius.circular(15),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[400]!),
            ),
      child: Center(
          child: Container(
              decoration: isActive
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400]!,
                          spreadRadius: 2,
                          blurRadius: 15,
                        )
                      ],
                    )
                  : const BoxDecoration(),
              child: Icon(image))),
    );
  }
}
