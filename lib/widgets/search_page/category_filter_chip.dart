import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/search_bloc/search_bloc.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/utils/helper.dart';

class CategoryFilterChip extends StatefulWidget {
  const CategoryFilterChip({
    Key? key,
    required this.icon,
    required this.title,
    required this.categoryId, required this.selected,
  }) : super(key: key);
  final String icon;
  final String title;
  final int categoryId;
final bool selected;
  @override
  State<CategoryFilterChip> createState() => _CategoryFilterChipState();
}

class _CategoryFilterChipState extends State<CategoryFilterChip> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<SearchBloc>()
            .add(CategorySearchEvent(categoryId: widget.categoryId));
      },
      child: widget.selected
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.activeBlue),
                color: fromHex('DBEEFC'),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check,
                    color: AppColors.activeBlue,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.title,
                    style: AppStyles.body2,
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    widget.icon,
                    color: AppColors.subTitle, height: 20, width: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.title,
                    style: AppStyles.body2,
                  ),
                ],
              ),
            ),
    );
  }
}
