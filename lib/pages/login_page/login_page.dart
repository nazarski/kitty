import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/user_bloc/user_bloc.dart';
import 'package:kitty/models/user_model/user.dart';
import 'package:kitty/pages/main_page.dart';
import 'package:kitty/pages/registration_page/registration_page.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/services/local_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state.userId.isEmpty && state.user.email.isNotEmpty) {
          emailController.text = state.user.email;
          _auth(state.user);
        }
      },
      builder: (context, state) {
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
                    Icon(Icons.login, color: AppColors.title),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Sign In',
                      style: TextStyle(
                          color: AppColors.title,
                          fontSize: 18,
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
                if (state.status == AuthStatus.error) ...[
                  Text(
                    state.errorMessage,
                    style: AppStyles.appRed,
                  )
                ],
                if (state.status == AuthStatus.loading) ...[
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.activeBlue,
                    ),
                  )
                ] else ...[
                  TextButton(
                    onPressed: () {
                      context.read<UserBloc>().add(InitialUserEvent());
                      Navigator.of(context)
                          .pushNamed(RegistrationPage.routeName);
                    },
                    child: const Text('Sign Up', style: AppStyles.button),
                  ),
                  ElevatedButton(
                      style: AppStyles.buttonStyle,
                      onPressed: () {
                        context
                            .read<UserBloc>()
                            .add(SignInEvent(emailController.text));
                      },
                      child: const Center(child: Text('Sign In')))
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _auth(User user) async {
    if (user.biometrics) {
      final ifAuth = await LocalAuth.authenticate();
      if (ifAuth && mounted) {
        context.read<UserBloc>().add(SuccessfullySignedIn());
        Navigator.of(context, rootNavigator: true)
            .pushNamedAndRemoveUntil(MainPage.routeName, (route) => false);
      }else{
        context.read<UserBloc>().add(InitialUserEvent());
      }
    } else {
      screenLock(
          context: context,
          correctString: user.pin,
          onCancelled: (){
            context.read<UserBloc>().add(InitialUserEvent());
          },
          onUnlocked: () {
            Navigator.of(context).pop();
            context.read<UserBloc>().add(SuccessfullySignedIn());
            Navigator.of(context, rootNavigator: true)
                .pushNamedAndRemoveUntil(MainPage.routeName, (route) => false);
          });
    }
  }
}
