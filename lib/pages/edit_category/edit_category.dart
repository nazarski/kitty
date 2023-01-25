import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/add_category/choose_icon.dart';
import 'package:kitty/widgets/icon_view.dart';
import 'package:kitty/widgets/navigation/back_app_bar.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({Key? key}) : super(key: key);
  static const routeName = '/edit_category';

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  PersistentBottomSheetController? bottomSheetController;

  final categoryController = TextEditingController();

  void _closeBottomSheet() {
    if (bottomSheetController != null) {
      bottomSheetController!.close();
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
        _closeBottomSheet();
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
                    onPressed: state.selectedIcon != null &&
                            value.text.isNotEmpty
                        ? () {
                            context.read<EntriesControlBloc>().add(
                                EditCategoryEvent(
                                    newTitle: categoryController.text,
                                    icon: state.selectedIcon!));
                            context.read<NavigationBloc>().add(NavigationPop());
                          }
                        : null,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: const Center(
                          heightFactor: 1, child: Text('Edit category')),
                    ));
              },
            ),
            appBar: BackAppBar(
              text: 'Add new',
              back: _closeBottomSheet,
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      DottedBorder(
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
                          icon: state.selectedIcon != null
                              ? IconView(
                                  icon: state.selectedIcon!.localPath,
                                  color: state.selectedIcon!.color,
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
                      Flexible(
                        child: TextField(
                          onTap: _closeBottomSheet,
                          onEditingComplete: _onComplete,
                          controller: categoryController
                            ..text = state.categoryToAdd!.title,
                          decoration: const InputDecoration(
                            labelText: 'Category name',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
