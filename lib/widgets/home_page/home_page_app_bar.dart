import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';

class HomePageAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomePageAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 100,
        leading: Row(
          children: [
            SvgPicture.asset(
              AppIcons.logo,
              height: 24,
              width: 24,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              'Kitty',
              style: AppStyles.menuPageTitle,
            )
          ],
        ),
        actions: [
          SvgPicture.asset(AppIcons.search),
          const SizedBox(
            width: 16,
          ),
          Container(
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
              color: AppColors.basicGrey,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'N',
                style: AppStyles.buttonBlack,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(0, 48);
}