import 'package:flutter/material.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
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
    return BlocBuilder<DatabaseBloc, DatabaseState>(builder: (context, state) {
      return WillPopScope(
        onWillPop: () async {
          _closeBottomSheet();
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: BackAppBar(
            text: 'Add new',
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
                      if (state.categoryToAdd.isNotEmpty) {
                        context
                            .read<DatabaseBloc>()
                            .add(InitialDatabaseEvent());
                      }
                      setState(() {
                        option = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    readOnly: true,
                    controller: categoryController..text = state.categoryToAdd,
                    onTap: () {
                      bottomSheetController = showBottomSheet(
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height / 2),
                          enableDrag: false,
                          context: context,
                          builder: (_) {
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
                                        NavigateTab(
                                            tabIndex: 4,
                                            route: AddCategory.routeName));
                                  },
                                  child: const Text(
                                    'Add new category',
                                    style: TextStyle(
                                        color: AppColors.activeBlue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Category name',
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
                    decoration: const InputDecoration(
                      labelText: 'Enter amount',
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextField(
                    onTap: _closeBottomSheet,
                    onEditingComplete: _onComplete,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
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
                        isActive: state.categoryToAdd.isNotEmpty &&
                            option != 'entry' &&
                            value.text.isNotEmpty,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
