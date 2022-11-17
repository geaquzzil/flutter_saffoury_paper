import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../constants.dart';

class SignInPage extends BaseWebPage {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget getContentWidget(BuildContext context) {
    return ScreenHelper(
      desktop: body(kDesktopMaxWidth, context),
      tablet: body(kTabletMaxWidth, context),
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
          "If you don't have an account",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              "You can",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () {
                debugPrint("${MediaQuery.of(context).size.width}");
              },
              child: Text(
                "Register here!",
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ],
        ),
        const FlutterLogo(
          size: 300,
        )
      ],
    );
  }

  Widget body(double width, BuildContext context) {
    return Center(
      child: ResponsiveWrapper(
        shrinkWrap: true,
        maxWidth: width,
        minWidth: width,
        defaultScale: false,
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
                          width: ScreenHelper.isMobile(context)
                              ? constraints.maxWidth - 20.0
                              : constraints.maxWidth / 2 - 20.0,
                          height: MediaQuery.of(context).size.height - 100,
                          child: header(width, context),
                        ),
                        SizedBox(
                          width: ScreenHelper.isMobile(context)
                              ? constraints.maxWidth - 20.0
                              : constraints.maxWidth / 2 - 20.0,
                          height: MediaQuery.of(context).size.height - 100,
                          child: _formLogin(width, context),
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary,
                  spreadRadius: 10,
                  blurRadius: 20,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => debugPrint("it's pressed"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.shadow,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                      child: Text(
                          AppLocalizations.of(context)!.action_sign_in_short))),
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
