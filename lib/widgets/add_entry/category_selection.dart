import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/models/entry_category_model/entry_category.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/icon_view.dart';

class CategorySelection extends StatelessWidget {
  const CategorySelection({
    Key? key,
    required this.categories,
    required this.controller,
    this.addCategory,
  }) : super(key: key);
  final List<EntryCategory> categories;
  final PersistentBottomSheetController controller;
  final Widget? addCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: AppColors.slidingPanel,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: AppColors.title.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5))
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppIcons.drag),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'CHOOSE CATEGORY',
            style: AppStyles.overline,
          ),
          const SizedBox(
            height: 16,
          ),
          Flexible(
            child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<DatabaseBloc>().add(
                                GetCategoryEvent(categories[index]));
                          controller.close();
                        },
                        iconSize: 60,
                        icon: IconView(
                          icon: categories[index].icon.localPath,
                          color: categories[index].icon.color,
                        ),
                      ),
                      Text(
                        categories[index].title,
                        style: AppStyles.caption,
                      ),
                    ],
                  );
                }),
          ),
          addCategory ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}
