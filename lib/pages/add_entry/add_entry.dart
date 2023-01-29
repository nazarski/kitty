import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/pages/add_category/add_category.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/widgets/add_entry/add_entry_button.dart';
import 'package:kitty/widgets/add_entry/category_dropdown.dart';
import 'package:kitty/widgets/add_entry/category_selection.dart';
import 'package:kitty/widgets/navigation/back_app_bar.dart';

class AddEntry extends StatefulWidget {
  const AddEntry({Key? key}) : super(key: key);
  static const String routeName = 'add_entry';

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
  void _closeBottomSheet() {
    if (bottomSheetController != null) {
      bottomSheetController!.close();
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
  final scrollController = ScrollController();

  String option = 'entry';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntriesControlBloc, EntriesControlState>(
      builder: (context, state) {
          categoryController.text = state.categoryToAdd.title;
        return WillPopScope(
          onWillPop: () async {
            _closeBottomSheet();
            return true;
          },
          child: Scaffold(
            appBar: BackAppBar(
              text: LocaleKeys.add_new.tr(),
              back: _closeBottomSheet,
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
                            context.read<EntriesControlBloc>().add(
                                  CreateEntryEvent(
                                    amount: option == 'expense'
                                        ? '-${value.text}'
                                        : value.text,
                                    description: descriptionController.text,
                                  ),
                                );
                            context.read<NavigationBloc>().add(NavigationPop());
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
            controller: bottomSheetController!,
            categories: state.inCategories,
          );
        }
        if (option == 'expense') {
          return CategorySelection(
            controller: bottomSheetController!,
            categories: state.expCategories,
            addCategory: OutlinedButton(
              onPressed: () {
                _closeBottomSheet();
                context.read<NavigationBloc>().add(
                    NavigateTab(tabIndex: 4, route: AddCategory.routeName));
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
