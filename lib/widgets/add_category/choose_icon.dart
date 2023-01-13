import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/icon_view.dart';

class ChooseIcon extends StatelessWidget {
  const ChooseIcon({
    Key? key,
    required this.iconList,
    required this.controller,
  }) : super(key: key);

  final List<Map<String, String>> iconList;
  final PersistentBottomSheetController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseBloc, DatabaseState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
              color: AppColors.slidingPanel,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
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
                'CHOOSE CATEGORY ICON',
                style: AppStyles.overline,
              ),
              const SizedBox(
                height: 16,
              ),
              Flexible(
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: iconList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (_, index) {
                        return IconButton(
                            iconSize: 48,
                            onPressed: () {
                              context
                                  .read<DatabaseBloc>()
                                  .add(GetIconEvent(iconList[index]));
                              Future.delayed(const Duration(milliseconds: 500), () {
                                controller.close();
                              });
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: state.icons.isNotEmpty &&
                                          state.icons.first.localPath ==
                                              (iconList[index]['icon']!)
                                      ? AppColors.activeBlue
                                      : null,
                                  shape: BoxShape.circle),
                              child: IconView(
                                icon: iconList[index]['icon']!,
                                color: iconList[index]['color']!,
                              ),
                            ));
                      }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
