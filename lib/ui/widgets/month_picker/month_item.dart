import 'package:flutter/material.dart';
import 'package:kitty/domain/resources/app_colors.dart';
import 'package:kitty/domain/resources/app_text_styles.dart';

class MonthItem extends StatelessWidget {
  const MonthItem({
    Key? key,
    required this.month,
    required this.isActive,
    required this.inRange,
    required this.onTap,
  }) : super(key: key);
  final String month;
  final bool isActive;
  final bool inRange;
  final VoidCallback onTap;

  MonthItemStatus _getStatus() {
    if (isActive) {
      return MonthItemStatus.selected;
    }
    if (inRange) {
      return MonthItemStatus.enabled;
    }
    return MonthItemStatus.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final status = _getStatus();
    switch (status) {
      case MonthItemStatus.disabled:
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGrey)),
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: double.infinity,
          child: Center(
            child: Text(
              month,
              style: AppStyles.buttonInactive,
            ),
          ),
        );
      case MonthItemStatus.enabled:
        return InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderGrey)),
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            child: Center(
              child: Text(
                month,
                style: AppStyles.buttonBlack,
              ),
            ),
          ),
        );
      case MonthItemStatus.selected:
        return Container(
          decoration: BoxDecoration(
              color: AppColors.activeBlue,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGrey)),
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: double.infinity,
          child: Center(
            child: Text(
              month,
              style: AppStyles.buttonWhite,
            ),
          ),
        );
    }
  }
}

enum MonthItemStatus { disabled, enabled, selected }