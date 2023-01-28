import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/user_bloc/user_bloc.dart';
import 'package:kitty/generated/locale_keys.g.dart';
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
                  children: [
                    const Icon(Icons.app_registration_outlined,
                        color: AppColors.title),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      LocaleKeys.registration_singup.tr(),
                      style: const TextStyle(
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
                        decoration: InputDecoration(
                          labelText: LocaleKeys.registration_name.tr(),
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
                        decoration: InputDecoration(
                          labelText: LocaleKeys.registration_surname.tr(),
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
                  decoration: InputDecoration(
                    labelText: LocaleKeys.registration_e_mail.tr(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                if (state.status == AuthStatus.error) ...[
                  Text(state.errorMessage, style: AppStyles.appRed)
                ],
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
                      await buildScreenLockCreate(context);
                    },
                    child: Center(
                      child: Text(LocaleKeys.registration_singup.tr()),
                    ),
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  buildScreenLockCreate(BuildContext context) async {
    screenLockCreate(
      title: Text(LocaleKeys.registration_create_pin.tr()),
      confirmTitle: Text(LocaleKeys.registration_confirm_pin.tr()),
      context: context,
      onConfirmed: (value) async {
        if (await LocalAuth.canAuthenticate()) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (context) {
                return BiometricsDialog(
                  name: '${nameController.text} ${surnameController.text}',
                  email: emailController.text,
                  pin: value,
                );
              });
        } else {
          Navigator.of(context).pop();
          context.read<UserBloc>().add(CreateUserEvent(
              name: '${nameController.text} ${surnameController.text}',
              pin: value,
              email: emailController.text,
              biometrics: false));
        }
      },
    );
  }
}

class BiometricsDialog extends StatefulWidget {
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
  State<BiometricsDialog> createState() => _BiometricsDialogState();
}

class _BiometricsDialogState extends State<BiometricsDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text(
          LocaleKeys.registration_use_biometrics.tr(),
          style: AppStyles.menuPageTitle,
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
      children: [
         Text(
          LocaleKeys.registration_choose_biometrics.tr(),
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
            onPressed: () async {
              final ifAuth = await LocalAuth.authenticate();
              if (ifAuth && mounted) {
                Navigator.of(context).pop();
                context.read<UserBloc>().add(CreateUserEvent(
                    name: widget.name,
                    pin: widget.pin,
                    email: widget.email,
                    biometrics: true));
              }
            },
            child: Text(
              LocaleKeys.registration_yes.tr(),
              style: AppStyles.button,
            )),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<UserBloc>().add(CreateUserEvent(
                  name: widget.name,
                  pin: widget.pin,
                  email: widget.email,
                  biometrics: false));
            },
            child: Text(
              LocaleKeys.registration_no.tr(),
              style: AppStyles.buttonBlack,
            ))
      ],
    );
  }
}
