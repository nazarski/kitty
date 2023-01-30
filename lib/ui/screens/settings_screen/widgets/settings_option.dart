import 'package:flutter/material.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';

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