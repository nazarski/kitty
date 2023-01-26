import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/pages/registration_page/registration_page.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
static const routeName = '/login_page';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  SvgPicture.asset(AppIcons.logo),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Kitty',
                    style: AppStyles.menuPageTitle,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Wrap(
              children: [
                Icon(Icons.login, color:AppColors.title),
                SizedBox(width: 8,),
                const Text(
                  'Sign In',
                  style: TextStyle(color: AppColors.title, fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Your e-mail',
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Your password',
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RegistrationPage.routeName);
                },
                child: const Text('Sign Up', style: AppStyles.button),),
            ElevatedButton(
              style: AppStyles.buttonStyle,
                onPressed: (){
                },
                child: Center(child: Text('Log In')))
          ],
        ),
      ),
    );
  }
}
