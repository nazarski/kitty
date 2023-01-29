import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/bloc/user_bloc/user_bloc.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/pages/faq_page/faq_page.dart';
import 'package:kitty/pages/login_page/login_page.dart';
import 'package:kitty/pages/manage_categories_page/manage_categories_page.dart';
import 'package:kitty/pages/statistics_page/statistics_page.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/settings_page/settings_option.dart';
import 'package:kitty/widgets/settings_page/user_info.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const routeName = '/settings_page';

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.status == AuthStatus.signedOut) {
          Navigator.of(context, rootNavigator: true)
              .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const UserInfo(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SettingOption(
                        icon: Icons.category_outlined,
                        title: LocaleKeys.manage_cat.tr(),
                        action: () {
                          context.read<NavigationBloc>().add(NavigateTab(
                              tabIndex: 6,
                              route: ManageCategoriesPage.routeName));
                        }),
                    SettingOption(
                        icon: Icons.picture_as_pdf_outlined,
                        title: LocaleKeys.export.tr(),
                        action: () {
                          context.read<NavigationBloc>().add(NavigateTab(
                              tabIndex: 0, route: StatisticsPage.routeName));
                        }),
                    const ChangeLanguage(),
                    SettingOption(
                        icon: Icons.help_center_outlined,
                        title: LocaleKeys.faq.tr(),
                        action: () {
                          context.read<NavigationBloc>().add(NavigateTab
                            (tabIndex: 8, route: FAQPage.routeName));
                        }),
                    SettingOption(
                      icon: Icons.logout_outlined,
                      title: LocaleKeys.logout.tr(),
                      action: () {
                        context.read<UserBloc>().add(SignOutEvent());
                      },
                      arrow: false,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails details) {
    setState(() {
      _tapPosition = details.globalPosition;
    });
  }

  void _showDeleteOption(BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    final switchLanguage = await showMenu(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          if (context.locale.languageCode == 'uk') ...[
            const PopupMenuItem(value: 'en', child: Text('Switch to English'))
          ] else ...[
            const PopupMenuItem(value: 'uk', child: Text('Українською'))
          ]
        ]).then((value) {
      if (value != null) {
          context.setLocale(Locale(value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTapDown: (details) => _getTapPosition(details),
      onTap: () {
        _showDeleteOption(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(
                  Icons.translate_outlined,
                  color: AppColors.subTitle,
                  size: 24,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  LocaleKeys.language.tr(),
                  style: AppStyles.body2,
                )
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.borderGrey,
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}
