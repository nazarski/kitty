import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/initial_values.dart';
import 'package:kitty/widgets/add_category/choose_icon.dart';
import 'package:kitty/widgets/icon_view.dart';
import 'package:kitty/widgets/navigation/back_app_bar.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);
  static const routeName = 'add_category';

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
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

  final List<Map<String, String>> iconList = [
    ...InitialValues.expenseIcons.values.toList(),
    ...InitialValues.incomeIcons.values.toList()
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        _closeBottomSheet();
        return true;
      },
      child: BlocBuilder<DatabaseBloc, DatabaseState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
                onPressed: () {},
                label: SizedBox(
                  width: width - 64,
                  child: const Center(child: Text('Add new category')),
                )),
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
                                  return ChooseIcon(iconList: iconList, controller: bottomSheetController!,);
                                });
                            setState(() {});
                          },
                          icon: state.icons.isNotEmpty
                              ? IconView(
                                  icon: state.icons.first.pathToIcon,
                                  color: state.icons.first.color,
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
                          controller: categoryController,
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
