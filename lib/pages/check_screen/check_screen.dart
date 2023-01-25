import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/pages/home_page/home_page.dart';
import 'package:kitty/pages/login_page/login_page.dart';
import 'package:kitty/pages/main_page.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context, rootNavigator: true)
          .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Kitty',
              style: TextStyle(
                  color: AppColors.title,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
