import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/models/income_category_model/income_category.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/utils/helper.dart';

class AddEntry extends StatefulWidget {
  const AddEntry({Key? key}) : super(key: key);
  static const String routeName = 'add_entry';

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
  // late final animationController;

  @override
  void initState() {
    focusNode.addListener((onFocus));
    // animationController = AnimationController(vsync: this.);
    super.initState();
  }

  void onFocus() {
    if (!focusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  PersistentBottomSheetController? bottomSheetController;
  final categoryController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final focusNode = FocusNode();
  final scrollController = ScrollController();

  String option = 'entry';

  void _closeBottomSheet() {
    if (bottomSheetController != null) {
      bottomSheetController!.close();
    }
  }

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
          appBar: AppBar(
            backgroundColor: AppColors.borderGrey,
            leading: IconButton(
              icon: SvgPicture.asset(AppIcons.arrowBack),
              onPressed: () {
                _closeBottomSheet();
                context.read<NavigationBloc>().add(NavigationPop());
              },
            ),
            title: const Text(
              'Add new',
              style: AppStyles.subtitle1,
            ),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
              child: Column(
                children: [
                  DropdownButtonFormField(
                    onTap: _closeBottomSheet,
                    onChanged: (value) {
                      if(state.categoryToAdd.isNotEmpty){
                        context.read<DatabaseBloc>().add(InitialDatabaseEvent());
                      }
                      setState(() {
                        option = value!;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    hint: const Text('Select'),
                    isDense: true,
                    items: const [
                      DropdownMenuItem(value: 'income', child: Text('Income')),
                      DropdownMenuItem(value: 'expense', child: Text('Expense'))
                    ],
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
                            } if(option == 'expense') {
                              return CategorySelection(
                                controller: bottomSheetController!,
                                categories: state.expCategories,
                                addCategory: OutlinedButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Add new category',
                                      style: TextStyle(
                                          color: AppColors.activeBlue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    )),
                              );
                            }
                            return SizedBox.shrink();
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
                    // focusNode: focusNode,
                    onTap: _closeBottomSheet,
                    textInputAction: TextInputAction.go,
                    onEditingComplete: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                      });
                    },
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
                    // focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Visibility(
                      visible: option != 'entry' &&
                          amountController.text.isNotEmpty &&
                          state.categoryToAdd.isNotEmpty,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              padding: const MaterialStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 12)),
                              backgroundColor: const MaterialStatePropertyAll(
                                  AppColors.activeBlue),
                              textStyle: const MaterialStatePropertyAll(
                                  AppStyles.buttonWhite),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50)))),
                          onPressed: () {},
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width - 32,
                              child: Center(child: Text('Add new $option')))),
                    ),
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

class CategorySelection extends StatelessWidget {
  const CategorySelection({
    Key? key,
    required this.categories,
    required this.controller,
    this.addCategory,
  }) : super(key: key);
  final List categories;
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
                            if (categories[index] is IncomeCategory) {
                              context
                                  .read<DatabaseBloc>()
                                  .add(GetIncomeCategoryEvent(categories[index]));
                            } else {
                              context.read<DatabaseBloc>().add(
                                  GetExpenseCategoryEvent(categories[index]));
                            }
                            controller.close();
                          },
                          iconSize: 60,
                          icon: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: fromHex(categories[index].icon.color),
                            ),
                            child: SvgPicture.asset(
                                categories[index].icon.pathToIcon),
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
      ),
    );
  }
}
