import 'package:flutter/material.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';

class PlaceHolder extends StatelessWidget {
  const PlaceHolder({
    Key? key,
    required this.listOfMonths,
  }) : super(key: key);

  final List<String> listOfMonths;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppColors.basicGrey),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.subTitle,
              size: 16,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              '${listOfMonths[DateTime.now().month - 1]}, ${DateTime.now().year}',
              style: AppStyles.buttonBlack,
            )
          ],
        ),
      ),
    );
  }
}
