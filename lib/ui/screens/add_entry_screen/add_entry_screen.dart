
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/ui/bloc/entries_control_bloc/entries_control_bloc.dart';
import 'package:kitty/ui/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/ui/screens/add_category_screen/add_category_screen.dart';
import 'package:kitty/ui/widgets/navigation/back_app_bar.dart';

import 'widgets/add_entry_button.dart';
import 'widgets/category_dropdown.dart';
import 'widgets/category_selection.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({Key? key}) : super(key: key);
  static const String routeName = 'add_entry';

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {

  void _closeBottomSheet() {
    if (bottomSheetController != null) {
      bottomSheetController?.close();
      bottomSheetController = null;
    }
  }

  void _onComplete() {
    setState(() {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  PersistentBottomSheetController? bottomSheetController;
  final categoryController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final focusNode = FocusNode();

  String option = 'entry';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (bottomSheetController != null) {
          _closeBottomSheet();
          return false;
        }
        return true;
      },
      child: BlocBuilder<EntriesControlBloc, EntriesControlState>(
        builder: (context, state) {
          categoryController.text = state.categoryToAdd.title;
          return Scaffold(
            appBar: BackAppBar(
              text: LocaleKeys.add_new.tr(),
            ),
            body: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
                child: Column(
                  children: [
                    CategoryDropDown(
                      onTap: _closeBottomSheet,
                      onChanged: (value) {
                        if (!state.categoryToAdd.categoryId.isNegative) {
                          context
                              .read<EntriesControlBloc>()
                              .add(InitialDatabaseEvent());
                        }
                        setState(
                          () {
                            option = value!;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      readOnly: true,
                      controller: categoryController,
                      onTap: () {
                        bottomSheetController =
                            buildShowBottomSheet(context, state);
                      },
                      decoration: InputDecoration(
                        labelText: LocaleKeys.category_name.tr(),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextField(
                      onTap: _closeBottomSheet,
                      textInputAction: TextInputAction.go,
                      onEditingComplete: _onComplete,
                      keyboardType: TextInputType.number,
                      controller: amountController,
                      maxLength: 12,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.enter_amount.tr(),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextField(
                      onTap: _closeBottomSheet,
                      onEditingComplete: _onComplete,
                      maxLength: 24,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.description.tr(),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ValueListenableBuilder(
                      valueListenable: amountController,
                      builder: (BuildContext context, TextEditingValue value,
                          Widget? child) {
                        return AddEntryButton(
                          option: option,
                          isActive: state.categoryToAdd.title.isNotEmpty &&
                              option != 'entry' &&
                              value.text.isNotEmpty,
                          action: () {
                            _closeBottomSheet();
                            context.read<EntriesControlBloc>().add(
                                  CreateEntryEvent(
                                    amount: option == 'expense'
                                        ? '-${value.text}'
                                        : value.text,
                                    description: descriptionController.text,
                                  ),
                                );
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PersistentBottomSheetController<dynamic> buildShowBottomSheet(
      BuildContext context, EntriesControlState state) {
    return showBottomSheet(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
      enableDrag: false,
      context: context,
      builder: (context) {
        if (option == 'income') {
          return CategorySelection(
            categories: state.inCategories,
          );
        }
        if (option == 'expense') {
          return CategorySelection(
            categories: state.expCategories,
            addCategory: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<NavigationBloc>().add(
                    NavigateTab(tabIndex: 4, route: AddCategoryScreen
                        .routeName));
              },
              child: Text(
                LocaleKeys.add_category.tr(),
                style: const TextStyle(
                    color: AppColors.activeBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
