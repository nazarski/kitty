import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/pages/add_category/add_category.dart';
import 'package:kitty/pages/edit_category/edit_category.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/icon_view.dart';
import 'package:kitty/widgets/navigation/back_app_bar.dart';

class ManageCategoriesPage extends StatefulWidget {
  const ManageCategoriesPage({Key? key}) : super(key: key);
  static const routeName = '/edit_categories_page';

  @override
  State<ManageCategoriesPage> createState() => _ManageCategoriesPageState();
}

class _ManageCategoriesPageState extends State<ManageCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        text: 'Manage categories',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<NavigationBloc>().add(
              NavigateTab(tabIndex: 4, route: AddCategory.routeName));
        },
        label: const Text(
          'Add new category',
          style: AppStyles.buttonWhite,
        ),
      ),
      body: BlocBuilder<EntriesControlBloc, EntriesControlState>(
        builder: (context, state) {
          return ReorderableListView.builder(
              onReorderStart: (_) {
                HapticFeedback.vibrate();
              },
              padding: const EdgeInsets.only(top: 12),
              itemBuilder: (context, index) {
                return ListTile(
                  key: ValueKey(index),
                  leading: SizedBox(
                    height: 40,
                    child: IconView(
                      icon: state.expCategories[index].icon.localPath,
                      color: state.expCategories[index].icon.color,
                    ),
                  ),
                  title: Text(state.expCategories[index].title,
                      style: AppStyles.body2),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                          onPressed: () {
                            context.read<EntriesControlBloc>().add(
                                GetCategoryEvent(state.expCategories[index]));
                            context.read<EntriesControlBloc>().add(
                                GetIconEvent(state.expCategories[index].icon));
                            context.read<NavigationBloc>().add(NavigateTab(
                                  tabIndex: 7,
                                  route: EditCategory.routeName,
                                ));
                          },
                          child: const Text(
                            'Edit',
                            style: AppStyles.button,
                          )),
                      const SizedBox(
                        width: 12,
                      ),
                      const Icon(
                        Icons.drag_indicator_outlined,
                        color: AppColors.subTitle,
                      )
                    ],
                  ),
                );
              },
              itemCount: state.expCategories.length,
              onReorder: (oldIndex, newIndex) {
                context.read<EntriesControlBloc>().add(ReorderCategoriesEvent(
                    oldIndex: oldIndex, newIndex: newIndex));
              });
        },
      ),
    );
  }
}
