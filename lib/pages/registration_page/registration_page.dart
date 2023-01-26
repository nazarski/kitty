import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/user_bloc/user_bloc.dart';
import 'package:kitty/pages/main_page.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/services/local_auth_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  static const routeName = '/registration_page';

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state.status == AuthStatus.done) {
          Navigator.of(context, rootNavigator: true)
              .pushNamedAndRemoveUntil(MainPage.routeName, (route) => false);
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
                    Icon(Icons.app_registration_outlined,
                        color: AppColors.title),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Sign Up',
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
                    const SizedBox(
                      width: 8,
                    ),
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
                  height: 16,
                ),
                if (state.status == AuthStatus.loading) ...[
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.activeBlue,
                    ),
                  )
                ] else ...[
                  ElevatedButton(
                      style: AppStyles.buttonStyle,
                      onPressed: () async {
                        screenLockCreate(
                          title: const Text('Please, create pin code'),
                          confirmTitle: const Text('Please, confirm pin code'),
                          context: context,
                          onConfirmed: (value) async {
                            if (await LocalAuth.canAuthenticate()) {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BiometricsDialog(
                                      name:
                                          '${nameController.text} ${surnameController.text}',
                                      email: emailController.text,
                                      pin: value,
                                    );
                                  });
                            } else {
                              Navigator.of(context).pop();
                              context.read<UserBloc>().add(CreateUserEvent(
                                  name:
                                      '${nameController.text} ${surnameController.text}',
                                  pin: value,
                                  email: emailController.text,
                                  biometrics: false));
                            }
                          },
                        );
                      },
                      child: const Center(child: Text('Sign Up')))
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

class BiometricsDialog extends StatelessWidget {
  const BiometricsDialog({
    Key? key,
    required this.name,
    required this.email,
    required this.pin,
  }) : super(key: key);

  final String name;
  final String email;
  final String pin;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(
        child: Text(
          'Use biometrics?',
          style: AppStyles.menuPageTitle,
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Would you like to use fingerprint or '
          'FaceId to sign in?',
          style: AppStyles.body2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.fingerprint_outlined,
              color: AppColors.subTitle,
              size: 48,
            ),
            SvgPicture.asset(
              AppIcons.faceId,
              color: AppColors.subTitle,
              height: 48,
              width: 48,
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<UserBloc>().add(CreateUserEvent(
                  name: name, pin: pin, email: email, biometrics: true));
            },
            child: const Text(
              'Yes, sure',
              style: AppStyles.button,
            )),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<UserBloc>().add(CreateUserEvent(
                  name: name, pin: pin, email: email, biometrics: false));
            },
            child: const Text(
              "No, I'll use pin",
              style: AppStyles.buttonBlack,
            ))
      ],
    );
  }
}
