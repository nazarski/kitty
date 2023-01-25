import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  static const routeName = '/registration_page';
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

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
              children: const [
                Icon(Icons.app_registration_outlined, color:AppColors.title),
                SizedBox(width: 8,),
                Text(
                  'Register',
                  style: TextStyle(color: AppColors.title, fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Your name',
                    ),
                  ),
                ),
                const SizedBox(width: 8,),
                Expanded(
                  flex: 1,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: surnameController,
                    decoration: const InputDecoration(
                      labelText: 'Your surname',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
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
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                style: AppStyles.buttonStyle,
                onPressed: (){},
                child: const Center(child: Text('Register')))
          ],
        ),
      ),
    );
  }
}
