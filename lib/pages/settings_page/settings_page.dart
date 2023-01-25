import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/pages/manage_categories_page/manage_categories_page.dart';
import 'package:kitty/pages/statistics_page/statistics_page.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const routeName = '/settings_page';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.basicGrey,
                ),
                padding: const EdgeInsets.only(
                    top: 12, left: 16, bottom: 24, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Settings',
                      style: AppStyles.menuPageTitle,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Wrap(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text('N', style: AppStyles.menuPageTitle),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Nethan Bukovski',
                              style: AppStyles.subtitle1,
                            ),
                            Text(
                              'nethanB@bing.com',
                              style: AppStyles.caption,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SettingOption(
                      icon: Icons.category_outlined,
                      title: 'Manage categories',
                      action: () {
                        context.read<NavigationBloc>().add(NavigateTab(
                            tabIndex: 6, route: ManageCategoriesPage.routeName));
                      }),
                  SettingOption(
                      icon: Icons.picture_as_pdf_outlined,
                      title: 'Export to PDF',
                      action: () {
                        context.read<NavigationBloc>().add(NavigateTab
                          (tabIndex: 0, route: StatisticsPage.routeName));
                      }),
                  SettingOption(
                      icon: Icons.translate_outlined,
                      title: 'Choose language',
                      action: () {}),
                  SettingOption(
                      icon: Icons.help_center_outlined,
                      title: 'Frequently asked questions',
                      action: () {}),
                  SettingOption(
                    icon: Icons.logout_outlined,
                    title: 'Logout',
                    action: () {},
                    arrow: false,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingOption extends StatelessWidget {
  const SettingOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.action,
    this.arrow = true,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final bool arrow;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(
                  icon,
                  color: AppColors.subTitle,
                  size: 24,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: AppStyles.body2,
                )
              ],
            ),
            if (arrow) ...[
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.borderGrey,
                size: 24,
              )
            ]
          ],
        ),
      ),
    );
  }
}
