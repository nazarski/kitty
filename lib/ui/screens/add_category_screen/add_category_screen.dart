import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/domain/resources/app_colors.dart';
import 'package:kitty/domain/resources/app_icons.dart';
import 'package:kitty/domain/resources/app_text_styles.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/ui/bloc/entries_control_bloc/entries_control_bloc.dart';
import 'package:kitty/ui/widgets/choose_icon.dart';
import 'package:kitty/ui/widgets/icon_view.dart';
import 'package:kitty/ui/widgets/navigation/back_app_bar.dart';
import 'package:kitty/ui/widgets/snack_bar_builder.dart';



class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);
  static const routeName = 'add_category';

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  PersistentBottomSheetController? bottomSheetController;

  final categoryController = TextEditingController();

  void _closeBottomSheet() {
    if (bottomSheetController != null) {
      bottomSheetController!.close();
      bottomSheetController = null;
    }
  }

  void _onComplete() {
    setState(() {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (bottomSheetController != null){
          _closeBottomSheet();
          return false;
        }
        return true;
      },
      child: BlocBuilder<EntriesControlBloc, EntriesControlState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ValueListenableBuilder(
              valueListenable: categoryController,
              builder: (BuildContext context, TextEditingValue value,
                  Widget? child) {
                return ElevatedButton(
                    style: AppStyles.buttonStyle,
                    onPressed: !state.selectedIcon.iconId.isNegative &&
                            value.text.isNotEmpty
                        ? () {
                            context.read<EntriesControlBloc>().add(
                                CreateExpenseCategoryEvent(
                                    categoryName: value.text,
                                    selectedIcon: state.selectedIcon));
                            Navigator.of(context).pop();
                            buildShowSnackBar(context, LocaleKeys
                                .edited_category.tr());
                    }
                        : null,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Center(
                          heightFactor: 1, child: Text(LocaleKeys
                          .add_category.tr())),
                    ));
              },
            ),
            appBar: BackAppBar(
              text: LocaleKeys.add_new.tr(),
              back: _closeBottomSheet,
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DottedBorder(
                    padding: EdgeInsets.zero,
                    borderType: BorderType.Circle,
                    color: bottomSheetController == null
                        ? AppColors.title
                        : AppColors.activeBlue,
                    strokeWidth: 2,
                    dashPattern: const [5, 2],
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (FocusScope.of(context).hasFocus) {
                          FocusScope.of(context).unfocus();
                          Future.delayed(const Duration(seconds: 2));
                        }
                        bottomSheetController = showBottomSheet(
                            context: context,
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height / 2),
                            enableDrag: false,
                            builder: (_) {
                              return ChooseIcon(
                                iconList: state.icons,
                                controller: bottomSheetController!,
                              );
                            });
                        setState(() {});
                      },
                      icon: !state.selectedIcon.iconId.isNegative
                          ? IconView(
                              icon: state.selectedIcon.localPath,
                              color: state.selectedIcon.color,
                            )
                          : const IconView(
                              icon: AppIcons.addPlus,
                              color: 'E0E0E0',
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: TextField(
                      onTap: _closeBottomSheet,
                      maxLength: 24,
                      onEditingComplete: _onComplete,
                      controller: categoryController,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.category_name.tr(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
